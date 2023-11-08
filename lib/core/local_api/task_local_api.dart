import 'package:hive/hive.dart';
import 'package:todo_app/core/utils/hive_box_constants.dart';

import '../entity/task_entity.dart';

class TaskLocalApi {
  static Future<bool> save(TaskEntity entity) async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.tasksBox);

      box.add(entity.toJson());

      print("To json ${entity.toJson()}");
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<List<TaskEntity>> getAll() async {
      final box = await Hive.openBox(HiveBoxConstants.tasksBox);

      final List<TaskEntity> listTasks = [];
      for (var json in box.values) {
        listTasks.add(TaskEntity.fromJson(Map.from(json)));
      }


      return listTasks;

  }

}
