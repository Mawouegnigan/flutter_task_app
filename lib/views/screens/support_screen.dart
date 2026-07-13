import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/utils/translations.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('support_title'.tr(context)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: const [
          _FaqItem(
            questionKey: 'support_faq_1_q',
            answerKey: 'support_faq_1_a',
          ),
          _FaqItem(
            questionKey: 'support_faq_2_q',
            answerKey: 'support_faq_2_a',
          ),
          _FaqItem(
            questionKey: 'support_faq_3_q',
            answerKey: 'support_faq_3_a',
          ),
          _FaqItem(
            questionKey: 'support_faq_4_q',
            answerKey: 'support_faq_4_a',
          ),
          _FaqItem(
            questionKey: 'support_faq_5_q',
            answerKey: 'support_faq_5_a',
          ),
          _FaqItem(
            questionKey: 'support_faq_6_q',
            answerKey: 'support_faq_6_a',
          ),
          _FaqItem(
            questionKey: 'support_faq_7_q',
            answerKey: 'support_faq_7_a',
          ),
          _FaqItem(
            questionKey: 'support_faq_8_q',
            answerKey: 'support_faq_8_a',
          ),
          _FaqItem(
            questionKey: 'support_faq_9_q',
            answerKey: 'support_faq_9_a',
          ),
          _FaqItem(
            questionKey: 'support_faq_10_q',
            answerKey: 'support_faq_10_a',
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String questionKey;
  final String answerKey;
  const _FaqItem({required this.questionKey, required this.answerKey});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.textDarkSecondary.withValues(alpha: 0.08),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.help_outline, color: Colors.white, size: 22),
        ),
        title: Text(
          widget.questionKey.tr(context),
          style: const TextStyle(
            color: AppColors.textDarkPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          _expanded ? Icons.expand_less : Icons.expand_more,
          color: AppColors.textDarkSecondary,
        ),
        onExpansionChanged: (val) => setState(() => _expanded = val),
        children: [
          Text(
            widget.answerKey.tr(context),
            style: TextStyle(
              color: AppColors.textDarkSecondary.withValues(alpha: 0.9),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}