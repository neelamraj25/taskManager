
import 'package:task_manager/model/task_model.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  AddTask({required this.task});
}

class UpdateTask extends TaskEvent {
  final Task task;
  final int id;
  
  UpdateTask({required this.task, required this.id});
}

class DeleteTask extends TaskEvent {
  final int id;
  DeleteTask({required this.id});
}

class SyncTasks extends TaskEvent {}
