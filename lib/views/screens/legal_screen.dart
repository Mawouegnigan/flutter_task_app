import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/utils/translations.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('legal_title'.tr(context)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textDarkSecondary,
            tabs: [
              Tab(text: 'legal_tab_cgu'.tr(context)),
              Tab(text: 'legal_tab_privacy'.tr(context)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LegalContent(
              sections: [
                _LegalSection(
                  titleKey: 'legal_cgu_1_title',
                  contentKey: 'legal_cgu_1_body',
                ),
                _LegalSection(
                  titleKey: 'legal_cgu_2_title',
                  contentKey: 'legal_cgu_2_body',
                ),
                _LegalSection(
                  titleKey: 'legal_cgu_3_title',
                  contentKey: 'legal_cgu_3_body',
                ),
                _LegalSection(
                  titleKey: 'legal_cgu_4_title',
                  contentKey: 'legal_cgu_4_body',
                ),
                _LegalSection(
                  titleKey: 'legal_cgu_5_title',
                  contentKey: 'legal_cgu_5_body',
                ),
              ],
            ),
            _LegalContent(
              sections: [
                _LegalSection(
                  titleKey: 'legal_privacy_1_title',
                  contentKey: 'legal_privacy_1_body',
                ),
                _LegalSection(
                  titleKey: 'legal_privacy_2_title',
                  contentKey: 'legal_privacy_2_body',
                ),
                _LegalSection(
                  titleKey: 'legal_privacy_3_title',
                  contentKey: 'legal_privacy_3_body',
                ),
                _LegalSection(
                  titleKey: 'legal_privacy_4_title',
                  contentKey: 'legal_privacy_4_body',
                ),
                _LegalSection(
                  titleKey: 'legal_privacy_5_title',
                  contentKey: 'legal_privacy_5_body',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalContent extends StatelessWidget {
  final List<_LegalSection> sections;
  const _LegalContent({required this.sections});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: sections.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => sections[i],
    );
  }
}

class _LegalSection extends StatelessWidget {
  final String titleKey;
  final String contentKey;
  const _LegalSection({required this.titleKey, required this.contentKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleKey.tr(context),
          style: const TextStyle(
            color: AppColors.textDarkPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          contentKey.tr(context),
          style: TextStyle(
            color: AppColors.textDarkSecondary.withValues(alpha: 0.9),
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}