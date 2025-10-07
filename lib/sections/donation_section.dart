import 'dart:convert'; // LineSplitter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../i18n/locale_scope.dart';
import '../theme/brand.dart';
import '../content/site_content.dart';

class DonationSection extends StatelessWidget {
  final AppLocale locale;
  const DonationSection({super.key, required this.locale});

  static const _providerDomain = 'sumit.co.il';

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 700;
    const double bankCardMaxWidth = 480;

    final title = t(DonationContent.title, locale);
    final subtitle = t(DonationContent.subtitle, locale);

    // Always show Hebrew bank details
    final bankBlock = t(DonationContent.bankDetails, 'he');

    final bankTitle = t(DonationContent.bankTitle, locale);
    final copyCta = t(DonationContent.copyCta, locale);
    final copiedMsg = t(DonationContent.copied, locale);

    final donateCta = t(DonationContent.cardCta, locale);
    final studentCta = t(DonationContent.studentCta, locale);

    final donateUrl = ContentConfig.donateUrl;
    final studentUrl = ContentConfig.studentPayUrl;

    final providerNote = t({
      'en': 'Payments are securely processed by $_providerDomain',
      'ar': 'يتم معالجة المدفوعات بأمان عبر $_providerDomain',
      'he': 'התשלומים מעובדים באופן מאובטח דרך $_providerDomain',
    }, locale);

    // CTA sizing
    final ctaWidth = isMobile ? double.infinity : (w < 1200 ? 320.0 : 360.0);
    final ctaHeight = isMobile ? 48.0 : 60.0;
    final ctaPadding = EdgeInsets.symmetric(
      horizontal: isMobile ? 16 : 22,
      vertical: isMobile ? 12 : 16,
    );
    final ctaTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        );
    final ctaIconSize = isMobile ? 20.0 : 24.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),

        const SizedBox(height: 20),

        // Provider badge (outside the buttons)
        Center(child: _ProviderBadge(text: providerNote)),

        const SizedBox(height: 16),

        // === Two centered CTAs (row on desktop, stacked on mobile) ===
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: bankCardMaxWidth * 2),
            child: Wrap(
              spacing: isMobile ? 0 : 32,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                // Donate by card (filled)
                SizedBox(
                  width: ctaWidth,
                  height: ctaHeight,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: ctaPadding,
                      textStyle: ctaTextStyle,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: donateUrl.isEmpty ? null : () => _safeLaunch(context, donateUrl),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.volunteer_activism, size: ctaIconSize, color: Brand.green),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            donateCta,
                            style: const TextStyle(color: Brand.green),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Student payment (tonal)
                SizedBox(
                  width: ctaWidth,
                  height: ctaHeight,
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      padding: ctaPadding,
                      textStyle: ctaTextStyle,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: studentUrl.isEmpty ? null : () => _safeLaunch(context, studentUrl),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school, size: ctaIconSize, color: Brand.green),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            studentCta,
                            style: const TextStyle(color: Brand.green),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // === Always-visible Bank details card ===
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: bankCardMaxWidth),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.account_balance, color: Brand.green),
                      const SizedBox(width: 8),
                      Text(bankTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 16),
                    // Hebrew block should flow RTL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: SelectableText.rich(
                            _buildBankDetailsSpan(bankBlock),
                            style: const TextStyle(fontFamily: 'monospace', height: 1.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: bankBlock));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(copiedMsg)),
                              );
                            }
                          },
                          icon: const Icon(Icons.copy),
                          label: Text(copyCta),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Safety wrapper: confirm & verify the domain before launching.
  Future<void> _safeLaunch(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final host = uri.host.toLowerCase();
    final trusted = host == _providerDomain || host.endsWith('.$_providerDomain');

    if (!trusted) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Unsafe link'),
          content: Text('This link points to:\n$host\n\nExpected domain: $_providerDomain'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ],
        ),
      );
      return;
    }

    final proceed = await _confirmExternalLaunchDialog(context, uri);
    if (proceed != true) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<bool?> _confirmExternalLaunchDialog(BuildContext context, Uri uri) {
    final l = LocaleScope.of(context).value;

    final title = t({
      'en': 'Leaving site',
      'ar': 'ستغادر الموقع',
      'he': 'אתם עומדים לצאת מהאתר',
    }, l);

    // Split the message into parts so we can style the domain & URL
    final goPrefix = t({
      'en': 'You are going to ',
      'ar': 'ستنتقل إلى ',
      'he': 'אתם עוברים ל־',
    }, l);

    final verify = t({
      'en': 'Please verify the address before paying:',
      'ar': 'يرجى التحقق من العنوان قبل الدفع:',
      'he': 'אשרו שהכתובת נכונה לפני התשלום:',
    }, l);

    final cancel = t({'en': 'Cancel', 'ar': 'إلغاء', 'he': 'ביטול'}, l);
    final cont = t({'en': 'Continue', 'ar': 'متابعة', 'he': 'המשך'}, l);

    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final base = theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
        final urlStyle = base.copyWith(
          fontFamily: 'monospace', // readable URL
          fontWeight: FontWeight.w700, // bold the domain

          height: 1.3,
          fontSize: (base.fontSize ?? 14) + 2, // a bit bigger
        );

        return AlertDialog(
          title: Text(title),
          content: SelectableText.rich(
            TextSpan(
              style: base,
              children: [
                TextSpan(text: goPrefix),
                const TextSpan(text: _providerDomain),
                const TextSpan(text: '.\n'),
                TextSpan(text: '$verify\n\n'),
                TextSpan(text: uri.toString(), style: urlStyle),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(cont)),
          ],
        );
      },
    );
  }
}

/// Small centered badge under the subtitle / above CTAs.
class _ProviderBadge extends StatelessWidget {
  final String text;
  const _ProviderBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Brand.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline_rounded, size: 14, color: Brand.green),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Brand.green.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

// === Helpers to bold the "label:" part on each line ===
TextSpan _buildBankDetailsSpan(String block) {
  final lines = const LineSplitter().convert(block);
  return TextSpan(
    style: const TextStyle(fontFamily: 'monospace', height: 1.4),
    children: [
      for (int i = 0; i < lines.length; i++) ..._spansForLine(lines[i], isLast: i == lines.length - 1),
    ],
  );
}

List<TextSpan> _spansForLine(String line, {required bool isLast}) {
  final idx = line.indexOf(':');
  if (idx == -1) {
    return [TextSpan(text: line + (isLast ? '' : '\n'))];
  }
  final label = line.substring(0, idx + 1); // include colon
  final value = line.substring(idx + 1).trimLeft();
  return [
    TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.w700)),
    TextSpan(text: value),
    if (!isLast) const TextSpan(text: '\n'),
  ];
}
