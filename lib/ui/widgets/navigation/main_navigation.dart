import 'package:flutter/material.dart';
import 'package:to_do_list/ui/widgets/group_form/group_form_widget.dart';
import 'package:to_do_list/ui/widgets/groups/groups_widget.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget.dart';
import 'package:to_do_list/ui/widgets/tasks_form/task_form_widget.dart';

abstract class MainNavigationRoutesNames {
  static const groups = '/';
  static const groupsForm = '/groupsForm';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}


class MainNavigation {
    final initialRoute = MainNavigationRoutesNames.groups;
    final routes = <String, Widget Function(BuildContext)>{
        MainNavigationRoutesNames.groups:(context) => const GroupsWidget(),
        MainNavigationRoutesNames.groupsForm :(context) => const GroupFormWidget(),
      };

      Route<Object> onGenerateRoute(RouteSettings settings) {
        switch (settings.name) {
          case MainNavigationRoutesNames.tasks:
          final configuration = settings.arguments as TaskWidgetConfiguration;
          return MaterialPageRoute(
            builder: (context) => TaskWidget(configuration: configuration),
          );
          case MainNavigationRoutesNames.tasksForm:
          final groupKey = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => TaskFormWidget(groupKey: groupKey),
          );
          default: 
          const widget = Text('Navigation Error!!!');
          return MaterialPageRoute(builder: (context) => widget);
          } 
        }
}
