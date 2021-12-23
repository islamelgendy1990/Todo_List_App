
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/states/task_states.dart';
import 'package:sqflite/sqflite.dart';


class TaskCubit extends Cubit<TaskStates> {
  TaskCubit() : super(TaskInitStates());


  static TaskCubit get (BuildContext context){
    return BlocProvider.of(context);
  }




  late Database database;


  List<Task> tasksList = [];



  void createDatabase ()
  {
     openDatabase('demo.db', version: 1, onCreate: (database, version) async
      {
        print('database created');
       await database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, description TEXT)'
        ).then((value)
        {
          print('table created');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value)
    {
      database = value;
      emit(CreateDatabaseStates());
    });
  }



  void insertToDatabase ({
    required String title,
    required String description
  }) async
  {
    await database.transaction((txn)
    {
      return txn.rawInsert(
          'INSERT INTO tasks(title, description) VALUES("$title", "$description")'
      ).then((value)
      {
        print('$value inserted successfully');
        emit(InsertDatabaseStates());

        getDataFromDatabase(database);

      }).catchError((error){
        print('Error  ${error.toString()}');
      });
    });
  }


  void getDataFromDatabase(database)
  {
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      emit(GetDatabaseStates());

      print(tasksList);
    });
  }








}

