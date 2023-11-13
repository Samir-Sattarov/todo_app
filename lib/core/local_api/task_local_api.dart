import 'package:hive/hive.dart';
import 'package:todo_app/core/utils/hive_box_constants.dart';

import '../entity/task_entity.dart';

class TaskLocalApi {
  static Future<bool> save(TaskEntity entity) async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.tasksBox);

      box.put(entity.id, entity.toJson());

      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<List<TaskEntity>> getAll({String search = "", DateTime? filterDate}) async {
    final box = await Hive.openBox(HiveBoxConstants.tasksBox);

    final List<TaskEntity> listTasks = [];

    for (var json in box.values) {
      listTasks.add(TaskEntity.fromJson(Map.from(json)));
    }

    if (search.isNotEmpty) {
      listTasks.removeWhere((element) =>
          !element.title.contains(search) &&
          !element.description.contains(search));
    }

    return listTasks;
  }

  static Future<bool> deleteAllTasks() async {
    final box = await Hive.openBox(HiveBoxConstants.tasksBox);

    try {
      box.clear();
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<bool> delete(String taskId) async {
    final box = await Hive.openBox(HiveBoxConstants.tasksBox);

    try {
      await box.delete(taskId);

      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

//
  // static Future<void> delete(String taskId) async {
  //   final box = await Hive.openBox(HiveBoxConstants.tasksBox);
  //   final taskList = box.values.toList();
  //
  //   final taskIndex = taskList.indexWhere((task) => task['id'] == taskId);
  //   if (taskIndex != -1) {
  //     await box.deleteAt(taskIndex);
  //   }
  //
  //   await box.close();
  // }
}
