import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/bloc/task_cubit.dart';
import 'package:todo_list_app/network/chash_helper.dart';
import 'package:todo_list_app/states/task_states.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TaskCubit(),
      child: BlocConsumer<TaskCubit, TaskStates>(
        listener: (BuildContext context, state){},
        builder: (BuildContext context, state){

          var cubit = TaskCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.teal[400],
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 50, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.playlist_add_check, size: 40, color: Colors.white,),
                        SizedBox(width: 20,),
                        Text('Todo List', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    const Text('4 Tasks', style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    ),
                    const SizedBox(height: 20,),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: cubit.tasksList.isEmpty
                            ? const Center(child: Text('No Groceries in your list.'),)
                            : ListView.builder(
                            itemCount: cubit.tasksList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Padding(padding: const EdgeInsets.only(right: 5, left: 5, top: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 5,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5, right: 5),
                                        child: Container(
                                          child: ListTile(
                                            title: Text(
                                              cubit.tasksList[index].title,
                                              maxLines: 3,
                                              style: const TextStyle(fontSize: 15),
                                            ),
                                            subtitle: Text(
                                              cubit.tasksList[index].description,
                                              maxLines: 6,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            trailing: IconButton(
                                                onPressed: (){
                                                  cubit.deleteTasksList(index);
                                                },
                                                icon: const Icon(Icons.delete, color: Colors.red,)
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius: BorderRadius.circular(17)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                    ],
                                  ),
                                )
                              );
                            }
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                _showDialog(context);
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.deepOrange,
            ),
          );
        },
      ),
    );
  }
}



void _showDialog(BuildContext context) {

  var cubit = TaskCubit.get(context);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  const Text("Add Tasks"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: cubit.titleTextController,
              decoration: const InputDecoration(
                  labelText: "Add title Tasks",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  )
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: cubit.descriptionTextController,
              decoration: const InputDecoration(
                  labelText: "Add description Tasks",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  )
              ),
            ),
          ),
          FlatButton(
            child: const Text("Add"),
            onPressed: () {
              cubit.addTitleTasksList();
              cubit.titleTextController.clear();
              cubit.descriptionTextController.clear();
              CashHelper.saveData(key: "tasksList", value: cubit.tasksList);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}