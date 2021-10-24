import 'package:flutter/material.dart';
Widget defaultFormField({
  @required TextEditingController controller,
  @required FormFieldValidator validate,
  @required TextInputType type,
  @required String label,
  @required IconData prefix,
 Function onTap(),
  //bool isClickable=true,
})
 => TextFormField(
    controller:controller,
    keyboardType: type,
    validator:validate,
    decoration: InputDecoration(labelText:label,
      prefixIcon:Icon(prefix),
    border:OutlineInputBorder()

    ),
   onTap: onTap,
  );
    Widget buildTaskItem(Map model)=>Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            child: Text(
               '${model['time']}',
            ),
          ),
          SizedBox(width: 20.0,),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(color: Colors.grey),

              )
            ],
          )
        ],

      ),
    );
