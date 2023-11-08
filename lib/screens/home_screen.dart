import 'package:flutter/material.dart';
import 'package:todo_app/widgets/task_card_widget.dart';

import '../core/entity/task_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TaskEntity> listTasks = [
    TaskEntity(
        title: "title",
        description: "description",
        date: DateTime.now(),
        status: TaskStatus.todo,),
    TaskEntity(
        title: "title",
        description: "description",
        date: DateTime.now(),
        status: TaskStatus.process,),
    TaskEntity(
      title: "title",
      description: "description",
      date: DateTime.now(),
      status: TaskStatus.done,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Awesome TODO"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final entity = listTasks[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TaskCardWidget(entity: entity),
          );

        },
        itemCount: listTasks.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
