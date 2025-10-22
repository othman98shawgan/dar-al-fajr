// lib/i18n/locale_scope.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Use modern web bindings instead of dart:html
import 'package:web/web.dart' as web;

/// AppLocale is just a short code.
typedef AppLocale = String; // 'en' | 'ar' | 'he'

const _kPrefKey = 'app_locale';
const _supportedLocales = {'en', 'ar', 'he'};

bool isRtlLocale(AppLocale l) => l == 'ar' || l == 'he';

AppLocale _normalize(AppLocale? raw, {AppLocale fallback = 'en'}) {
  if (raw == null) return fallback;
  final c = raw.toLowerCase();
  // Accept 'en', 'ar', 'he' or 'en-US' style → take first 2
  final short = c.contains('-') ? c.split('-').first : c;
  return _supportedLocales.contains(short) ? short : fallback;
}

/// --- Web helpers: read/patch URL path for locale ---
String? _pathLocaleWeb() {
  if (!kIsWeb) return null;
  final segs = Uri.base.pathSegments;
  if (segs.isEmpty) return null;
  final first = segs.first.trim().toLowerCase();
  return _supportedLocales.contains(first) ? first : null;
}

void _rewriteUrlWithLocaleWeb(AppLocale locale) {
  if (!kIsWeb) return;
  final current = Uri.base;
  final segs = List<String>.from(current.pathSegments);

  if (segs.isEmpty) {
    // No path -> add locale
    final newUri = Uri(
      path: '/$locale',
      queryParameters: current.queryParameters.isEmpty ? null : current.queryParameters,
      fragment: current.fragment.isEmpty ? null : current.fragment,
    );
    web.window.history.replaceState(null, '', newUri.toString());
    return;
  }

  if (_supportedLocales.contains(segs.first.toLowerCase())) {
    // Replace existing locale seg
    segs[0] = locale;
  } else {
    // Prefix with locale
    segs.insert(0, locale);
  }

  // Normalize double slashes and trailing
  final newPath = '/${segs.join('/')}'.replaceAll(RegExp(r'//+'), '/');
  final newUri = Uri(
    path: newPath,
    queryParameters: current.queryParameters.isEmpty ? null : current.queryParameters,
    fragment: current.fragment.isEmpty ? null : current.fragment,
  );
  web.window.history.replaceState(null, '', newUri.toString());
}

/// Controls and persists the current locale.
/// Call `value = 'ar'` to switch; listeners rebuild.
/// On web, the URL will be rewritten to include the locale in the first path segment.
class LocaleController extends ChangeNotifier {
  AppLocale _value;
  bool _loaded = false;

  LocaleController([AppLocale initial = 'en']) : _value = _normalize(initial) {
    _bootstrap();
  }

  AppLocale get value => _value;

  set value(AppLocale v) {
    final next = _normalize(v, fallback: _value);
    if (_value == next) return;
    _value = next;
    notifyListeners();
    _save();
    if (kIsWeb) {
      _rewriteUrlWithLocaleWeb(_value); // keep URL canonical
    }
  }

  /// First load priority:
  /// 1) Web path `/:locale/...`
  /// 2) Web query `?lang=xx`
  /// 3) Saved prefs
  /// 4) Initial (constructor) value
  ///
  /// If no locale in path, we rewrite URL to include the chosen one (web).
  Future<void> _bootstrap() async {
    AppLocale? chosen;

    // 1) URL path (/:locale/...)
    final fromPath = _pathLocaleWeb();
    if (fromPath != null) {
      chosen = _normalize(fromPath);
    } else {
      // 2) Query param ?lang=xx (web only)
      AppLocale? fromUrl;
      if (kIsWeb) {
        final code = Uri.base.queryParameters['lang'];
        if (code != null && code.isNotEmpty) fromUrl = _normalize(code);
      }

      // 3) Shared prefs
      final sp = await SharedPreferences.getInstance();
      final fromPrefs = sp.getString(_kPrefKey);

      chosen = fromUrl ?? fromPrefs ?? _value; // fall back to initial
    }

    // Apply if different
    final normalized = _normalize(chosen, fallback: _value);
    final changed = normalized != _value;
    _value = normalized;

    // Persist and URL-rewrite if needed
    if (kIsWeb) {
      // Ensure URL carries the locale in first path segment
      final hasPathLocale = _pathLocaleWeb() != null;
      if (!hasPathLocale || changed) {
        _rewriteUrlWithLocaleWeb(_value);
      }
    }

    if (changed) notifyListeners();
    _loaded = true;
    // Also save chosen locale
    _save();
  }

  Future<void> _save() async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setString(_kPrefKey, _value);
    } catch (_) {
      // ignore
    }
  }

  bool get isLoaded => _loaded;
}

/// Inherited holder for LocaleController
class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope not found above in the widget tree.');
    return scope!.notifier!;
  }
}
