import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// AppLocale is just a short code. Keep it simple.
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

/// Controls and persists the current locale.
/// Call `value = 'ar'` to switch; listeners rebuild.
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
  }

  /// First load: URL ?lang= overrides prefs (web), else prefs, else initial.
  Future<void> _bootstrap() async {
    AppLocale? fromUrl;
    if (kIsWeb) {
      final code = Uri.base.queryParameters['lang'];
      if (code != null && code.isNotEmpty) fromUrl = _normalize(code);
    }

    final sp = await SharedPreferences.getInstance();
    final fromPrefs = sp.getString(_kPrefKey);

    final picked = fromUrl ?? fromPrefs;
    if (picked != null) {
      final n = _normalize(picked, fallback: _value);
      if (n != _value) {
        _value = n;
        notifyListeners();
      }
    }
    _loaded = true;
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
