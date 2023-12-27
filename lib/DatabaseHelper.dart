import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'StudentModel.dart';

class DatabaseHelper{

  final  databaseName = 'student.db';

  String studentTable = "CREATE TABLE students (studentId INTEGER PRIMARY KEY AUTOINCREMENT, studentName ,TEXT NOT NULL, studentAge TEXT NOT NULL, studentGender, averageScore TEXT NOT NULL, createAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  Future<Database> initDB() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(studentTable);
    });
  }

  /// CRUD method

/// Create method

    Future<int> createStudent(StudentModel student) async {
    final Database db = await initDB();
    return db.insert('students', student.toMap());
    }

/// Read method

  Future<List<StudentModel>> getStudent() async{
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('students');
    return result.map((e) => StudentModel.fromMap(e)).toList();
  }
/// Update method
  Future<int> updateStudent(studentName, studentAge, studentGender, averageScore, studentId) async {
    final Database db = await initDB();
    return db.rawUpdate('studentName = ?, studentAge = ?, studentGender = ?, averageScore = ?, studentId = ?',
    [studentName, studentAge,studentGender, studentId]);
  }
/// Delete method

  Future<int> deleteStudent(int id) async {
    final Database db = await initDB();
    return db.delete('students', where: 'studentId = ?', whereArgs: [id]);
  }
}