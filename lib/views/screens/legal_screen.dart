import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Conditions & Confidentialité'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textDarkSecondary,
            tabs: [
              Tab(text: 'CGU'),
              Tab(text: 'Confidentialité'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LegalContent(
              sections: [
                _LegalSection(
                  title: '1. Acceptation des conditions',
                  content:
                      'En utilisant TaskFlow, vous acceptez les présentes conditions générales d\'utilisation. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser l\'application.',
                ),
                _LegalSection(
                  title: '2. Description du service',
                  content:
                      'TaskFlow est une application de gestion de tâches permettant aux utilisateurs de créer, organiser et partager des tâches au sein d\'une équipe.',
                ),
                _LegalSection(
                  title: '3. Compte utilisateur',
                  content:
                      'Vous êtes responsable de la confidentialité de vos identifiants de connexion. Toute activité effectuée depuis votre compte est sous votre responsabilité.',
                ),
                _LegalSection(
                  title: '4. Utilisation acceptable',
                  content:
                      'Vous vous engagez à utiliser TaskFlow uniquement à des fins légales et conformément aux présentes conditions. Toute utilisation abusive est strictement interdite.',
                ),
                _LegalSection(
                  title: '5. Modifications',
                  content:
                      'Nous nous réservons le droit de modifier ces conditions à tout moment. Les modifications entrent en vigueur dès leur publication dans l\'application.',
                ),
              ],
            ),
            _LegalContent(
              sections: [
                _LegalSection(
                  title: '1. Données collectées',
                  content:
                      'TaskFlow collecte uniquement les données nécessaires au fonctionnement du service : nom, prénom, adresse e-mail, nom d\'utilisateur et les tâches créées.',
                ),
                _LegalSection(
                  title: '2. Utilisation des données',
                  content:
                      'Vos données sont utilisées exclusivement pour vous fournir le service TaskFlow. Elles ne sont ni vendues ni partagées avec des tiers à des fins commerciales.',
                ),
                _LegalSection(
                  title: '3. Stockage et sécurité',
                  content:
                      'Vos données sont stockées de manière sécurisée sur nos serveurs. Nous mettons en œuvre des mesures techniques appropriées pour protéger vos informations.',
                ),
                _LegalSection(
                  title: '4. Vos droits',
                  content:
                      'Vous disposez d\'un droit d\'accès, de rectification et de suppression de vos données personnelles. Pour exercer ces droits, contactez-nous via le support.',
                ),
                _LegalSection(
                  title: '5. Cookies et stockage local',
                  content:
                      'TaskFlow utilise le stockage local de votre appareil uniquement pour améliorer votre expérience (préférences, cache). Aucun cookie de tracking n\'est utilisé.',
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
  final String title;
  final String content;
  const _LegalSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textDarkPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
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