import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/network/chash_helper.dart';
import 'package:todo_list_app/states/task_states.dart';


class TaskCubit extends Cubit<TaskStates> {
  TaskCubit() : super(TaskInitStates());

  static TaskCubit get (BuildContext context){
    return BlocProvider.of(context);
  }


  List<Task> tasksList = [];

  List<Task> get tasks{
    return tasksList;
  }



  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();


  void addTitleTasksList () {
    tasksList.add(Task(title: titleTextController.text, description: descriptionTextController.text));
    emit(AddTitleListStates());
  }

  void deleteTasksList (index) {
    tasksList.removeAt(index);

    emit(DeleteTasksListStates());
  }

  void putTitleTasksList () async {
  await CashHelper.saveData(key: "tasksList", value: tasksList).then((value) {
      return emit(PutTasksListStates());
    });
  }

  void getTitleTasksList () {
   CashHelper.getData(key: "tasksList");
   emit(GetTasksListStates());
  }













}

