import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
class NewTasksScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context,index)=>buildTaskItem(tasks[index] ),
        separatorBuilder:(context,index)=>Padding(
          padding: const EdgeInsetsDirectional.only(start: 10.0),
          child: Container(
            width: double.infinity,
            color: Colors.grey[300],
            height: 2.0,
          ),
        ),
        itemCount :tasks.length);


  }
  
}