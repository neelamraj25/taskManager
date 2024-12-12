import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task_model.dart';

class TaskRepository {
  final String _tasksKey = 'tasks';

  Future<void> saveTaskOffline(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    List<Task> tasks = await getTasks();
    tasks.add(task);
    final tasksJson = jsonEncode(tasks.map((task) => task.toMap()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_tasksKey);
    if (tasksJson != null) {
      final List<dynamic> tasksList = jsonDecode(tasksJson);
      return tasksList.map((task) => Task.fromMap(task,'')).toList();
    }
    return [];
  }

  Future<void> deleteTask(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<Task> tasks = await getTasks();
    tasks.removeAt(id);
    final tasksJson = jsonEncode(tasks.map((task) => task.toMap()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

Future<void> updateTask(Task task, int id) async {
  final prefs = await SharedPreferences.getInstance();
  List<Task> tasks = await getTasks();
  print('Tasks before update: $tasks');
  print('Updating task at index: $id');

  if (id < 0 || id >= tasks.length) {
    print("Invalid task index: $id");
    return;
  }

  tasks[id] = task; // Update the task at the specified index
  final tasksJson = jsonEncode(tasks.map((task) => task.toMap()).toList());
  await prefs.setString(_tasksKey, tasksJson);
  print("Updated task saved locally: $task");

}

}  