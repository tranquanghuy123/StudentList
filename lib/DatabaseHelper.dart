import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'StudentModel.dart';

class DatabaseHelper {
  static Database? _db;

  ///Tên database
  static const String DB_Name = 'student.db';

  ///Tên bảng
  static const String Table_Student = 'students';
  static const int Version = 1;


  ///Tên của column (các thuộc tính trong bảng)
  //static const int C_UserID = 1;
  static const String C_StudentID = 'studentId';
  static const String C_StudentName = 'studentName';
  static const String C_StudentAge = 'studentAge';
  static const String C_StudentGender = 'studentGender';
  static const String C_StudentAverageScore = 'studentAverageScore';
  static const String C_CreateAt = 'createAt';




  ///Hàm Database (DB)
  static Future<Database?> get db async {

    if (_db != null) {
      return _db;
    }
    _db =  await initDb();
    return _db;
  }

  static Future<Database?> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path= join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }

  static Future<void> _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $Table_Student ("
        " $C_StudentID TEXT, "
        " $C_StudentName TEXT, "
        " $C_StudentAge TEXT, "
        " $C_StudentGender TEXT, "
        " $C_StudentAverageScore TEXT,"
        " $C_CreateAt TEXT, "
        " PRIMARY KEY ($C_StudentID)"
        ")");
  }

  ///CRUD

  ///Add method
  static Future<int?> addStudent(StudentModel student) async {
    var dbClient = await db;
    int? id = await dbClient?.insert(Table_Student, student.toMap());
    return id;
  }

  ///GetAllStudent method

  static Future<List<StudentModel>> getAllStudents() async {
    var dbClient = await db;
    final List<StudentModel>? maps = await dbClient?.rawQuery('SELECT * FROM $Table_Student');

    if (maps != null) {
      return List.generate(maps.length, (i) {
        return StudentModel(
          studentId: maps[i]['studentId'],
          studentName: maps[i]['studentName'],
          studentAge: maps[i]['studentAge'],
          studentGender: maps[i]['studentGender'],
          studentAverageScore: maps[i]['studentAverageScore'],
        createAt: maps[i]['createAt'],
        );
      });
    } else {
      return []; // Return an empty list if maps is null
    }
  }

  Future<StudentModel?> getStudentById(String studentId) async {
    var dbClient = await db;
    var res = await dbClient?.rawQuery("SELECT * FROM $Table_Student WHERE "
        "$C_StudentID = '$studentId'");

    if (res?.isNotEmpty ?? false) {
      return StudentModel.fromMap(res!.first);
    }

    return null;
  }


  ///Update method

  static Future<void> updateStudent(StudentModel student) async {
    var dbClient = await db;
    var res = await dbClient?.update(Table_Student, student.toMap(),
        where: '$C_StudentID = ?', whereArgs: [student.studentId]);
    print(res);
    print(student.studentId);
  }

/// Delete method
static Future<int?> deleteStudent(String studentId) async {
  var dbClient = await db;
  var res = await dbClient?.delete(Table_Student, where: '$C_StudentID = ?', whereArgs: [studentId]);
  return res;
}


  }


