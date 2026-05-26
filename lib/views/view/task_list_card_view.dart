import 'package:flutter/material.dart';
import 'package:flutter_task_app/models/task_model.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/widgets/card_priority_badge_widget.dart';


/// Carte de tache en vue list
/// 
class TaskListCardView extends StatelessWidget {
  final TaskModel task;
  const TaskListCardView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        minVerticalPadding: 0,
        contentPadding: const EdgeInsets.only(top: 8, right: 16, bottom: 8),
        isThreeLine: true,
        horizontalTitleGap: 4.0,
        minLeadingWidth: 0,

        // Checkbox de completion de la tache
        leading: Transform.scale(
          scale: 1.5,
          child: Checkbox(
            value: false,
            onChanged: (value) {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
            side: BorderSide(
              color: AppColors.textDarkSecondary,
              width: 1,
            ),
          ),
        ),

        // Titre de la tache
        title: Text(
          task.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),

        // description de la tache et date d'echeance
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // description de la tache
            task.description != null ? Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ): SizedBox.shrink(),
            
            // Date d'echeance de la tache
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date d'echeance de la tache
                task.deadline != null ? Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: AppColors.textDarkSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      task.deadline!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),
                  ],
                ) : SizedBox.shrink(),

                // Badge de priorité de la tache
                task.priority != null ? CardPriorityBadgeWidget(
                  priority: task.priority!.label,
                  color: task.priority!.color,
                ) : SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}