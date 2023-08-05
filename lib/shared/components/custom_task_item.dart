import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screens/edit_task_screen.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

class CustomTaskItem extends StatelessWidget {
  Map item;
  Color cirAvtColor;
  CustomTaskItem({required this.item, this.cirAvtColor = Colors.blueGrey});
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = BlocProvider.of(context);
    return Dismissible(
      key: Key(item['id'].toString()),
      onDismissed: (direction) {
        cubit.deleteData(id: item['id']);
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.blueGrey,
            child: Text(
              item['time'],
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  item['date'],
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditTask(
                    title: item['title'],
                    date: item['date'],
                    time: item['time'],
                    id: item['id'],
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.blue,
              size: 26.0,
            ),
          ),
          if (cubit.titles[cubit.currentIndex] == 'New Tasks')
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    cubit.updateData(status: 'done', id: item['id']);
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 26.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cubit.updateData(status: 'archived', id: item['id']);
                  },
                  icon: const Icon(
                    Icons.archive_outlined,
                    color: Colors.blueGrey,
                    size: 26.0,
                  ),
                ),
              ],
            ),
          if (cubit.titles[cubit.currentIndex] == 'Done Tasks')
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    cubit.updateData(status: 'new', id: item['id']);
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.blueGrey,
                    size: 26.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cubit.updateData(status: 'archived', id: item['id']);
                  },
                  icon: Icon(
                    Icons.archive_outlined,
                    color: Colors.blueGrey,
                    size: 26.0,
                  ),
                ),
              ],
            ),
          if (cubit.titles[cubit.currentIndex] == 'Archived Tasks')
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    cubit.updateData(status: 'new', id: item['id']);
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.blueGrey,
                    size: 26.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cubit.updateData(status: 'done', id: item['id']);
                  },
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 26.0,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
