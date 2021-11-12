import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list_hive/UI/widgets/tasks/tasks_widget_model.dart';

class TaskWidgetConfiguration {
  final int groupKey;
  final String title;

  TaskWidgetConfiguration(
     this.groupKey,
     this.title,
  );
}
class TaskWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;

  const TaskWidget({Key? key, required this.configuration}) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(configuration: widget.configuration);
    widget.key;
  }

  @override
  Widget build(BuildContext context) {
    return TaskWidgetModelProvider(
      model: _model,
      child: const TasksWidgetBody(),
    );
  }
  @override
  void dispose() async{
   await _model.dispose();
    super.dispose();
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetModelProvider.watch(context)?.model;
    final title = model?.configuration.title ?? 'Задачи';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        TaskWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
        itemCount: groupsCount,
        itemBuilder: (BuildContext context, int index) {
          return _TaskListRowWidget(indexInList: index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1);
        });
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;

  const _TaskListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetModelProvider.read(context)!.model;
    final tasks = model.tasks[indexInList];

    final _icon = tasks.isDone ? Icons.album : Icons.album_outlined;
    final style = tasks.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;
    return Slidable(
      actionPane: const SlidableBehindActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => model.deleteTasks(indexInList),
        ),
      ],
      child: ColoredBox(
        color: Colors.white,
        child: ListTile(
          title: Text(tasks.text, style: style),
          trailing: Icon(_icon),
          onTap: () => model.doneToggle(indexInList),
        ),
      ),
    );
  }
}
