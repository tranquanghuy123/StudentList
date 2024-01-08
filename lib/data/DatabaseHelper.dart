import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentlist/model/class_model.dart';
import 'package:studentlist/model/student_model.dart';
import 'package:studentlist/model/subject_model.dart';

class DatabaseHelper {
  static Database? _db;

  ///Tên database
  static const String DB_Name = 'test.db';

  ///Tên bảng
  //student table
  static const String Table_Student = 'students';

  //class table
  static const String Table_Class = 'classes';

  //subject table
  static const String Table_Subjects = 'subjects';

  static const int Version = 1;

  ///Hàm Database (DB)
  static Future<Database?> get db async {

    if (_db != null) {
      return _db;
    }
    _db =  await initDb();
    return _db;
  }

  static Future<Database?> initDb() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    String path= join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: createTables);
    return db;
  }


  static Future<void> createTables(Database database, int intVersion) async {
    await database.execute(
        ("CREATE TABLE $Table_Student ("
            " studentName TEXT, "
            " studentLastName TEXT, "
            " studentAge TEXT, "
            " studentGender TEXT, "
            " studentAverageScore TEXT, "
            " className TEXT, "
            " subjectName TEXT, "
            " createAt TEXT, "
            " studentId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"
            ")"));



    await database.execute(
        ("CREATE TABLE $Table_Class ("
            " className TEXT, "
            " classAverageScore TEXT, "
            " createAt TEXT, "
            " classId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"
            ")"));

    await database.execute(
        ("CREATE TABLE $Table_Subjects ("
            " subjectName TEXT, "
            " createAt TEXT, "
            " subjectId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"
            ")"));


    /// Copy data from class table to student table
    await copyClassDataToStudent(database, 'classes', 'className', 'students');

    /// Copy data from subject table to student table
    await copySubjectDataToStudent(database, 'subjects', 'subjectName', 'students');


  }



  /// Copy data from class table to student table
  static copyClassDataToStudent(Database database, String classes, String className, String students) async{
    await database.execute(
      'INSERT INTO $students ($className) SELECT $className FROM $classes',
    );
  }


  /// Copy data from subject table to student table
  static copySubjectDataToStudent(Database database, String subjects, String subjectName, String students) async{
    await database.execute(
      'INSERT INTO $students ($subjectName) SELECT $subjectName FROM $subjects',
    );
  }

  ///CRUD


  ///Add method
  ///Add student method
  static Future<int?> addStudent(StudentModel student) async {
    var dbClient = await db;
    int? studentID = await dbClient?.insert(Table_Student, student.toMap());
    return studentID;
  }

  ///Add class method
  static Future<int?> addClass(ClassModel classes) async {
    var dbClient = await db;

    int? classID = await dbClient?.insert(Table_Class, classes.toMap());
    return classID;
  }

  ///Add subject method
  static Future<int?> addSubject(SubjectModel subject) async {
    var dbClient = await db;

    int? subjectNameID = await dbClient?.insert(Table_Subjects, subject.toMap());
    return subjectNameID;
  }


  ///Read All method
  ///GetAllStudent method
  static Future<List<StudentModel>> getAllStudents() async {
    var dbClient = await db;
    var data = await dbClient?.rawQuery('SELECT * FROM $Table_Student');
    if (data != null) {
      return List.generate(data.length, (index) {
        return StudentModel.fromMap(data[index]);
      });
    } else {
      return []; // Return an empty list if maps is null
    }
  }

  ///GetAllClasses method
  static Future<List<ClassModel>> getAllClasses() async {
    var dbClient = await db;
    var data = await dbClient?.rawQuery('SELECT * FROM $Table_Class');
    if (data != null) {
      return List.generate(data.length, (index) {
        return ClassModel.fromMap(data[index]);
      });
    } else {
      return []; // Return an empty list if maps is null
    }
  }

  ///GetAllSubjects method
  static Future<List<SubjectModel>> getAllSubjects() async {
    var dbClient = await db;
    var data = await dbClient?.rawQuery('SELECT * FROM $Table_Subjects');
    if (data != null) {
      return List.generate(data.length, (index) {
        return SubjectModel.fromMap(data[index]);
      });
    } else {
      return []; // Return an empty list if maps is null
    }
  }




  ///Read specific method
  ///GetStudent method
  static Future<StudentModel?> getStudent(int studentId) async {
    var dbClient = await db;
    var data = await dbClient?.rawQuery("SELECT * FROM $Table_Student WHERE "
        "$studentId = '$studentId'");
    if (data?.isNotEmpty ?? false) {
      return StudentModel.fromMap(data!.first);
    }

    return null;
  }

  ///GetSClass method
  static Future<ClassModel?> getClass(int classId) async {
    var dbClient = await db;
    var data = await dbClient?.rawQuery("SELECT * FROM $Table_Class WHERE "
        "$classId = '$classId'");
    if (data?.isNotEmpty ?? false) {
      return ClassModel.fromMap(data!.first);
    }
    return null;
  }

  ///GetSubject method
  static Future<SubjectModel?> getSubject(int subjectId) async {
    var dbClient = await db;
    var data = await dbClient?.rawQuery("SELECT * FROM $Table_Subjects WHERE "
        "$subjectId = '$subjectId'");
    if (data?.isNotEmpty ?? false) {
      return SubjectModel.fromMap(data!.first);
    }
    return null;
  }


  ///Update method
  /// Update Student by id
  static Future<void> updateStudent(StudentModel student) async {
    var dbClient = await db;
    var data = await dbClient?.update(Table_Student, student.toMap(),
        where: 'studentId = ?', whereArgs: [student.studentId]);
    print(data);
  }

  /// Update Class by id
  static Future<void> updateClass(ClassModel classes) async {
    var dbClient = await db;

    var data = await dbClient?.update(Table_Student, classes.toMap(),
        where: 'classId = ?', whereArgs: [classes.classId]);
    print(data);
  }

  /// Update Subject by id
  static Future<void> updateSubject(SubjectModel subject) async {
    var dbClient = await db;

    var data = await dbClient?.update(Table_Student, subject.toMap(),
        where: 'subjectId = ?', whereArgs: [subject.subjectId]);
    print(data);
  }





  /// Delete method
  ///Delete student
  static Future<void> deleteStudent(int studentId) async {
    var dbClient = await db;
    try {
      await dbClient?.delete(Table_Student, where: 'studentId = ?', whereArgs: [studentId]);
    } catch (error) {
      debugPrint("Có lỗi: $error");
    }
  }

  ///Delete class
  static Future<void> deleteClass(int classId) async {
    var dbClient = await db;
    try {
      await dbClient?.delete(Table_Class, where: 'classId = ?', whereArgs: [classId]);
    } catch (error) {
      debugPrint("Có lỗi: $error");
    }
  }

  ///Delete subject
  static Future<void> deleteSubject(int subjectId) async {
    var dbClient = await db;
    try {
      await dbClient?.delete(Table_Subjects, where: 'subjectId = ?', whereArgs: [subjectId]);
    } catch (error) {
      debugPrint("Có lỗi: $error");
    }
  }

}