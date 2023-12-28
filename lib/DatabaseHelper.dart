import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'StudentModel.dart';

class DatabaseHelper {

  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE students(
        studentId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        studentName TEXT,
        studentAge TEXT,
        studentGender TEXT,
        studentAverageScore TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

      // id: the id of a student
     // studentName, studentAge,studentGender, studentAverageScore : name, age ender, average score of a student
    // created_at: the time that the item was created. It will be automatically handled by SQLite
  }

  static Future<Database> db() async {
    return openDatabase(
      'student.db',      version: 1,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  ///CRUD

  ///Add method
  static Future<int> addStudent(String studentName, String studentAge, String studentGender, String studentAverageScore) async {
    final db = await DatabaseHelper.db();

    final data = {
      'studentName': studentName,
      'studentAge': studentAge,
      'studentGender': studentGender,
      'studentAverageScore': studentAverageScore,
    };
    final id = await db.insert('students', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  ///GetAllStudent method

  static Future<List<Map<String, dynamic>>> getAllStudents() async {
    final db = await DatabaseHelper.db();
    return db.query('students', orderBy: "studentId");
  }

  ///GetStudent method

  static Future<List<Map<String, dynamic>>> getStudent(int studentId) async {
    final db = await DatabaseHelper.db();
    return db.query('students', where: "studentId = ?", whereArgs: [studentId], limit: 1);
  }

  ///Update method

  static Future<List<Map<String, dynamic>>> getSpecificStudent(int studentId) async {
    final db = await DatabaseHelper.db();
    return db.query('students', where: "studentId = ?", whereArgs: [studentId], limit: 1);
  }

  // Update an item by id
  static Future<int?> updateStudent(int studentId,
      String studentName, String studentAge, String studentGender, String studentAverageScore) async {
    final db = await DatabaseHelper.db();

    final data = {
      'studentName': studentName,
      'studentAge': studentAge,
      'studentGender': studentGender,
      'studentAverageScore': studentAverageScore,
      'createdAt': DateTime.now().toString()
    };
  }

  /// Delete method
  static Future<void> deleteItem(int studentId) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("students", where: "studentId = ?", whereArgs: [studentId]);
    } catch (error) {
      debugPrint("Có lỗi: $error");
    }
  }

}