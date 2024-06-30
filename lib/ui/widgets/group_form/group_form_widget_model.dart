import 'package:flutter/material.dart';
import 'package:to_do_list/domain/data_provider/box_manager.dart';
import 'package:to_do_list/entity/group.dart';
import 'package:to_do_list/entity/task.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  var _groupName = '';
  var _taskText = '';
  String? errorText;

  set groupName (String value) {
    if (errorText != null && value.trim().isNotEmpty) {
        errorText = null;
        notifyListeners();
    }
    _groupName = value;
  }

   set taskText(String value) { 
    _taskText = value;
  }

  Future<void> saveGroupAndTasks(BuildContext context) async { // Изменено: новый метод для сохранения группы и задач
    final groupName = _groupName.trim();
    final taskText = _taskText.trim();

    if (groupName.isEmpty) {
      errorText = 'Введите название группы';
      notifyListeners();
      return;
    }

    final groupBox = await BoxManager.instance.openGroupBox();
    final group = Group(name: groupName);
    final groupKey = await groupBox.add(group);

    if (taskText.isNotEmpty) {
      final taskBox = await BoxManager.instance.openTaskBox(groupKey);
      final task = Task(text: taskText, isDone: false);
      await taskBox.add(task);
      await BoxManager.instance.closeBox(taskBox);
    }

    await BoxManager.instance.closeBox(groupBox);
    Navigator.of(context).pop();
  }
}


class GroupFormWidgetModelProvider extends InheritedNotifier {
  final GroupFormWidgetModel model;
  const GroupFormWidgetModelProvider({Key? key,  
    required this.model, 
    required this.child
    }) : super(
      key: key, 
      notifier: model,
      child: child);

  final Widget child;

  static GroupFormWidgetModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return false;
  }
}