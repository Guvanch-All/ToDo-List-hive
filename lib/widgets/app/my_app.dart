import 'package:flutter/material.dart';
import 'package:todo_list_hive/widgets/group/groups_widget.dart';
import 'package:todo_list_hive/widgets/group_form/group_form_widget.dart';
import 'package:todo_list_hive/widgets/task_form/task_form_widget.dart';
import 'package:todo_list_hive/widgets/tasks/tasks_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/groups': (context) =>const GroupWidget(),
        '/groups/form': (context) =>const GroupFormWidget(),
        '/groups/tasks': (context) =>const TaskWidget(),
        '/groups/tasks/formTask': (context) =>const TaskFormWidget(),
      },
      initialRoute: '/groups',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}