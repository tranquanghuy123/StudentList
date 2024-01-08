import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentlist/Screen/class_list_screen.dart';
import 'package:studentlist/Screen/home_screen1.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  configScreenLoader(
    loader: const AlertDialog(
      title: Text('Gobal Loader..'),
    ),
    bgBlur: 20.0,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

