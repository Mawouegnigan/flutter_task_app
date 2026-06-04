import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/providers/task_completion_provider.dart';
import 'package:flutter_task_app/providers/task_selection_provider.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/add_editing_task_screen.dart';
import 'package:flutter_task_app/views/widgets/card_priority_badge_widget.dart';

class TaskListCardView extends ConsumerStatefulWidget {
  final TaskModel task;
  const TaskListCardView({super.key, required this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskListCardViewState();
}

class _TaskListCardViewState extends ConsumerState<TaskListCardView> {

  @override
  Widget build(BuildContext context) {
    // On regarde si la tache est completé ou pas
    final isCompleted = ref.watch(
      taskCompletionProvider.select((s) => s.contains(widget.task.id)),
    );

    // On regarde si la tache est selectionné ou pas  
    final isSelected = ref.watch(
      taskSelectionProvider.select((s) => s.contains(widget.task.id)),
    );

    // On regarde si on est en mode selection ou pas
    final isSelectionMode = ref.watch(isSelectionModeProvider);

    return GestureDetector(
      onLongPress: () {
        debugPrint("long Press");
        ref.read(taskSelectionProvider.notifier).toggle(widget.task.id);
      },
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          minVerticalPadding: 0,
          contentPadding: const EdgeInsets.only(top: 8, right: 16, bottom: 8),
          isThreeLine: true,
          horizontalTitleGap: 4.0,
          minLeadingWidth: 0,
          onTap: () {
            if (isSelectionMode) {
              ref.read(taskSelectionProvider.notifier).toggle(widget.task.id);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditingTaskScreen(
                    mode: 'Edit',
                  ),
                ),
              );
            }
          },
      
          // Checkbox de completion de la tache
          leading: !isSelectionMode
            ? Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: isCompleted,
                onChanged: (_) {
                  debugPrint("checkbox tappppppppp");
                  ref.read(taskCompletionProvider.notifier).toggle(widget.task.id);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                side: BorderSide(
                  color: AppColors.textDarkSecondary,
                  width: 1,
                ),
              ),
            )
          : SizedBox.expand(),
      
          // Titre de la tache
          title: Text(
            widget.task.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isCompleted ? AppColors.textDarkSecondary : null,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              decorationColor: isCompleted ? AppColors.textDarkSecondary : null,
            ),
          ),
      
          // description de la tache et date d'echeance
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // description de la tache
              widget.task.description != null ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  widget.task.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.textDarkSecondary,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: isCompleted ? AppColors.textDarkSecondary : null,
                  ),
                ),
              ): SizedBox.shrink(),
              
              // Date d'echeance de la tache
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date d'echeance de la tache
                  widget.task.deadline != null ? Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: AppColors.textDarkSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.task.deadline!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDarkSecondary,
                        ),
                      ),
                    ],
                  ) : SizedBox.shrink(),
      
                  // Badge de priorité de la tache
                  widget.task.priority != null ? CardPriorityBadgeWidget(
                    priority: widget.task.priority!.label,
                    color: widget.task.priority!.color,
                  ) : SizedBox.shrink(),
                ],
              ),
            ],
          ),
          trailing: isSelectionMode
            ? Checkbox(
              value: isSelected,
              onChanged: (_) {
                ref.read(taskSelectionProvider.notifier).toggle(widget.task.id);
              },
            )
          : null,
        ),
      ),
    );
  }
}