import 'package:flutter/material.dart';
import 'package:todo_list_hive/UI/widgets/task_form/task_form_widget_model_dart.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;

  const TaskFormWidget({Key? key, required this.groupKey}) : super(key: key);

  @override
  _TaskFormWidgetState createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
    widget.key;
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
        model: _model, child: const _TextFormWidgetBody());
  }
}

class _TextFormWidgetBody extends StatelessWidget {
  const _TextFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.watch(context)?.model;
    final actionButton = FloatingActionButton(
      onPressed: () => model?.saveTask(context),
      child: const Icon(Icons.save),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _TaskTextNameWidget(),
        ),
      ),
      floatingActionButton: model?.isValid == true ? actionButton : null,
    );
  }
}

class _TaskTextNameWidget extends StatelessWidget {
  const _TaskTextNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.read(context)?.model;
    return TextField(
      autofocus: true,
      maxLines: null,
      minLines: null,
      expands: true,
      decoration: const InputDecoration(
          border: InputBorder.none, hintText: 'Task Text'),
      onChanged: (value) => model?.taskText = value,
      onEditingComplete: () => model?.saveTask(context),
    );
  }
}
