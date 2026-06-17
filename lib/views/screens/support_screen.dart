import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide & Support'),
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
            question: 'Comment créer une tâche ?',
            answer:
                'Appuyez sur le bouton "+" sur l\'écran d\'accueil, remplissez le titre, la description, la priorité et la date d\'échéance, puis validez.',
          ),
          _FaqItem(
            question: 'Comment modifier une tâche existante ?',
            answer:
                'Ouvrez la tâche en appuyant dessus, puis appuyez sur l\'icône de modification en haut à droite de l\'écran de détail.',
          ),
          _FaqItem(
            question: 'Comment marquer une tâche comme terminée ?',
            answer:
                'Dans le détail d\'une tâche, appuyez sur le bouton de complétion. La tâche passera en gris pour indiquer qu\'elle est terminée.',
          ),
          _FaqItem(
            question: 'Comment partager une tâche ?',
            answer:
                'Ouvrez le détail d\'une tâche et appuyez sur l\'icône de partage dans la barre d\'actions. Vous pouvez partager via toutes les applications disponibles sur votre téléphone.',
          ),
          _FaqItem(
            question: 'Comment changer le thème de l\'application ?',
            answer:
                'Allez dans Profil → Paramètres → Mode sombre. Activez ou désactivez le switch selon votre préférence.',
          ),
          _FaqItem(
            question: 'Comment changer la langue de l\'application ?',
            answer:
                'Allez dans Profil → Paramètres → Langue de l\'application, puis sélectionnez Français ou English dans le menu déroulant.',
          ),
          _FaqItem(
            question: 'Comment supprimer une tâche ?',
            answer:
                'Ouvrez le détail de la tâche et appuyez sur l\'icône de suppression. Une confirmation vous sera demandée avant la suppression définitive.',
          ),
          _FaqItem(
            question: 'Mes tâches sont-elles sauvegardées en ligne ?',
            answer:
                'Oui, toutes vos tâches sont synchronisées avec notre serveur. Vous pouvez y accéder depuis n\'importe quel appareil en vous connectant avec votre compte.',
          ),
          _FaqItem(
            question: 'Comment réinitialiser mon mot de passe ?',
            answer:
                'La fonctionnalité de réinitialisation de mot de passe est en cours de développement. Contactez le support pour toute assistance.',
          ),
          _FaqItem(
            question: 'Comment contacter le support ?',
            answer:
                'Vous pouvez nous contacter par e-mail à support@taskflow.app. Nous répondons généralement sous 24 à 48 heures ouvrées.',
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});

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
          widget.question,
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
            widget.answer,
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