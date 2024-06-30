import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list/ui/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupWidgetBody());
  }

  @override
  void dispose() async{
    await _model.dispose();
    super.dispose();
  }
}

class _GroupWidgetBody extends StatelessWidget {
  const _GroupWidgetBody({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.white,

        title: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text('Заметки',
          style: TextStyle(color: Colors.black,
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            ),),
        )
        ,
        ),
        body: const _GroupListWidget(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => GroupsWidgetModelProvider.read(context)?.model.showForm(context),
          child: const Icon(Icons.add,
          color: Colors.white,)),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount = GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;
    return ListView.builder(
      itemCount: groupsCount,
      itemBuilder: (BuildContext context, int index) {
        return _GroupListRowWidget(indexInList: index);
      }
    );
  }
}


class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupListRowWidget({
    Key? key,
    required this.indexInList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context)!.model;
    final group = model.groups[indexInList];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
      endActionPane: ActionPane(
      motion: const StretchMotion(),
      children: [
        SlidableAction(
          onPressed: (context) => model.deleteGroup(indexInList),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
          
        ),
      ],
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.black,
          width: 2)),
          title: Text(group.name),
          trailing: const Icon(Icons.chevron_right, color: Colors.black,),
          onTap: () => model.showTasks(context, indexInList),
        ),
      ),
    );
  }
}

