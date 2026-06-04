import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskCompletionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String taskId) {
    if (state.contains(taskId)) {
      state = {...state}..remove(taskId);
    } else {
      state = {...state, taskId};
    }
  }

  bool isCompleted(String taskId) => state.contains(taskId);
}

final taskCompletionProvider = NotifierProvider<TaskCompletionNotifier, Set<String>>(
  TaskCompletionNotifier.new,
);