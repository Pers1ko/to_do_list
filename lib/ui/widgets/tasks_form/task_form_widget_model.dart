// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:to_do_list/domain/data_provider/box_manager.dart';


import 'package:to_do_list/entity/task.dart';

class TaskFormWidgetModel extends ChangeNotifier {
  var _tasksText = '';
  int groupKey;
  bool get isValid => _tasksText.trim().isNotEmpty;

  set taskText(String value) {
    final isTaskTextEmpty = _tasksText.trim().isEmpty;
    _tasksText = value;
    if (value.trim().isEmpty != isTaskTextEmpty) {
      notifyListeners();
    }
  }

  TaskFormWidgetModel({required this.groupKey});

  void saveTasks(BuildContext context ) async {
    final tasksText = _tasksText.trim();
    if (tasksText.isEmpty) return;

    final task = Task(text: tasksText, isDone: false);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    await box.add(task);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedNotifier {
  final TaskFormWidgetModel model;
  const TaskFormWidgetModelProvider({
    super.key, 
    required this.model,
    required this.child})
     : super(
      notifier: model,
      child: child);

  final Widget child;

  static TaskFormWidgetModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }
  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
    return false;
  }
}
