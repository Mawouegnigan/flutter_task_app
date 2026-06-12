import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/providers/repeat_datetime_task_provider.dart';
import 'package:flutter_task_app/utils/constants.dart';



class RepeatBottomSheet extends ConsumerStatefulWidget {
  const RepeatBottomSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RepeatBottomSheetState();
}

class _RepeatBottomSheetState extends ConsumerState<RepeatBottomSheet> {
  late RepeatOption _optionSelected;

  @override
  void initState() {
    _optionSelected = ref.read(repeatProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // --- Handle + AppBar ---
              Column(
                children: [
                  const SizedBox(height: 12),
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Appbar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            ref.read(repeatProvider.notifier).select(_optionSelected);
                            Navigator.pop(context);
                          },
                          child: const Text('OK', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
              ),
 
              // --- Liste des options ---
              Expanded(
                child: RadioGroup<RepeatOption>(
                  groupValue: _optionSelected,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _optionSelected = value);
                    }
                  },
                  child: ListView(
                    controller: scrollController,
                    children: RepeatOption.values.map((option) {
                      return ListTile(
                        title: Text(option.label),
                        trailing: Transform.scale(
                          scale: 1.3,
                          child: Radio<RepeatOption>(
                            activeColor: AppColors.primary,
                            value: option,
                            side: BorderSide(width: 0.8),
                          ),
                        ),
                        onTap: () {
                          setState(() => _optionSelected = option);
                        },
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

}