import 'dart:async';
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
                    onPressed: donateUrl.isEmpty ? null : () => _launchExternal(context, donateUrl),
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
                    onPressed: studentUrl.isEmpty ? null : () => _launchExternal(context, studentUrl),
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

        // === Always-visible Bank details card with granular tap-to-copy ===
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: bankCardMaxWidth),
            child: _BankTransferCard(
              locale: locale,
              bankTitle: bankTitle,
              bankBlock: bankBlock,
              copyCta: copyCta,
              copiedMsg: copiedMsg,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchExternal(BuildContext context, String url) async {
    final trimmed = url.trim();
    final uri = Uri.tryParse(trimmed);
    bool ok = false;
    if (trimmed.isNotEmpty && uri != null) {
      try {
        ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        ok = false;
      }
    }

    if (!ok && context.mounted) {
      final errMsg = t({
        'en': 'Could not open the payment link.',
        'ar': 'تعذّر فتح رابط الدفع.',
        'he': 'לא ניתן לפתוח את קישור התשלום.',
      }, locale);
      final copyLabel = t({
        'en': 'Copy Link',
        'ar': 'نسخ الرابط',
        'he': 'העתק קישור',
      }, locale);

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(errMsg),
            action: trimmed.isNotEmpty
                ? SnackBarAction(
                    label: copyLabel,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: trimmed));
                    },
                  )
                : null,
          ),
        );
    }
  }
}

class _BankField {
  final String label;
  final String displayValue;
  final String copyValue;

  const _BankField({
    required this.label,
    required this.displayValue,
    required this.copyValue,
  });
}

class _BankTransferCard extends StatefulWidget {
  final AppLocale locale;
  final String bankTitle;
  final String bankBlock;
  final String copyCta;
  final String copiedMsg;

  const _BankTransferCard({
    required this.locale,
    required this.bankTitle,
    required this.bankBlock,
    required this.copyCta,
    required this.copiedMsg,
  });

  @override
  State<_BankTransferCard> createState() => _BankTransferCardState();
}

class _BankTransferCardState extends State<_BankTransferCard> {
  final Set<String> _copiedKeys = {};
  final Map<String, Timer> _timers = {};

  @override
  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  List<_BankField> _parseFields(String block) {
    final lines = const LineSplitter().convert(block);
    final fields = <_BankField>[];
    for (final line in lines) {
      final idx = line.indexOf(':');
      if (idx == -1) continue;
      final label = line.substring(0, idx).trim();
      final displayValue = line.substring(idx + 1).trim();
      final numMatch = RegExp(r'\d+').firstMatch(displayValue);
      final copyValue = numMatch != null ? numMatch.group(0)! : displayValue;
      fields.add(_BankField(
        label: label,
        displayValue: displayValue,
        copyValue: copyValue,
      ));
    }
    return fields;
  }

  Future<void> _copyWithConfirmation(String key, String textToCopy, {String? snackLabel}) async {
    await Clipboard.setData(ClipboardData(text: textToCopy));
    if (!mounted) return;

    _timers[key]?.cancel();
    setState(() {
      _copiedKeys.add(key);
    });

    _timers[key] = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copiedKeys.remove(key);
        });
      }
    });

    final msg = snackLabel != null ? '${widget.copiedMsg} ($snackLabel)' : widget.copiedMsg;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final fields = _parseFields(widget.bankBlock);
    final isAllCopied = _copiedKeys.contains('all');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance, color: Brand.green),
                const SizedBox(width: 8),
                Text(widget.bankTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 14),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  for (int i = 0; i < fields.length; i++) ...[
                    _buildGranularRow(fields[i], 'field_$i'),
                    if (i < fields.length - 1) const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _copyWithConfirmation('all', widget.bankBlock),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isAllCopied ? Icons.check_rounded : Icons.copy_rounded,
                      key: ValueKey<bool>(isAllCopied),
                      color: Brand.green,
                      size: 18,
                    ),
                  ),
                  label: Text(
                    isAllCopied ? widget.copiedMsg : widget.copyCta,
                    style: const TextStyle(color: Brand.green, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGranularRow(_BankField field, String key) {
    final isCopied = _copiedKeys.contains(key);

    return Material(
      color: isCopied ? Brand.green.withOpacity(0.08) : Brand.bg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _copyWithConfirmation(key, field.copyValue, snackLabel: field.copyValue),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isCopied ? Brand.green.withOpacity(0.4) : Brand.outline,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 14.5, height: 1.4, color: Brand.text),
                    children: [
                      TextSpan(
                        text: '${field.label}: ',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: field.displayValue),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isCopied ? Icons.check_rounded : Icons.copy_rounded,
                  key: ValueKey<bool>(isCopied),
                  size: 18,
                  color: isCopied ? Brand.green : Brand.green.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ),
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
