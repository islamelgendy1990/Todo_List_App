
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

  final GlobalKey<FormState> FromKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();


  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();


  late Database database;


  List<Map> tasksList = [];

   int? id ;

  bool fIcon = false;



  void createDataBase() async {
    database = await openDatabase('demoo.db', version: 1,
        onCreate: (database, version) {
          print('database created');
          database
              .execute(
              'CREATE TABLE taskAll (id INTEGER PRIMARY KEY, title TEXT, description TEXT, date TEXT, time TEXT)')
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
    required String date,
    required String time,
  }) {
    database.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO taskAll(title, description, date, time) VALUES("$title","$description","$date","$time")')
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
    tasksList = await database.rawQuery('SELECT * FROM taskAll');
    emit(GetDatabaseStates());
    print(tasksList);
  }




  void deleteFromDatabase({ required int id,}) async
  {
    await database.rawDelete('DELETE FROM taskAll WHERE id = ?', [id]).then((value) {

      print('$value item is deleted from database');
      emit(DeleteDatabaseStates());

      getDataFromDatabase(database);

    }).catchError((onError) {
      print(onError);
    });
  }


  void updateFromDatabase({
    required int id,
    required String title,
    required String description,
    required String date,
    required String time,

  }) {
    database.rawUpdate('UPDATE taskAll SET title=?,description=?,date=?,time=? WHERE id = ?', [
      id,
      title,
      description,
      date,
      time,
    ]).then((value) {
      emit(UpdateDatabaseStates());
      print('item is update');
    }).catchError((error) {
      print('error is ${error.toString()}');
    });
  }


  void changeIcon() {
    fIcon = !fIcon;
    emit(ChangeIconBottomSheet());
  }



}




