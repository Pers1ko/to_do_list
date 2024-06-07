// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/domain/data_provider/box_manager.dart';
import 'package:to_do_list/entity/task.dart';
import 'package:to_do_list/ui/widgets/navigation/main_navigation.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget.dart';

class TaskWidgetModelConfiguration {
  final int groupKey;
  final String title;

  TaskWidgetModelConfiguration(this.groupKey, this.title);
}

class TaskWidgetModel extends ChangeNotifier {
  ValueListenable<Object>? _listanableBox;
  TaskWidgetConfiguration configuration;
    late final Future<Box<Task>> _box;
  var _tasks = <Task>[];


List<Task> get tasks => _tasks.toList();

  TaskWidgetModel({
    required this.configuration,}) {
      _setup();
    }

    void showForm(BuildContext context) {
      Navigator.of(context).pushNamed(
        MainNavigationRoutesNames.tasksForm, arguments: configuration.groupKey);
   }


    void deleteTasks(int taskIndex) async {
      await (await _box).deleteAt(taskIndex);

}

    Future<void> doneToggle(int taskIndex) async {
      final task = (await _box).getAt(taskIndex);
      task?.isDone = !task.isDone;
      await task?.save();
    }

      Future<void> _readTaskFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(configuration.groupKey);
    await _readTaskFromHive();
        _listanableBox = (await _box).listenable();
    _listanableBox?.addListener(_readTaskFromHive);
  }

  @override
  void dispose() async {
    _listanableBox?.removeListener(_readTaskFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}




class TaskWidgetModelProvider extends InheritedNotifier {
  final TaskWidgetModel model;
  const TaskWidgetModelProvider({Key? key, 
    required this.child,
    required this.model
  }) : super(key: key, notifier: model, child: child);


  final Widget child;

  static TaskWidgetModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskWidgetModelProvider>();
  }

  static TaskWidgetModelProvider? read(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<TaskWidgetModelProvider>()?.widget;
    return widget is TaskWidgetModelProvider ? widget : null;
  }
}