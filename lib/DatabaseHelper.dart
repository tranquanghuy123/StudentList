import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<void> createTables(Database database) async {
    await database.execute(
        ("CREATE TABLE students ("
            " studentName TEXT, "
            " studentLastName TEXT, "
            " studentAge TEXT, "
            " studentGender TEXT, "
            " studentAverageScore TEXT, "
            " createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, "
            " studentId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"
            ")"));



    await database.execute(
        ("CREATE TABLE classes ("
            " className TEXT, "
            " classAverageScore TEXT, "
            " createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, "
            " classId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"
            ")"));

    await database.execute(
        ("CREATE TABLE subjects ("
            " subjectName TEXT, "
            " createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, "
            " subjectId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"
            ")"));

  }

  static Future<Database> db() async {
    return openDatabase(
      'student_mtl.db', version: 1,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  ///CRUD


  ///Add method
  ///Add student method
  static Future<int> addStudent(String studentLastName,String studentName,
      String studentAge, String studentGender,
      String studentAverageScore) async {
    final db = await DatabaseHelper.db();

    final data = {
      'studentName': studentName,
      'studentLastName' : studentLastName,
      'studentAge': studentAge,
      'studentGender': studentGender,
      'studentAverageScore': studentAverageScore
    };
    final studentID = await db.insert('students', data);
    return studentID;
  }

  ///Add class method
  static Future<int> addClass(String className,String classAverageScore) async {
    final db = await DatabaseHelper.db();

    final data = {
      'className': className,
      'classAverageScore' : classAverageScore,
    };
    final classID = await db.insert('classes', data);
    return classID;
  }

  ///Add subject method
  static Future<int> addSubject(String subjectName) async {
    final db = await DatabaseHelper.db();
    final data = {
      'subjectName': subjectName,
    };
    final subjectNameID = await db.insert('subjects', data);
    return subjectNameID;
  }


  ///Read All method
  ///GetAllStudent method
  static Future<List<Map<String, dynamic>>> getAllStudents() async {
    final db = await DatabaseHelper.db();
    return db.query('students', orderBy: "studentId");
  }

  ///GetAllClasses method
  static Future<List<Map<String, dynamic>>> getAllClasses() async {
    final db = await DatabaseHelper.db();
    return db.query('classes', orderBy: "classId");
  }

  ///GetAllSubjects method
  static Future<List<Map<String, dynamic>>> getAllSubjects() async {
    final db = await DatabaseHelper.db();
    return db.query('subjects', orderBy: "subjectId");
  }




  ///Read specific method
  ///GetStudent method
  static Future<List<Map<String, dynamic>>> getStudent(int studentId) async {
    final db = await DatabaseHelper.db();
    return db.query('students', where: "studentId = ?", whereArgs: [studentId], limit: 1);
  }

  ///GetSClass method
  static Future<List<Map<String, dynamic>>> getClass(int classId) async {
    final db = await DatabaseHelper.db();
    return db.query('classes', where: "classId = ?", whereArgs: [classId], limit: 1);
  }

  ///GetSubject method
  static Future<List<Map<String, dynamic>>> getSubject(int subjectId) async {
    final db = await DatabaseHelper.db();
    return db.query('subjects', where: "subjectId = ?", whereArgs: [subjectId], limit: 1);
  }


  ///Update method
  /// Update Student by id
  static Future<int?> updateStudent(int studentId,String studentLastName,
      String studentName, String studentAge, String studentGender, String studentAverageScore) async {
    final db = await DatabaseHelper.db();

    final data = {
      'studentName': studentName,
      'studentLastName' : studentLastName,
      'studentAge': studentAge,
      'studentGender': studentGender,
      'studentAverageScore': studentAverageScore,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('students', data, where: "studentId = ?", whereArgs: [studentId]);
    return result;
  }

  /// Update Class by id
  static Future<int?> updateClass(int classId,String className, String classAverageScore) async {
    final db = await DatabaseHelper.db();

    final data = {
      'className': className,
      'classAverageScore' : classAverageScore,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('classes', data, where: "classId = ?", whereArgs: [classId]);
    return result;
  }

  /// Update Subject by id
  static Future<int?> updateSubject(int subjectId,String subjectName) async {
    final db = await DatabaseHelper.db();

    final data = {
      'subjectName': subjectName,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('subjects', data, where: "subjectId = ?", whereArgs: [subjectId]);
    return result;
  }





  /// Delete method
  ///Delete student
  static Future<void> deleteStudent(int? studentId) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("students", where: "studentId = ? ", whereArgs: [studentId]);
    } catch (error) {
      debugPrint("Có lỗi: $error");
    }
  }

  ///Delete class
  static Future<void> deleteClass(int? classId) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("classes", where: "classId = ? ", whereArgs: [classId]);
    } catch (error) {
      debugPrint("Có lỗi: $error");
    }
  }

  ///Delete subject
  static Future<void> deleteSubject(int? subjectId) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("subjects", where: "subjectId = ? ", whereArgs: [subjectId]);
    } catch (error) {
      debugPrint("Có lỗi: $error");
    }
  }


}