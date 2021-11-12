import 'package:flutter/material.dart';
import 'package:todo_list_hive/domain/data_provider/box_manager.dart';
import 'package:todo_list_hive/domain/entity/group.dart';

class GroupFormWidgetModel {
  var groupName = '';

  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;

    final box = await BoxManager.instatnce.openGroupBox();
    final group = Group(name: groupName);
    await box.add(group);
    await BoxManager.instatnce.closeBox(box);
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider extends InheritedWidget {
  final GroupFormWidgetModel model;
  const GroupFormWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
    key: key,
    child: child,
  );

  static GroupFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return false;
  }
}