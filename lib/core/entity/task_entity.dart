enum TaskStatus {
  todo,
  process,
  done,
}

class TaskEntity {
  final String id;
  final String title;
  final String description;
  final DateTime date;
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
