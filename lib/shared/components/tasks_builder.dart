import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/custom_task_item.dart';

class TasksBuilder extends StatelessWidget {
  List<Map> tasks;
  Color cirAvtColor;
  String taskState;
  TasksBuilder({
    required this.tasks,
    this.cirAvtColor = Colors.black,
    required this.taskState,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemCount: tasks.length,
        itemBuilder: (context, index) =>
            CustomTaskItem(item: tasks[index], cirAvtColor: cirAvtColor),
        separatorBuilder: (context, index) => const Divider(
          height: 20.0,
          color: Colors.grey,
          indent: 10.0,
          thickness: 1.0,
        ),
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu,
              size: 50.0,
              color: Colors.grey,
            ),
            Text(
              'No $taskState Tasks Yet...',
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
