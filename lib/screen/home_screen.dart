import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/bloc/task_event.dart';
import 'package:task_manager/bloc/task_state.dart';
import 'package:task_manager/screen/add_tasks_bottom_sheet.dart';
import 'drawer_navigation.dart';
import '../bloc/task_bloc.dart';
import '../model/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskBloc>(context).add(LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      _buildTaskList(context),
      _buildSearchScreen(),
      _buildProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const DrawerNavigation(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.indigo,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => AddTaskBottomSheet(),
                );
              },
              child: const Icon(Icons.add, size: 28, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskError) {
          return Center(
            child: Text(state.message,
                style: const TextStyle(fontSize: 16, color: Colors.red)),
          );
        } else if (state is TaskLoaded) {
          return state.tasks.isEmpty
              ? const Center(
                  child: Text('No Tasks Found',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                )
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('taskManager')
                      .orderBy('servertime', descending: false)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    final data = snapshot.data?.docs;
                    print('DATA=-----${data?.length}');

                    if (!snapshot.hasData) {
                      return const Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 60),
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }
                    
             
                  return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount:  state.tasks.length
                      ,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Text(
                        task.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text( task.description,
                                  style: const TextStyle(fontSize: 16)),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editTask(context, task, index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    BlocProvider.of<TaskBloc>(context)
                                        .add(DeleteTask(id: index));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                }
              );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSearchScreen() {
    return const Center(
      child: Text(
        'Search Screen',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProfileScreen() {
    return const Center(
      child: Text(
        'Profile Screen',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _editTask(BuildContext context, Task task, int index) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final updatedTask = Task(
                  title: titleController.text,
                  description: descriptionController.text,
                  status: task.status,
                );
                BlocProvider.of<TaskBloc>(context)
                    .add(UpdateTask(task: updatedTask, id: index));
                await update(
                    context, titleController.text, descriptionController.text);
                Navigator.pop(context);
              },
              child: const Text('Update Task'),
            ),
          ],
        );
      },
    );
  }

  Future<void> update(BuildContext context, String title, String des) async {
   try{
     EasyLoading.show(status: 'loading...');
    var updateSnapShot = await FirebaseFirestore.instance
        .collection('taskManager')
        .where('title', isEqualTo: title)
        .get();
    var docID = updateSnapShot.docs.first.id;
    FirebaseFirestore.instance.collection('taskManager').doc(docID).update({
      'title': title,
      'description': des,
      'servertime': FieldValue.serverTimestamp(),
    });
    EasyLoading.dismiss();
   }catch(e){
     EasyLoading.dismiss();
    debugPrint('error $e');
   }
  }
}
