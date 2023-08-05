import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/custom_text_form_field.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Center(
                child: Text(
                  cubit.titles[cubit.currentIndex],
                  style: const TextStyle(
                    fontSize: 26.0,
                  ),
                ),
              ),
              backgroundColor: Colors.blueGrey,
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (BuildContext context) =>
                  cubit.screens[cubit.currentIndex],
              fallback: (BuildContext context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: cubit.titles[cubit.currentIndex] ==
                    'New Tasks'
                ? FloatingActionButton(
                    backgroundColor: Colors.blueGrey,
                    onPressed: () {
                      if (cubit.isBottomSheetShown) {
                        if (formKey.currentState!.validate()) {
                          cubit.insertToDatabase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text,
                          );
                        }
                      } else {
                        scaffoldKey.currentState!
                            .showBottomSheet(
                              (context) => Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(20.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomTextFormField(
                                        controller: titleController,
                                        type: TextInputType.text,
                                        label: 'Task Title',
                                        prefix: Icons.title,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Title is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      CustomTextFormField(
                                        controller: dateController,
                                        type: TextInputType.datetime,
                                        label: 'Task Date',
                                        prefix: Icons.calendar_today,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Date is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2024-12-31'),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat.yMd().format(value!);
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      CustomTextFormField(
                                        controller: timeController,
                                        type: TextInputType.datetime,
                                        label: 'Task Time',
                                        prefix: Icons.watch_later_outlined,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text =
                                                value!.format(context);
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Time is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              elevation: 20.0,
                            )
                            .closed
                            .then((value) {
                          cubit.changeBottomSheetState(
                              isShow: false, icon: Icons.edit_outlined);
                        });
                        cubit.changeBottomSheetState(
                            isShow: true, icon: Icons.add);
                      }
                    },
                    child: Icon(cubit.fabIcon),
                  )
                : null,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (int index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
