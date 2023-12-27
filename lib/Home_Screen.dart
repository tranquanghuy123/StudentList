import 'package:flutter/material.dart';
import 'package:studentlist/Add_Student_Screen.dart';
import 'package:studentlist/DatabaseHelper.dart';
import 'package:studentlist/StudentModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper database;
  late Future<List<StudentModel>> students;

  @override
  void initState() {
    database = DatabaseHelper();
    students = database.getStudent();

    database.initDB().whenComplete((){});
    students = getAllStudent();
    super.initState();
  }

  Future<List<StudentModel>> getAllStudent(){
    return database.getStudent();
  }


  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Danh sách học sinh'),
          ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AddStudentScreen() ));},
              child: Icon(Icons.add),
            ),


            body: FutureBuilder<List<StudentModel>>(
              future: students,
              builder:(BuildContext context, AsyncSnapshot<List<StudentModel>> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }
                else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Text('Không có dữ liệu');
                }
                else if (snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                else {
                  final items = snapshot.data ?? <StudentModel>[];
                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index){
                    return ListTile(
                      title: Text(items[index].studentName),
                    );
                  });
                }
            },
            )
        ));
  }
}
