import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_app/providers/category_provider.dart';
import 'package:flutter_task_app/utils/constants.dart';

class CategoriesSettingsScreen extends StatelessWidget {
  const CategoriesSettingsScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    final categoryProvider = context.read<CategoryProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nouvelle catégorie'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 30,
            decoration: const InputDecoration(
              hintText: 'Nom de la catégorie',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
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
                    const SnackBar(
                      content: Text(
                        'Cette catégorie existe déjà ou le nom est invalide',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Ajouter'),
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
          title: const Text('Renommer la catégorie'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 30,
            decoration: const InputDecoration(
              hintText: 'Nouveau nom',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
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
                    const SnackBar(
                      content: Text(
                        'Ce nom existe déjà ou est invalide',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Renommer'),
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
          title: const Text('Supprimer la catégorie ?'),
          content: Text(
            'Les tâches existantes utilisant "$name" garderont cette '
            'valeur, mais elle ne sera plus proposée pour les nouvelles '
            'tâches.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await categoryProvider.deleteCategory(name);
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
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
          title: const Text('Réinitialiser les catégories ?'),
          content: const Text(
            'Cela restaurera les 6 catégories par défaut '
            '(Travail, Personnel, Études, Santé, Courses, Autre).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await categoryProvider.resetToDefault();
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Réinitialiser'),
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
        title: const Text('Catégories'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Réinitialiser',
            onPressed: () => _confirmReset(context),
          ),
        ],
      ),
      body: categories.isEmpty
          ? const Center(
              child: Text(
                'Aucune catégorie. Appuie sur + pour en créer une.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textDarkSecondary),
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
                  color: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.label_outline,
                      color: AppColors.primary,
                    ),
                    title: Text(name),
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