import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/network/chash_helper.dart';
import 'package:todo_list_app/ui/home_page.dart';

import 'network/bloc_observer.dart';

void main() {

  BlocOverrides.runZoned(() {
    runApp(const MyApp());
  },
    blocObserver: MyBlocObserver(),
  );


}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo List App',
      home: HomePage(),
    );
  }
}
