import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskSelectionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String taskId) {
    if (state.contains(taskId)) {
      state = {...state}..remove(taskId);
    } else {
      state = {...state, taskId};
    }
  }

  void clearAll() => state = {};
}

final taskSelectionProvider = NotifierProvider<TaskSelectionNotifier, Set<String>>(
  TaskSelectionNotifier.new,
);

final isSelectionModeProvider = Provider<bool>((ref) {
  return ref.watch(taskSelectionProvider).isNotEmpty;
});