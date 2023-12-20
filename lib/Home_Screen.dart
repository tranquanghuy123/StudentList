import 'package:flutter/material.dart';
import 'package:studentlist/Add_Student_Screen.dart';
import 'package:studentlist/Student_List_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
          body: Container(
            height: heightScreen,
            width: widthScreen,
            child: Center(
              child: Container(
                height: 200,
                width: 200,
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddStudentScreen()));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue
                        ),
                        child: Text('Thêm học sinh', style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18
                        ),)),

                    TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentListScreen()));
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue
                        ),
                        child: Text('Danh sách học sinh',style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18
                        ))),
                  ],
                ),
              ),
            ),

          ),
        ));
  }
}
