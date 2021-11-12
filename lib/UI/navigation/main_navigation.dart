import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_hive/UI/widgets/group/groups_widget.dart';
import 'package:todo_list_hive/UI/widgets/group_form/group_form_widget.dart';
import 'package:todo_list_hive/UI/widgets/task_form/task_form_widget.dart';
import 'package:todo_list_hive/UI/widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRouteNames {
  static const groups = '/';
  static const groupsForm = '/form';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/formTask';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.groups;
  final route = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.groups: (context) => const GroupWidget(),
    MainNavigationRouteNames.groupsForm: (context) => const GroupFormWidget(),
    //   MainNavigationRouteNames.tasks: (context) =>const TaskWidget(),
    //   MainNavigationRouteNames.tasksForm: (context) =>const TaskFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.tasks:
        final configuration = settings.arguments as TaskWidgetConfiguration;
        return MaterialPageRoute(
            builder: (context) => TaskWidget(configuration: configuration));
      case MainNavigationRouteNames.tasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => TaskFormWidget(groupKey: groupKey));
      default:
        const widget = Text('Navigation Error!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
