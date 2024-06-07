import 'package:flutter/material.dart';
import 'package:to_do_list/ui/widgets/group_form/group_form_wodget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({Key? key}) : super(key: key);

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(model: _model,
    child:  const _GroupFormWidgetBody());
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,

        title: const Text('Новая группа',
        style: TextStyle(color: Colors.white),)
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _GroupNameWidget(
              
            ),
          ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () => GroupFormWidgetModelProvider.read(context)?.model.saveGroup(context),
            child: const Icon(Icons.done,
            color: Colors.white,),
          ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.watch(context)?.model;
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Имя группы',
        errorText: model?.errorText,
      ),
      onChanged: (value) => model?.groupName = value,
      onEditingComplete: () => model?.saveGroup(context),
    );
  }
}