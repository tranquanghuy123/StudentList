import 'package:flutter/material.dart';
import 'package:studentlist/Screen/subject_list_screen.dart';
import 'class_list_screen.dart';
import 'student_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách'),),
      body: Container(
          width: widthScreen,
          height: heightScreen,
          child: GestureDetector(
            onTap: (){
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Center(
              child: Container(
                height: 300,
                width: 300,
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///Xem danh sách học sinh
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const StudentListScreen()));
                        },
                        style: TextButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Danh sách học sinh',
                            style: TextStyle(color: Colors.white))),

                    ///Xem danh sách lớp học
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ClassListScreen()));
                        },
                        style: TextButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Danh sách lớp học',
                            style: TextStyle(color: Colors.white))),

                    ///Xem danh sách môn học
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SubjectListScreen()));
                        },
                        style: TextButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Danh sách môn học',
                            style: TextStyle(color: Colors.white))),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
