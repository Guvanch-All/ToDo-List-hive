import 'package:flutter/material.dart';
import 'package:todo_list_hive/widgets/task_form/task_form_widget_model_dart.dart';

class TaskFormWidget extends StatefulWidget {
  const TaskFormWidget({Key? key}) : super(key: key);

  @override
  _TaskFormWidgetState createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  TaskFormWidgetModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TaskFormWidgetModel(groupKey: groupKey);
    }
  }
  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
        model: _model!,
        child: const _TextFormWidgetBody());
  }
}


class _TextFormWidgetBody extends StatelessWidget {
  const _TextFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => TaskFormWidgetModelProvider.read(context)?.model.saveTask(context),
        child: const Icon(Icons.save),
      ),
    );
  }
}

class _TaskTextNameWidget extends StatelessWidget {
  const _TaskTextNameWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model =TaskFormWidgetModelProvider.read(context)?.model;
    return  TextField(
      autofocus: true,
      maxLines: null,
      minLines: null,
      expands: true,
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Task Text'),
      onChanged: (value) => model?.taskText = value,
      onEditingComplete: () => model?.saveTask(context),
    );
  }
}
