
import 'package:flutter/material.dart';


class TaskTile extends StatelessWidget {


   bool isCheck = false ;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('go shoping'),
      trailing: Checkbox(
        value: isCheck,
        onChanged: (value){
          isCheck = value! ;
        },
      ),
    );
  }
}
