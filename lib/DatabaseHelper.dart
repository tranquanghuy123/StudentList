import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'StudentModel.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static Database? _db;

  ///Tên database
  static const String DB_Name = 'test.db';

  ///Tên bảng
  static const String Table_Student = 'user';
  static const int Version = 1;


  ///Tên của column (các thuộc tính trong bảng)
  static const String C_StudentID = 'id';
  static const String C_StudentName = 'ten';
  static const String C_StudentAge = 'tuoi';
  static const String C_AverageScore = 'diemTrungBinh';
  static const String C_Gender = 'gioiTinh';


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
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }

  static Future<void> _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $Table_Student ("
        " $C_StudentID TEXT, "
        " $C_StudentName TEXT, "
        " $C_StudentAge TEXT, "
        " $C_AverageScore TEXT,"
        " $C_Gender TEXT, "
        " PRIMARY KEY ($C_StudentID)"
        ")");
  }

  static Future<int?> saveData(Student hs) async {
    var dbClient = await db;
    int? id = await dbClient?.insert(Table_Student, hs.toMap());
    return id;
  }



  static Future<void> updateUser(Student hs) async {
    var dbClient = await db;
    var res = await dbClient?.update(Table_Student, hs.toMap(),
        where: '$C_StudentID = ?', whereArgs: [hs.id]);
    print(res);
    print(hs.id);
  }

  Future<int?> deleteUser(String id) async {
    var dbClient = await db;
    var res = await dbClient
        ?.delete(Table_Student, where: '$C_StudentID = ?', whereArgs: [id]);
    return res;
  }

  Future<Student?> getUserById(String userId) async {
    var dbClient = await db;
    var res = await dbClient?.rawQuery("SELECT * FROM $Table_Student WHERE "
        "$C_StudentID = '$userId'");

    if (res?.isNotEmpty ?? false) {
      return Student.fromMap(res!.first);
    }

    return null;
  }

  Future<List<Student>> getUserAccountFromDatabase() async {
    var dbClient = await db;
    final List<Map<String, dynamic>>? maps = await dbClient?.rawQuery(
        'SELECT * FROM $Table_Student ');
    if (maps != null) {
      return List.generate(maps.length, (i) {
        return Student(
          id: maps[i]['id'],
          ten: maps[i]['ten'],
          tuoi: maps[i]['tuoi'],
          diemTrungBinh: maps[i]['diemTrungBinh'],
          gioiTinh: maps[i]['gioiTinh'],
        );
      });
    } else {
      return []; // Return an empty list if maps is null
    }
  }

  }


