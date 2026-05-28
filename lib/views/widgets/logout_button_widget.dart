import 'package:flutter/material.dart';

class LogoutButtonWidget extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutButtonWidget({
    super.key,
    required this.onConfirm,
  });

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          spacing: 10,
          children: [
            Icon(
              Icons.logout_rounded,
              color: Theme.of(context).colorScheme.error
            ),
            const Text(
              "Déconnexion",
              style: TextStyle(fontWeight: FontWeight.w700)
            ),
          ],
        ),
        content: const Text(
          "Êtes-vous sûr de vouloir vous déconnecter ?\nVous devrez vous reconnecter pour accéder à vos tâches.",
        ),
        actions: [
          // ── Annuler ────────────────────────────────────────────
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annuler"),
          ),
          // ── Confirmer ──────────────────────────────────────────
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text("Se déconnecter"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showConfirmDialog(context),
          icon: Icon(Icons.logout_rounded, color: colorScheme.error, size: 20),
          label: Text(
            "Se déconnecter",
            style: TextStyle(
              color: colorScheme.error,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}