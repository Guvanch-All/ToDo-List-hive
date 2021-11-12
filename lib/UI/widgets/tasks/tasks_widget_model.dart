import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_hive/UI/navigation/main_navigation.dart';
import 'package:todo_list_hive/UI/widgets/tasks/tasks_widget.dart';
import 'package:todo_list_hive/domain/data_provider/box_manager.dart';
import 'package:todo_list_hive/domain/entity/task.dart';

class TasksWidgetModel extends ChangeNotifier {
  TaskWidgetConfiguration configuration;
  ValueListenable<Object>? _listenableBox;
  late final Future<Box<Task>> _box;

  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.configuration}) {
    _setUp();
  }

  Future<void> doneToggle(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone; //интвертация
    await task?.save();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tasksForm,
        arguments: configuration.groupKey);
  }

  Future<void> deleteTasks(int taskIndex) async {
    await (await _box).deleteAt(taskIndex);
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setUp() async {
    _box = BoxManager.instatnce.openTaskBox(configuration.groupKey);
    await _readTasksFromHive();

    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readTasksFromHive);
  }

  @override
  Future<void>  dispose() async {
    _listenableBox?.removeListener(_readTasksFromHive);
    await BoxManager.instatnce.closeBox((await _box));
    super.dispose();
  }
}

class TaskWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;

  const TaskWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static TaskWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskWidgetModelProvider>();
  }

  static TaskWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskWidgetModelProvider>()
        ?.widget;
    return widget is TaskWidgetModelProvider ? widget : null;
  }
}
