import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/entity/task_entity.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskEntity entity;
  const TaskCardWidget({
    Key? key,
    required this.entity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entity.title),
              Text(DateFormat("MM/dd/yyyy HH:MM").format(entity.date)),
            ],
          ),
          const Divider(),
          Text(entity.description),
        ],
      ),
    );
  }
}
