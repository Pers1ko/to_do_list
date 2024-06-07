// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:to_do_list/ui/widgets/tasks/tasks_widget_model.dart';

class TaskWidgetConfiguration {
  final int groupKey;
  final String title;

  TaskWidgetConfiguration(this.groupKey, this.title);
}

class TaskWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;
  const TaskWidget({
    Key? key,
    required this.configuration,
  }) : super(key: key);

    @override
    State<TaskWidget> createState() => _TaskWidgetState();
  }

  class _TaskWidgetState extends State<TaskWidget> {
  late final TaskWidgetModel _model;

  @override
  void initState() {
    super.initState();
    widget.key;
    _model = TaskWidgetModel(configuration: widget.configuration);
  }
    
  @override
  Widget build(BuildContext context) {    
    return TaskWidgetModelProvider(
      model: _model,
      child: const TaskWidgetBody(),
    );
    }

    @override
  void dispose() async {
     _model.dispose();
    super.dispose();
  }
  }


class TaskWidgetBody extends StatelessWidget {
  const TaskWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetModelProvider.watch(context)?.model;
    final title = model?.configuration.title ?? 'Задачи';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(title, 
        style: const TextStyle(
          color: Colors.white)),
      ),
      body: const _TasksListWidget(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () => model?.showForm(context),
          child: const Icon(Icons.add,
          color: Colors.white,)),
    );
  }
}

class _TasksListWidget extends StatelessWidget {
  const _TasksListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount = TaskWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
      itemCount: groupsCount,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 1,);
      },
      itemBuilder: (BuildContext context, int index) {
        return _TaskListRowWidget(indexInList: index);
      }
    );
  }
}


class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;
  const _TaskListRowWidget({
    Key? key,
    required this.indexInList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetModelProvider.read(context)!.model;
    final tasks = model.tasks[indexInList];

    final icon = tasks.isDone ? Icons.check_box : Icons.check_box_outline_blank;
    final style = tasks.isDone ? const TextStyle(decoration: TextDecoration.lineThrough) : null;

    return Slidable(
    endActionPane: ActionPane(
    motion: const StretchMotion(),
    children: [
      SlidableAction(
        onPressed: (context) => model.deleteTasks(indexInList),
        backgroundColor: const Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
        
      ),
    ],
  ),
      child: ListTile(
        title: Text(tasks.text,
        style: style),
        trailing: Icon(icon),
        onTap: () => model.doneToggle(indexInList),
      ),
    );
  }
}