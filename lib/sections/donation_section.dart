import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    final title = t(DonationContent.title, locale);
    final subtitle = t(DonationContent.subtitle, locale);
    final bank = t(DonationContent.bankDetails, 'he');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),

        // Pay by Card (primary CTA)
        SizedBox(
          width: isMobile ? double.infinity : 280,
          child: FilledButton.icon(
            onPressed: () {
              // TODO: link to Stripe/PayPal or processor
            },
            icon: const Icon(Icons.lock_outline),
            label: Text(t(DonationContent.cardCta, locale)),
          ),
        ),

        const SizedBox(height: 24),

        // Bank Transfer (secondary)
        ExpansionTile(
          initiallyExpanded: false,
          leading: const Icon(Icons.account_balance, color: Brand.green),
          title: Text(t(DonationContent.bankTitle, locale)),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(
                bank,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  // copy to clipboard
                  Clipboard.setData(ClipboardData(text: bank));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t(DonationContent.copied, locale))),
                  );
                },
                icon: const Icon(Icons.copy),
                label: Text(t(DonationContent.copyCta, locale)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
