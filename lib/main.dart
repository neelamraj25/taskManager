import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/screen/home_screen.dart';
import 'package:task_manager/screen/profile_screen.dart';
import 'package:task_manager/screen/settings_screen.dart';
import 'package:task_manager/bloc/task_bloc.dart';
import 'package:task_manager/respository/task_repository.dart';
void main()async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(TaskRepository()),
      child: MaterialApp(
        title: 'Task Manager',
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: EasyLoading.init(),
      ),
    );
  }
}
