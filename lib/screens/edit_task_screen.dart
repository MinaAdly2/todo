import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/custom_text_form_field.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class EditTask extends StatefulWidget {
  final title;
  final date;
  final time;
  final id;
  EditTask({Key? key, this.title, this.date, this.time, this.id})
      : super(key: key);

  static String editTask = 'editTask';

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController titleController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.title;
    timeController.text = widget.time;
    dateController.text = widget.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppEditItemDataState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  'Edit Task',
                  style: TextStyle(
                    fontSize: 26.0,
                  ),
                ),
              ),
              backgroundColor: Colors.blueGrey,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  CustomTextFormField(
                    controller: titleController,
                    type: TextInputType.text,
                    label: 'Task Title',
                    prefix: Icons.title,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title is required';
                      }
                      return null;
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
                        lastDate: DateTime.parse('2023-12-31'),
                      ).then((value) {
                        dateController.text = DateFormat.yMMMd().format(value!);
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  CustomTextFormField(
                    controller: timeController,
                    type: TextInputType.datetime,
                    label: 'Task Time',
                    prefix: Icons.watch_later_outlined,
                    onTap: () {
                      showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
                          .then((value) {
                        timeController.text = value!.format(context);
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
                  SizedBox(
                    height: 15.0,
                  ),
                  MaterialButton(
                    onPressed: () {
                      AppCubit.get(context).editItemData(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text,
                        id: widget.id,
                      );
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    color: Colors.blueGrey,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
