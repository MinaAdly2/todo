import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/screens/archived_tasks.dart';
import 'package:todo_app/screens/done_tasks.dart';
import 'package:todo_app/screens/new_tasks.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  int currentIndex = 0;
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBar());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase('todo.db', version: 1,
        onCreate: (Database database, int version) {
      print('Database created .......................');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('Table created...............');
      }).catchError((ex) {
        print('Error during creating table ${ex.toString()}');
      });
    }, onOpen: (Database database) {
      getDataFromDatabase(database);
      print('Database opened.................');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database!
        .rawInsert(
            "INSERT INTO tasks(title, date, time, status) VALUES( '$title', '$date', '$time', 'new')")
        .then((value) {
      print('$value insert successfully.................');
      emit(AppInsertDatabaseState());
      getDataFromDatabase(database!);
    }).catchError((ex) {
      print('Error when inserting new record ${ex.toString()}');
    });
  }

  void updateData({required String status, required int id}) {
    database!.rawUpdate(
      'UPDATE tasks SET status= ? WHERE id = ? ',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database!);
      emit(AppUpdateDatabaseState());
    });
  }

  void editItemData({
    required String title,
    required String date,
    required String time,
    required int id,
  }) {
    database!.rawUpdate(
        'UPDATE tasks SET  title = ?, date = ?, time = ? WHERE id = ?',
        [title, date, time, id]).then((value) {
      getDataFromDatabase(database!);
      emit(AppEditItemDataState());
    });
  }

  void deleteData({required int id}) {
    database!.rawDelete('DELETE FROM tasks WHERE id = $id').then((value) {
      getDataFromDatabase(database!);
      emit(AppDeleteDatabaseState());
    });
  }

  void getDataFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit_outlined;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
