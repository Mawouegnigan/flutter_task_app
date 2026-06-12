import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task_app/models/task_model.dart';

class RepeatNotifier extends Notifier<RepeatOption> {
  @override
  RepeatOption build() => RepeatOption.none;

  void select(RepeatOption option) => state = option;
}

final repeatProvider = NotifierProvider<RepeatNotifier, RepeatOption>(
  RepeatNotifier.new,
);