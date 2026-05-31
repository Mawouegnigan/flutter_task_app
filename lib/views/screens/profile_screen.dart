import "package:flutter/material.dart";
import "package:flutter_task_app/utils/constants.dart";
import "package:flutter_task_app/views/view/profile_header_view.dart";
import "package:flutter_task_app/views/widgets/logout_button_widget.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({ super.key });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Profile"),
        centerTitle: true,
        // Les boutons d'action de l'appbar: calendrier et notifications
        actions: [
          IconButton(
            onPressed:() {}, // action à definir pour le click sur le boutton de l'horloge
            icon: Icon(Icons.calendar_today_rounded),
            padding: const EdgeInsets.all(12),
            iconSize: 22,
          ),
          // A faire: ajouter un badge de notification sur le boutton lorsqu'il y a des notification non lues
          IconButton(
            onPressed:() {}, // action à definir pour le click sur le boutton des notifications
            icon: Icon(Icons.notifications_outlined),
            padding: const EdgeInsets.all(10),
            iconSize: 28,
          ),
        ]
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            Center(
              child: ProfileHeaderView(
                name: "John DOE",
                email: "john.doe@example.com",
              ),
            ),
            SizedBox(height: 16),
            CardItem(
              icon: Icons.settings,
              title: 'Paramétre',
              subtitle: "Stockage & Données, Langue & Région, Thème, couleurs, police",
            ),
            SizedBox(height: 8),
            Column(
              spacing: 1,
              children: [
                CardItem(
                  icon: Icons.bookmarks_outlined,
                  title: 'Catagorie & Priorité',
                  subtitle: "Gérer vos catégories de tâches", 
                  topRadius: 16,
                  btmRadius: 4,
                ),
                CardItem(
                  icon: Icons.notifications_outlined,
                  title: 'Rappels & Notifications',
                  subtitle: "Alertes, fréquence, heure de rappel",
                  topRadius: 4,
                  btmRadius: 16,
                )
              ],
            ),
            SizedBox(height: 8),
            Column(
              spacing: 1,
              children: [
                CardItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Conditions & Confidentialité',
                  subtitle: "CGU, politique de confidentialité", 
                  topRadius: 16,
                  btmRadius: 4,
                ),
                CardItem(
                  icon: Icons.shield_outlined,
                  title: 'Aide & Support',
                  subtitle: "FAQ, contacter le support",
                  topRadius: 4,
                  btmRadius: 4,
                ),
                CardItem(
                  icon: Icons.help_outline_rounded,
                  title: 'À propos',
                  subtitle: "Version de l'application V0",
                  topRadius: 4,
                  btmRadius: 16,
                ),
              ],
            ),
            SizedBox(height: 8),
            LogoutButtonWidget(onConfirm: () {})
          ],
        ),
      )
    );
  }
}

class CardItem extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final double topRadius, btmRadius;

  const CardItem ({ 
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.topRadius = 16,
    this.btmRadius = 16
  });

  @override
  Widget build(BuildContext context){
    return Card(
      elevation: 0,
      color: AppColors.textDarkSecondary.withValues(alpha: 0.25),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius), bottom: Radius.circular(btmRadius)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.textDarkSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.textDarkPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textDarkSecondary.withValues(alpha: 0.55),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}