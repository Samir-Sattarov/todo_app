import 'package:flutter/material.dart';
import 'package:todo_app/core/local_api/task_local_api.dart';
import 'package:todo_app/screens/create_task_screen.dart';
import 'package:todo_app/widgets/task_card_widget.dart';

import '../core/entity/task_entity.dart';
import '../core/utils/animated_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskEntity> listTasks = [];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    final listData = await TaskLocalApi.getAll();

    listTasks = listData;
    setState(() {});
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
            child: GestureDetector(
              child: TaskCardWidget(entity: entity),
              onTap: () {
                listTasks.remove(entity);
                setState(() {});
              },
            ),
          );
        },
        itemCount: listTasks.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AnimatedNavigation.push(
            context: context,
            page: CreateTaskScreen(
              onCreate: _onCreateTask,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _onCreateTask(String title, String description) async {
    final TaskEntity entity = TaskEntity(
      title: title,
      description: description,
      date: DateTime.now(),
      status: TaskStatus.todo,
    );
    final result = await TaskLocalApi.save(entity);

    if (result) {
      listTasks.add(entity);

      setState(() {});
    }
  }
}
