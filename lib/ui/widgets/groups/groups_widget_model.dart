
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/domain/data_provider/box_manager.dart';
import 'package:to_do_list/entity/group.dart';
import 'package:to_do_list/ui/widgets/navigation/main_navigation.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  ValueListenable<Object>? _listanableBox;
  late final Future<Box<Group>> _box;

  var _groups = <Group>[];

List<Group> get groups => _groups.toList();

GroupsWidgetModel() {
  _setup();
}

void showForm(BuildContext context) {
  Navigator.of(context).pushNamed(MainNavigationRoutesNames.groupsForm);
   }

Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null) {
      final configuration = TaskWidgetConfiguration(group.key as int, group.name);
unawaited(
  Navigator.of(context).pushNamed(
    MainNavigationRoutesNames.tasks, 
    arguments: configuration,),
);
    }
}


Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(groupIndex);
}



  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManager.instance.openGroupBox();
    await _readGroupsFromHive();
    _listanableBox = (await _box).listenable();
    _listanableBox?.addListener(_readGroupsFromHive);
  }
@override
  Future<void> dispose() async {
    _listanableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }

}


class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider({Key? key, 
    required this.model,
    required this.child,
  }) : super(key: key, notifier: model, child: child);

  final Widget child;

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

static GroupsWidgetModelProvider? read(BuildContext context) {
  final widget = context.getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()?.widget;
    return widget is GroupsWidgetModelProvider? widget : null;
  }
}
