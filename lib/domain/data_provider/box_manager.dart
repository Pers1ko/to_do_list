import 'package:hive/hive.dart';
import 'package:to_do_list/entity/group.dart';
import 'package:to_do_list/entity/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  final Map<String, int> _boxCounter = <String, int>{};

  BoxManager._();

Future<Box<Group>> openGroupBox() async {
    return openBox('group_box', 1, GroupAdapter());
}

Future<Box<Task>> openTaskBox(int groupKey) async {
    return openBox(makeTaskBoxName(groupKey), 2, TaskAdapter());
}

Future<void> closeBox<T>(Box<T> box) async {
  if (!box.isOpen) {
    _boxCounter.remove(box.name);
    return;
  }
  var count = _boxCounter[box.name] ?? 1;
  count -= 1;
  _boxCounter[box.name] = count;
  if (count > 0) return;
   await box.compact();
   await box.close();
}

String makeTaskBoxName(int groupKey) => 'tasks_box_$groupKey';

  Future<Box<T>> openBox<T>(
    String name, 
    int typeId, 
    TypeAdapter<T> adapter
    ) async {
      if (Hive.isBoxOpen(name)) {
        final count = _boxCounter[name] ?? 1;
        _boxCounter[name] = count + 1;
        return Hive.box(name);
      }
      _boxCounter[name] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(name);
  }
}

