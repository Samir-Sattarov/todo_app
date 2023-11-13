import 'package:flutter/material.dart';
import 'package:todo_app/core/local_api/task_local_api.dart';
import 'package:todo_app/screens/create_task_screen.dart';
import 'package:todo_app/widgets/task_card_widget.dart';

import '../core/entity/task_entity.dart';
import '../core/utils/animated_navigation.dart';
import '../widgets/search_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskEntity> listTasks = [];

  final TextEditingController controllerSearch = TextEditingController();

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

  _refresh() async {
    listTasks = await TaskLocalApi.getAll();
    setState(() {});
  }

  search(String search) async {
    listTasks = await TaskLocalApi.getAll(search: search);
    setState(() {});
  }

  delete(TaskEntity entity) async {
    final result = await TaskLocalApi.delete(entity.id);

    if (result) {
      listTasks.remove(entity);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Awesome TODO"),
        actions: [
          IconButton(
            onPressed: () async {
              await TaskLocalApi.deleteAllTasks();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () async => await _refresh(),
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchWidget(
              controller: controllerSearch,
              onChange: (p0) {
                print("On change $p0");
              },
              onSubmit: (p0) {
                print("On Submit $p0");
                search(p0);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final entity = listTasks[index];

                  return GestureDetector(
                    child: TaskCardWidget(entity: entity),
                    onTap: () {
                      delete(entity);
                    },
                  );
                },
                itemCount: listTasks.length,
              ),
            ),
          ],
        ),
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
    final epochStart = DateTime.now().millisecondsSinceEpoch;

    final TaskEntity entity = TaskEntity(
      title: title,
      description: description,
      date: DateTime.now(),
      status: TaskStatus.todo,
      id: epochStart.toString(),
    );
    final result = await TaskLocalApi.save(entity);

    if (result) {
      listTasks.add(entity);

      setState(() {});
    }
  }
}
