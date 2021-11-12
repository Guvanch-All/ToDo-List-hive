import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:todo_list_hive/UI/navigation/main_navigation.dart';
import 'package:todo_list_hive/UI/widgets/tasks/tasks_widget.dart';
import 'package:todo_list_hive/domain/data_provider/box_manager.dart';
import 'package:todo_list_hive/domain/entity/group.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;

  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setUp();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed((MainNavigationRouteNames.groupsForm));
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null) {
      final configuration = TaskWidgetConfiguration(
        group.key as int,
        group.name,
      );
      unawaited(
        Navigator.of(context).pushNamed(
          MainNavigationRouteNames.tasks,
          arguments: configuration,
        ),
      );
    }
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskBoName = BoxManager.instatnce.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoName);
    await box.deleteAt(groupIndex);
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setUp() async {
    _box = BoxManager.instatnce.openGroupBox();
    await _readGroupsFromHive();
    _listenableBox =(await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instatnce.closeBox((await _box));
    super.dispose();
  }
}

class GroupWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;

  const GroupWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static GroupWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupWidgetModelProvider>();
  }

  static GroupWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupWidgetModelProvider>()
        ?.widget;
    return widget is GroupWidgetModelProvider ? widget : null;
  }
}
