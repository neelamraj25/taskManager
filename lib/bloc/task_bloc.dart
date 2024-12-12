import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/task_event.dart';
import 'package:task_manager/bloc/task_state.dart';
import 'package:task_manager/model/task_model.dart';
import '../respository/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc(this.taskRepository) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await taskRepository.getTasks();
        emit(TaskLoaded(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: "Error loading tasks"));
      }
    });

    on<AddTask>((event, emit) async {
      try {
        print("Adding task: ${event.task}");
        await taskRepository.saveTaskOffline(event.task);
        final tasks = await taskRepository.getTasks();
        print("Current tasks: $tasks");
        emit(TaskLoaded(tasks: tasks));
      } catch (e) {
        print("Error: $e");
        emit(TaskError(message: "Error adding task"));
      }
    });

on<UpdateTask>((event, emit) async {
  try {
    await taskRepository.updateTask(event.task, event.id);
    final tasks = await taskRepository.getTasks();
    emit(TaskLoaded(tasks: tasks)); // Emit the updated list
  } catch (e) {
    emit(TaskError(message: "Failed to update task"));
  }
});


    on<DeleteTask>((event, emit) async {
      try {
        await taskRepository.deleteTask(event.id);
        final tasks = await taskRepository.getTasks();
        emit(TaskLoaded(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: "Error deleting task"));
      }
    });

    on<SyncTasks>((event, emit) async {
      final tasks = await taskRepository.getTasks();
      final List<Task> localTasks = [];
      tasks.addAll(localTasks);
      localTasks.clear();
      emit(TaskLoaded(tasks: tasks));
    });
  }
}
