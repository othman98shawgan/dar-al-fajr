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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 700;
    const double bankCardMaxWidth = 480;

    final title = t(DonationContent.title, locale);
    final subtitle = t(DonationContent.subtitle, locale);

    // Always render Hebrew bank details as requested
    final bankBlock = t(DonationContent.bankDetails, 'he');

    final bankTitle = t(DonationContent.bankTitle, locale);
    final copyCta = t(DonationContent.copyCta, locale);
    final copiedMsg = t(DonationContent.copied, locale);

    final donateCta = t(DonationContent.cardCta, locale);
    final studentCta = t(DonationContent.studentCta, locale);

    final donateUrl = ContentConfig.donateUrl;
    final studentUrl = ContentConfig.studentPayUrl;

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

        const SizedBox(height: 24),

        // === Two centered CTAs (row on desktop, stacked on mobile) ===
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: bankCardMaxWidth * 2),
            child: Wrap(
              spacing: isMobile ? 0 : 32,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: ctaWidth,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: Size(ctaWidth, ctaHeight),
                      padding: ctaPadding,
                      textStyle: ctaTextStyle,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: donateUrl.isEmpty
                        ? null
                        : () => launchUrl(Uri.parse(donateUrl), mode: LaunchMode.externalApplication),
                    icon: Icon(Icons.volunteer_activism, size: ctaIconSize, color: Brand.green),
                    label: Text(donateCta, style: const TextStyle(color: Brand.green)),
                  ),
                ),
                SizedBox(
                  width: ctaWidth,
                  child: FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      minimumSize: Size(ctaWidth, ctaHeight),
                      padding: ctaPadding,
                      textStyle: ctaTextStyle,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: studentUrl.isEmpty
                        ? null
                        : () => launchUrl(Uri.parse(studentUrl), mode: LaunchMode.externalApplication),
                    icon: Icon(Icons.school, size: ctaIconSize, color: Brand.green),
                    label: Text(studentCta, style: const TextStyle(color: Brand.green)),
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
                    // keep the RTL block if you added it earlier:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: SelectableText.rich(_buildBankDetailsSpan(bankBlock))),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () async {/* copy */},
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
