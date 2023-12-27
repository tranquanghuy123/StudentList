
import 'package:flutter/material.dart';
import 'package:studentlist/Home_Screen.dart';
import 'StudentModel.dart';
import 'DatabaseHelper.dart';

class AddStudentScreen extends StatefulWidget {
  AddStudentScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _addStudentScreenState();
  }
}

class _addStudentScreenState extends State<AddStudentScreen> {
  ///Global key
  final _formkey = GlobalKey<FormState>();

  ///Controller
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _averageScoreController = TextEditingController();
  final _genderController = TextEditingController();


  late final DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _averageScoreController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: widthScreen,
          height: heightScreen,
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  ///Appbar
                  Container(
                    alignment: Alignment.centerLeft,
                    width: widthScreen,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        child: const Icon(Icons.arrow_back, color: Colors.white,size: 35,),
                    ),
                  ),

                  Container(
                    height: heightScreen - 118.182,
                    width: widthScreen,
                    padding: const EdgeInsets.fromLTRB(15, 17, 15, 0),
                    child: Column(
                      children: [

                        ///Ho va ten
                        SizedBox(
                          height: 70,
                          width: widthScreen,
                          child: TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập tên';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(fontSize: 18),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'Họ và tên',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blue),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                          ),
                        ),

                        ///Tuổi
                        SizedBox(
                          height: 70,
                          width: widthScreen,
                          child: TextFormField(
                            controller: _ageController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập tuổi';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(fontSize: 18),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'Tuổi',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blue),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                          ),
                        ),

                        ///Điểm trung bình
                        SizedBox(
                          height: 70,
                          width: widthScreen,
                          child: TextFormField(
                            controller: _averageScoreController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập điểm trung bình';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(fontSize: 18),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'Điểm trung bình',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blue),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                          ),
                        ),

                        ///Giới tính
                        SizedBox(
                          height: 70,
                          width: widthScreen,
                          child: TextFormField(
                            controller: _genderController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập giới tính';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(fontSize: 18),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'Giới tính',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blue),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextButton(
                            onPressed: () async {
                               dbHelper.createStudent(StudentModel(
                                   studentName: _nameController.text,
                                   studentAge: _ageController.text,
                                   studentGender: _genderController.text,
                                   averageScore: _averageScoreController.text,
                                   createAt: DateTime.now().toIso8601String())).whenComplete((){
                                     Navigator.of(context).pop(true);
                               });
                                print('Quang Huy');
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(166, 52),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                                )),
                            child: const Text(
                              'Thêm',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
                            )),

                        SizedBox(height: 20),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



}