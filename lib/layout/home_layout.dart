import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  Database database; //type of object is Database
  var scaffoldKey = GlobalKey<ScaffoldState>(); //to open buttomsheet
  var formKey = GlobalKey<FormState>(); // to validate
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit(),
        child: BlocConsumer<AppCubit, AppStates>(
            listener: (BuildContext context, AppStates state) {},
            builder: (BuildContext context, AppStates state) {
              return Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    title: Text(""
                      // titles[currentIndex],
                      // style:
                      //     TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      if (isBottomSheetShown) {
                        if (formKey.currentState.validate()) {
                          insertToDatabase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text,
                          ).then((value) {
                            getDataFromDatabase(database).then((value) {
                              Navigator.pop(context);
                              // setState(() {
                              //   isBottomSheetShown=false;
                              //   varIcon=Icons.edit;
                              //   tasks=value;
                              //   print('tasks from database $tasks');
                              // });
                            });
                          });
                        }
                      } else {
                        scaffoldKey.currentState
                            .showBottomSheet(
                              (context) => Container(
                                padding: EdgeInsets.all(20),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                        controller: titleController,
                                        type: TextInputType.text,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'title must not be empty';
                                          }
                                          return null;
                                        },
                                        label: 'Text title',
                                        prefix: Icons.title,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      defaultFormField(
                                        controller: timeController,
                                        type: TextInputType.datetime,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'time must not be empty';
                                          }
                                          return null;
                                        },
                                        label: 'Task Time ',
                                        prefix: Icons.watch_later,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text = value
                                                .format(context)
                                                .toString();
                                            print(value.format(context));
                                          });
                                          return null;
                                        },
                                      ),
                                      defaultFormField(
                                        controller: dateController,
                                        type: TextInputType.datetime,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return 'date must not be empty';
                                          }
                                          return null;
                                        },
                                        label: 'Task date ',
                                        prefix: Icons.calendar_today,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2021-09-03'))
                                              .then((value) {
                                            dateController.text = DateFormat()
                                                .add_yMMMd()
                                                .format(value);
                                            // print(DateFormat().add_yMMMd().format(value));
                                          });
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              elevation: 20.0,
                            )
                            .closed
                            .then((value) {
                          //  Navigator.pop(context);     //i close it by myself so i don't need this step
                          isBottomSheetShown = false;
                          // setState(() {
                          //   varIcon = Icons.edit;
                          // });
                        });

                        isBottomSheetShown = true;
                        fabIcon = Icons.add;
                      }
                    },
                    child: Icon(Icons.add),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    onTap: (index) {
                      // setState(() {
                      //   currentIndex = index;
                      // });
                    },
                    // currentIndex: currentIndex,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.menu), label: 'Tasks'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.check_circle), label: 'Done'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.archive), label: 'Archived'),
                    ],
                  ),
                  body: ConditionalBuilder(
                    condition: tasks.length > 0,
                    // builder: (context) => screens[currentIndex],
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                  ));
            }));
  }

  // Future<String> getName() async {
  //   //because it will come from the background
  //   return 'Esraa Mansour';
  // }

  void createDatabase() async //first step ..create database.
  {
    database = await openDatabase(' todo.db', //create file
        version: 1, //i only have one table now and work on it
        onCreate: (database, version) {
      print('database created');
      database //object +execute to create the table.
          .execute(
              ('CREATE TABLE tasks(id INTEGER PRIMARY KEY,title Text,date Text ,time Text ,status Text)'))
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('Error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database).then((value) {
        // setState(() {
        //   tasks=value;
        // });
        // print(tasks[0]);
        // print(tasks[0]['title']);    //the way to call map.
        // print(tasks[0]['time']);
      });
    });
  }

  Future insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    return await database.transaction((txn) {
      //  i used future bc i want to call it then
      txn
          .rawInsert(
        'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        print("$value inserted successfully");
      }).catchError((error) {
        print('Error when inserting new record ${error.toString()}');
      });

      return null;
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}
