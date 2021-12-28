import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/bloc/task_cubit.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/states/task_states.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (BuildContext context) => TaskCubit()..createDataBase(),
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
                     Text('${cubit.tasksList.length.toInt()} Tasks', style: const TextStyle(
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
                            ?  Center(child: Image.asset("assets/list.jpeg", ),)
                            : ListView.builder(
                            itemCount: cubit.tasksList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                key: key,
                                child: Padding(padding: const EdgeInsets.only(right: 5, left: 5, top: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 5,),
                                      Dismissible(
                                          key: Key(cubit.tasksList[index]['id'].toString()),
                                          onDismissed: (direction)
                                          {
                                            if (direction == DismissDirection.startToEnd) {
                                              cubit.deleteFromDatabase(id: cubit.tasksList[index]['id']);
                                            } else {
                                              cubit.deleteFromDatabase(id: cubit.tasksList[index]['id']);
                                            }
                                          },
                                        background: Container(
                                          color: Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: const [
                                                Icon(Icons.delete, color: Colors.white),
                                                Text('Move to trash', style: TextStyle(color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        secondaryBackground: Container(
                                          color: Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: const [
                                                Icon(Icons.delete, color: Colors.white),
                                                Text('Move to trash', style: TextStyle(color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        confirmDismiss: (DismissDirection direction) async {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Delete Confirmation"),
                                                content: const Text("Are you sure you want to delete this item?"),
                                                actions: [
                                                  FlatButton(
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                      child: const Text("Delete")
                                                  ),
                                                  FlatButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text("Cancel"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0, right: 0),
                                            child: Card(
                                              child: ListTile(
                                                title: Text(
                                                  cubit.tasksList[index]['title'].toString(),
                                                  maxLines: 3,
                                                  style: const TextStyle(fontSize: 15),
                                                ),
                                                isThreeLine: true,
                                                subtitle: Text(
                                                  cubit.tasksList[index]['description'].toString(),
                                                  maxLines: 6,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                ),
                                              ),
                                              color: Colors.white,
                                              elevation: 2,
                                              shadowColor: Colors.cyanAccent,
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
              backgroundColor: Colors.deepOrangeAccent,
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
          Row(
            children: [
              MaterialButton(
                child: const Text("Add", style: TextStyle(color: Colors.blue),),
                onPressed: () {
                  cubit.insertToDataBase(title: cubit.titleTextController.text, description: cubit.descriptionTextController.text);
                 // cubit.getDataFromDatabase(cubit.database);
                  cubit.titleTextController.clear();
                  cubit.descriptionTextController.clear();
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                child: const Text("Cancel", style: TextStyle(color: Colors.red),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      );
    },
    barrierDismissible: false,
  );
}