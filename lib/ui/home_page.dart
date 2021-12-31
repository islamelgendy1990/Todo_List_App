import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/bloc/task_cubit.dart';
import 'package:todo_list_app/states/task_states.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



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

          var height= MediaQuery.of(context).size.height;
          var width= MediaQuery.of(context).size.width;

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
                                      Slidable(
                                        key: const ValueKey(0),
                                        startActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context){
                                                cubit.deleteFromDatabase(id: cubit.tasksList[index]['id']);
                                              },
                                              backgroundColor: const Color(0xFFFE4A49),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: 'Delete',
                                            ),
                                          ],
                                        ),
                                        endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context){
                                                cubit.updateFromDatabase(id: cubit.tasksList[index]['id'], title: cubit.titleTextController.text, description: cubit.descriptionTextController.text, date: cubit.dateController.text, time: cubit.timeController.text);
                                                bottomSheet(context, cubit);
                                              },
                                              backgroundColor: const Color(0xFF21B7CA),
                                              foregroundColor: Colors.white,
                                              icon: Icons.edit,
                                              label: 'Update',
                                            ),
                                          ],
                                        ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0, right: 0),
                                            child: Card(
                                              child: Container(
                                                height:(width>height)?width/2:height/7,
                                                width: width,
                                                padding: const EdgeInsets.all(12),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    CircleAvatar(
                                                        radius: 50,
                                                        backgroundColor: Colors.teal[400],
                                                        child: Text(cubit.tasksList[index]['time'].toString(),)),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(cubit.tasksList[index]['title'].toString(),
                                                            style: const TextStyle(
                                                                color: Colors.black54,
                                                                fontSize: 17,
                                                                fontWeight: FontWeight.bold),maxLines: 1,),
                                                          Text(cubit.tasksList[index]['description'].toString(),
                                                            style: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 17,
                                                                fontWeight: FontWeight.bold),maxLines: 2,),
                                                          const SizedBox(height: 10),
                                                          Text(cubit.tasksList[index]['date'].toString(),
                                                              style: const TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 14,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              color: Colors.white,
                                              elevation: 0,
                                              shadowColor: Colors.cyanAccent,
                                            ),
                                          ),
                                      ),
                                       Divider(
                                        color: Colors.grey[200],
                                        endIndent: 10,
                                        indent: 10,
                                        thickness: 4,
                                      ),
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
               child: const Icon(Icons.add),
               backgroundColor: Colors.deepOrangeAccent,
              onPressed: () {
                bottomSheet(context, cubit);
              }
            )
          );
        },
      ),
    );
  }






   bottomSheet(context, cubit) {
     var cubit = TaskCubit.get(context);
     showModalBottomSheet(context: context, builder: (BuildContext context){
       return Container(
       color: Colors.lightGreen.shade50,
         padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
           child: Form(
             key: cubit.FromKey,
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 FloatingActionButton(
                     child: !cubit.fIcon ? const Icon(Icons.add) : const Icon(Icons.edit),
                     backgroundColor: Colors.deepOrangeAccent,
                     onPressed: (){
                  if (!cubit.fIcon) {
                    if (cubit.FromKey.currentState!.validate()) {
                      cubit.insertToDataBase(
                          title: cubit.titleTextController.text,
                          description: cubit.descriptionTextController.text,
                          date: cubit.dateController.text,
                          time: cubit.timeController.text);
                      cubit.titleTextController.clear();
                      cubit.descriptionTextController.clear();
                      cubit.timeController.clear();
                      cubit.dateController.clear();
                      Navigator.pop(context);
                    } else {
                      cubit.scaffoldKey.currentState!
                          .showBottomSheet<dynamic>(
                              (context) => bottomSheet(context, cubit))
                          .closed
                          .then((value) => cubit.changeIcon());
                      cubit.changeIcon();
                   }
                    }
                     }
                 ),
                 const SizedBox(height: 8),
                 TextFormField(
                   inputFormatters: [
                     LengthLimitingTextInputFormatter(55),
                   ],
                   controller: cubit.titleTextController,
                   keyboardType: TextInputType.text,
                   decoration: InputDecoration(
                       prefixIcon: const Icon(Icons.short_text),
                       labelText: "Task title",
                       border: OutlineInputBorder(
                           borderSide: const BorderSide(color: Colors.lightGreen),
                           borderRadius: BorderRadius.circular(5),
                           gapPadding: 5)),
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return 'Please enter enter some title';
                     }
                     return null;
                   },
                 ),
                 const SizedBox(height: 8),
                 TextFormField(
                   inputFormatters: [
                     LengthLimitingTextInputFormatter(55),
                   ],
                   controller: cubit.descriptionTextController,
                   keyboardType: TextInputType.text,
                   decoration: InputDecoration(
                       prefixIcon: const Icon(Icons.short_text),
                       labelText: "Task description",
                       border: OutlineInputBorder(
                           borderSide: const BorderSide(color: Colors.lightGreen),
                           borderRadius: BorderRadius.circular(5),
                           gapPadding: 5)),
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return 'Please enter some description';
                     }
                     return null;
                   },
                 ),
                 const SizedBox(height: 8),
                 TextFormField(
                   onTap: () {
                     showDatePicker(
                         context: context,
                         initialDate: DateTime.now(),
                         firstDate: DateTime.now(),
                         lastDate: DateTime.parse('2022-05-01'))
                         .then((value) => cubit.dateController.text =
                         DateFormat.yMMMEd().format(value!).toString());
                   },
                   controller: cubit.dateController,
                   keyboardType: TextInputType.datetime,
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return 'Please enter Your Task date';
                     }
                     return null;
                   },
                   decoration: InputDecoration(
                       prefixIcon: const Icon(Icons.calendar_today),
                       labelText: "Task date",
                       border: OutlineInputBorder(
                           borderSide: const BorderSide(color: Colors.lightGreen),
                           borderRadius: BorderRadius.circular(5),
                           gapPadding: 5)),
                 ),
                 const SizedBox(height: 8),
                 TextFormField(
                   onTap: () {
                     showTimePicker(context: context, initialTime: TimeOfDay.now())
                         .then((value) => cubit.timeController.text =
                         value!.format(context).toString());
                   },
                   controller: cubit.timeController,
                   keyboardType: TextInputType.datetime,
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return 'Enter Your Task time';
                     }
                     return null;
                   },
                   decoration: InputDecoration(
                       prefixIcon: const Icon(Icons.watch),
                       labelText: "Task time",
                       border: OutlineInputBorder(
                           borderSide: const BorderSide(color: Colors.lightGreen),
                           borderRadius: BorderRadius.circular(5),
                           gapPadding: 5)),
                 )
               ],
             ),
           ),
       );

     });
  }






}









