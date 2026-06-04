import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';

class BottomSheetAddFilterView extends StatefulWidget {
  final ValueChanged<String> onFilterAdded;

  const BottomSheetAddFilterView({ super.key, required this.onFilterAdded });

  @override
  State<BottomSheetAddFilterView> createState() => _BottomSheetAddFilterViewState();
}

class _BottomSheetAddFilterViewState extends State<BottomSheetAddFilterView> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _errorText = 'Le nom du filtre ne peut pas être vide');
      return;
    }
    widget.onFilterAdded(value);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      // Remonte le contenu quand le clavier apparaît
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de drag
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),

          Text(
            'Nouveau filtre',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Donne un nom à ton filtre personnalisé',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Champ de saisie
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'Ex : Urgent, Personnel, Travail...',
              hintStyle: TextStyle(color: AppColors.textDarkSecondary),
              errorText: _errorText,
              prefixIcon: const Icon(Icons.label_outline_rounded),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant.withAlpha(100),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colorScheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colorScheme.error, width: 1.5),
              ),
              filled: true,
            ),
            onChanged: (_) {
              if (_errorText != null) setState(() => _errorText = null);
            },
          ),
          const SizedBox(height: 16),

          // Bouton valider
          CtaButtonWidget(
            text: "Ajouter le filtre",
            onPressed: _submit
          )
        ],
      ),
    );
  }
}