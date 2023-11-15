import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/core/local_api/task_local_api.dart';
import 'package:todo_app/screens/create_task_screen.dart';
import 'package:todo_app/widgets/task_card_widget.dart';

import '../core/entity/task_entity.dart';
import '../core/utils/animated_navigation.dart';
import '../core/utils/assets.dart';
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

  _refresh({bool isDownDate = false}) async {
    listTasks = await TaskLocalApi.getAll(isDownDateFilter: isDownDate);
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
          IconButton(
            onPressed: () async {
              _refresh(isDownDate: false);
            },
            icon: const Icon(
              Icons.arrow_drop_up,
            ),
          ),
          IconButton(
            onPressed: () async {
              _refresh(isDownDate: true);
            },
            icon: const Icon(
              Icons.arrow_drop_down,
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
            listTasks.isEmpty
                ? Lottie.asset(
                    Assets.tEmptyLottie,
                    frameRate: FrameRate(120),
                    animate: true,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,

                  )
                : Expanded(
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

  _onCreateTask(String title, String description, DateTime dateTime) async {
    final epochStart = DateTime.now().millisecondsSinceEpoch;

    final TaskEntity entity = TaskEntity(
      title: title,
      description: description,
      date: dateTime,
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
