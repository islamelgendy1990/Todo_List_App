
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/states/task_states.dart';
import 'package:sqflite/sqflite.dart';


class TaskCubit extends Cubit<TaskStates> {
  TaskCubit() : super(TaskInitStates());


  static TaskCubit get (BuildContext context){
    return BlocProvider.of(context);
  }


  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();


  late Database database;


  List<Map> tasksList = [];

   int? id ;



  void createDataBase() async {
    database = await openDatabase('demo.db', version: 1,
        onCreate: (database, version) {
          print('database created');
          database
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, description TEXT)')
              .then((value) {
            print('table Created');
          }).catchError((error) {});
          emit(CreateDatabaseStates());
        }, onOpen: (database) {
          getDataFromDatabase(database);
          print('database opened');
        });
  }


  void insertToDataBase({
    required String title,
    required String description,
  }) {
    database.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO tasks(title, description) VALUES("$title","$description")')
          .then((value) {
        print('$value inserted successfully');
        emit(InsertDatabaseStates());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error is ${error.toString()}');
      });
    });
  }


  void getDataFromDatabase(database) async {
    tasksList = await database.rawQuery('SELECT * FROM tasks');
    emit(GetDatabaseStates());
    print(tasksList);
  }



  // void deleteDataFromDatabase({ required int id}) async
  // {
  //   database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
  //     getDataFromDatabase(database);
  //     emit(DeleteDatabaseStates());
  //   });
  // }



  void deleteFromDatabase({ required int id,}) async
  {
    await database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      print('$value item is deleted from database');
      emit(DeleteDatabaseStates());
      getDataFromDatabase(database);
    }).catchError((onError) {
      print(onError);
    });
  }



}

