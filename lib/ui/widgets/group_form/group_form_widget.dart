import 'package:flutter/material.dart';
import 'package:to_do_list/ui/widgets/group_form/group_form_widget_model.dart';

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
        backgroundColor: Colors.white,

        title: const Text('Заметка',
        style: TextStyle(color: Colors.black,
                            fontSize: 29,
                            fontWeight: FontWeight.bold,),)
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _GroupNameWidget(),
                Expanded(child: _TaskTextWidget()),
              ],
            ),
          ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () => GroupFormWidgetModelProvider.read(context)?.model.saveGroupAndTasks(context),
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
      style: const TextStyle(fontSize: 20),
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Название',
         focusedBorder: InputBorder.none,
         enabledBorder: InputBorder.none,
        errorText: model?.errorText,
      ),
      onChanged: (value) => model?.groupName = value,
      onEditingComplete: () => model?.saveGroupAndTasks(context),
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.watch(context)?.model;
    return TextField(
      style: const TextStyle(fontSize: 17),
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Текст задачи',
      ),
      onChanged: (value) => model?.taskText = value,
    );
  }
}