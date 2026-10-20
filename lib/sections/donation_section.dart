import 'dart:async';
import 'dart:convert';
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
    final isMobile = w < 850;
    final tt = Theme.of(context).textTheme;

    final title = t(DonationContent.title, locale);
    final subtitle = t(DonationContent.subtitle, locale);
    final recurringBadge = t(DonationContent.recurringBadge, locale);

    // Always show Hebrew bank details for Israeli banking apps
    final bankBlock = t(DonationContent.bankDetails, 'he');
    final bankTitle = t(DonationContent.bankTitle, locale);
    final copyCta = t(DonationContent.copyCta, locale);
    final copiedMsg = t(DonationContent.copied, locale);

    final donateCta = t(DonationContent.cardCta, locale);
    final studentCta = t(DonationContent.studentCta, locale);

    const donateUrl = ContentConfig.donateUrl;
    const studentUrl = ContentConfig.studentPayUrl;

    final providerNote = t({
      'en': 'Payments are securely processed by $_providerDomain',
      'ar': 'يتم معالجة المدفوعات بأمان عبر $_providerDomain',
      'he': 'התשלומים מעובדים באופן מאובטח דרך $_providerDomain',
    }, locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Brand.altBg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Brand.outline),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.autorenew_rounded, size: 16, color: Brand.green),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      recurringBadge,
                      style: tt.labelMedium?.copyWith(
                        color: Brand.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: tt.headlineMedium?.copyWith(
                color: Brand.green,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: tt.bodyLarge?.copyWith(color: Brand.text),
              ),
            ),
          ],
        ),

        SizedBox(height: isMobile ? 28 : 40),

        // Conversion Split Row: Primary Online Payment Card + Bank Transfer Key-Value Table
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _OnlineDonationCard(
                locale: locale,
                donateCta: donateCta,
                studentCta: studentCta,
                providerNote: providerNote,
                onDonate: donateUrl.isEmpty ? null : () => _launchExternal(context, donateUrl),
                onStudentPay: studentUrl.isEmpty ? null : () => _launchExternal(context, studentUrl),
              ),
              const SizedBox(height: 20),
              _BankTransferCard(
                locale: locale,
                bankTitle: bankTitle,
                bankBlock: bankBlock,
                copyCta: copyCta,
                copiedMsg: copiedMsg,
              ),
            ],
          )
        else
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 6,
                  child: _OnlineDonationCard(
                    locale: locale,
                    donateCta: donateCta,
                    studentCta: studentCta,
                    providerNote: providerNote,
                    onDonate: donateUrl.isEmpty ? null : () => _launchExternal(context, donateUrl),
                    onStudentPay: studentUrl.isEmpty ? null : () => _launchExternal(context, studentUrl),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 6,
                  child: _BankTransferCard(
                    locale: locale,
                    bankTitle: bankTitle,
                    bankBlock: bankBlock,
                    copyCta: copyCta,
                    copiedMsg: copiedMsg,
                  ),
                ),
              ],
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

class _OnlineDonationCard extends StatelessWidget {
  final AppLocale locale;
  final String donateCta;
  final String studentCta;
  final String providerNote;
  final VoidCallback? onDonate;
  final VoidCallback? onStudentPay;

  const _OnlineDonationCard({
    required this.locale,
    required this.donateCta,
    required this.studentCta,
    required this.providerNote,
    this.onDonate,
    this.onStudentPay,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final cardHeading = t({
      'en': 'Online Card & Recurring Standing Order (הוראת קבע)',
      'ar': 'التبرع بالبطاقة أو بأمر اقتطاع شهري (הוראת קבע)',
      'he': 'תרומה בכרטיס אשראי או בהוראת קבע חודשית',
    }, locale);

    final cardSub = t({
      'en': 'Choose a one-time contribution or set up an automatic monthly standing order (הוראת קבע) via our secure payment terminal.',
      'ar': 'يمكنكم التبرع لمرة واحدة أو إعداد تبرع شهري ثابت (הוראת קבע) بسهولة وأمان عبر بوابة الدفع.',
      'he': 'ניתן לתרום תרומה חד-פעמית או להגדיר הוראת קבע חודשית קבועה באופן מאובטח ומהיר.',
    }, locale);

    return Container(
      decoration: BoxDecoration(
        color: Brand.altBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Brand.outline),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Brand.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.credit_card_rounded, color: Brand.yellow, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      cardHeading,
                      style: tt.titleLarge?.copyWith(
                        color: Brand.green,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                cardSub,
                style: tt.bodyMedium?.copyWith(
                  color: Brand.text,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 22),

              // Primary Golden Yellow (#F2C924) Recurring / Card CTA
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: onDonate,
                  style: FilledButton.styleFrom(
                    backgroundColor: Brand.yellow,
                    foregroundColor: Brand.green,
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.volunteer_activism_rounded, color: Brand.green, size: 22),
                  label: Text(
                    donateCta,
                    style: tt.titleMedium?.copyWith(
                      color: Brand.green,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Secondary Student Payment CTA
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: onStudentPay,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Brand.card,
                    foregroundColor: Brand.green,
                    side: const BorderSide(color: Brand.green, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.school_outlined, color: Brand.green, size: 20),
                  label: Text(
                    studentCta,
                    style: tt.titleSmall?.copyWith(
                      color: Brand.green,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ProviderBadge(text: providerNote),
        ],
      ),
    );
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

    final msg = snackLabel != null ? '${widget.copiedMsg}: $snackLabel' : widget.copiedMsg;
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
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Brand.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Brand.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1D6363),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Brand.altBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.account_balance_rounded, color: Brand.green, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.bankTitle,
                            style: tt.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Brand.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _copyWithConfirmation('all', widget.bankBlock),
                    style: TextButton.styleFrom(
                      backgroundColor: Brand.altBg,
                      foregroundColor: Brand.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isAllCopied ? Icons.check_rounded : Icons.copy_all_rounded,
                        key: ValueKey<bool>(isAllCopied),
                        color: Brand.green,
                        size: 16,
                      ),
                    ),
                    label: Text(
                      isAllCopied ? widget.copiedMsg : widget.copyCta,
                      style: const TextStyle(
                        color: Brand.green,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Key-Value Table Rows
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Brand.outline),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (int i = 0; i < fields.length; i++) ...[
                        _buildKeyValueRow(fields[i], 'field_$i', isEven: i.isEven),
                        if (i < fields.length - 1)
                          const Divider(height: 1, thickness: 1, color: Brand.outline),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyValueRow(_BankField field, String key, {required bool isEven}) {
    final isCopied = _copiedKeys.contains(key);

    return Material(
      color: isCopied
          ? Brand.green.withValues(alpha: 0.08)
          : (isEven ? Brand.card : Brand.altBg.withValues(alpha: 0.5)),
      child: InkWell(
        onTap: () => _copyWithConfirmation(key, field.copyValue, snackLabel: field.copyValue),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 105,
                child: Text(
                  field.label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Brand.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  field.displayValue,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Brand.green,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isCopied ? Brand.green : Brand.altBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isCopied ? Icons.check_rounded : Icons.copy_rounded,
                    key: ValueKey<bool>(isCopied),
                    size: 16,
                    color: isCopied ? Colors.white : Brand.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderBadge extends StatelessWidget {
  final String text;
  const _ProviderBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Brand.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Brand.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline_rounded, size: 15, color: Brand.green),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Brand.green,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
