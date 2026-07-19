import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_app/providers/category_provider.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/utils/translations.dart';

class CategoriesSettingsScreen extends StatelessWidget {
  const CategoriesSettingsScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    final categoryProvider = context.read<CategoryProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('categories_new_title'.tr(context)),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 30,
            decoration: InputDecoration(
              hintText: 'categories_name_hint'.tr(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('cancel'.tr(context)),
            ),
            TextButton(
              onPressed: () async {
                final success = await categoryProvider.addCategory(
                  controller.text,
                );
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'categories_invalid_or_duplicate'.tr(context),
                      ),
                    ),
                  );
                }
              },
              child: Text('add'.tr(context)),
            ),
          ],
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    final categoryProvider = context.read<CategoryProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('categories_rename_title'.tr(context)),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 30,
            decoration: InputDecoration(
              hintText: 'categories_new_name_hint'.tr(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('cancel'.tr(context)),
            ),
            TextButton(
              onPressed: () async {
                final success = await categoryProvider.renameCategory(
                  currentName,
                  controller.text,
                );
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'categories_invalid_name'.tr(context),
                      ),
                    ),
                  );
                }
              },
              child: Text('edit'.tr(context)),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String name) {
    final categoryProvider = context.read<CategoryProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('categories_delete_confirm_title'.tr(context)),
          content: Text(
            'categories_delete_confirm_body'
                .tr(context, name: categoryLabel(name, context)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('cancel'.tr(context)),
            ),
            TextButton(
              onPressed: () async {
                await categoryProvider.deleteCategory(name);
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: Text(
                'delete'.tr(context),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmReset(BuildContext context) {
    final categoryProvider = context.read<CategoryProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('categories_reset_title'.tr(context)),
          content: Text('categories_reset_body'.tr(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('cancel'.tr(context)),
            ),
            TextButton(
              onPressed: () async {
                await categoryProvider.resetToDefault();
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: Text('categories_reset_button'.tr(context)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;

    return Scaffold(
      appBar: AppBar(
        title: Text('categories_title'.tr(context)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'categories_reset_button'.tr(context),
            onPressed: () => _confirmReset(context),
          ),
        ],
      ),
      body: categories.isEmpty
          ? Center(
              child: Text(
                'categories_empty'.tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary(context)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final name = categories[index];
                return Card(
                  elevation: 0,
                  color: AppColors.surface(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.borderColor(context)),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.label_outline,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      categoryLabel(name, context),
                      style: TextStyle(color: AppColors.textPrimary(context)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () =>
                              _showRenameDialog(context, name),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          onPressed: () => _confirmDelete(context, name),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}