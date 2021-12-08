import 'package:flutter/material.dart';
import 'package:todo_list_app/network/chash_helper.dart';
import 'package:todo_list_app/ui/home_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await CashHelper.init();

  CashHelper.getData(key: "tasksList");

  runApp(const MyApp());
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
