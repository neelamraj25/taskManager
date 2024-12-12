import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/bloc/task_bloc.dart';
import 'package:task_manager/bloc/task_event.dart';
import 'package:task_manager/model/task_model.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _errorMessage;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Task',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () async {
              _addTask(context);
            },
            child: const Text('Add Task'),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _addTask(BuildContext context) async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      setState(() {
        _errorMessage = 'Title and Description cannot be empty.';
      });
    } else {
      final task = Task(
        title: title,
        description: description,
        status: 'Pending',
      );
      await add(context, _titleController.text, _descriptionController.text);

      BlocProvider.of<TaskBloc>(context).add(AddTask(task: task));
      Navigator.pop(context);
    }
  }



  Future<void> add(BuildContext context, String title, String des) async {
    try {
      EasyLoading.show(status: 'loading...');
      FirebaseFirestore.instance.collection('taskManager').add({
        'title': title,
        'description': des,
        'servertime': FieldValue.serverTimestamp(),
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
    }
  }
}
