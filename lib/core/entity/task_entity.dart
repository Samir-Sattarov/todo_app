import 'package:hive/hive.dart';

part 'task_entity.g.dart';

@HiveType(typeId: 2)
enum TaskStatus {
  @HiveField(1)
  todo,
  @HiveField(2)
  process,
  @HiveField(3)
  done,
}

@HiveType(typeId: 1)
class TaskEntity {
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final TaskStatus status;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
  });

  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      status: TaskStatus.values[json['isDone']],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date.toIso8601String();
    data['isDone'] = status.index;

    return data;
  }
}
