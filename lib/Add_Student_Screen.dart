
import 'package:flutter/material.dart';
import 'package:studentlist/Home_Screen.dart';
import 'package:studentlist/StudentModel.dart';

import 'DatabaseHelper.dart';

class AddStudentScreen extends StatefulWidget {
  AddStudentScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _registerScreenState();
  }
}

class _registerScreenState extends State<AddStudentScreen> {
  ///Global key
  final _formkey = GlobalKey<FormState>();

  ///Controller
  final _tenController = TextEditingController();
  final _tuoiController = TextEditingController();
  final _diemtrungbinhController = TextEditingController();
  final _gioitinhController = TextEditingController();

  /// show the password or not
  bool _isObscure = true;
  late DbHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  @override
  void dispose() {
    _tenController.dispose();
    _tuoiController.dispose();
    _diemtrungbinhController.dispose();
    _gioitinhController.dispose();
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
                            controller: _tenController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập Họ và tên';
                              } else if (value.length < 2) {
                                return 'Tên phải có ít nhất 2 kí tự';
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
                            controller: _tuoiController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập tuổi';
                              } else if (value.length < 15 &&
                                  value.length > 20) {
                                return 'Tuổi không hợp lệ';
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
                            controller: _diemtrungbinhController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập điểm trung bình của học sinh';
                              } else if (value.length < 0 && value.length > 10) {
                                return 'Điểm không hợp lệ. Vui lòng nhập lại';
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
                            controller: _gioitinhController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập giới tính';
                              } else if (value !=  'Nam' && value !=  'Nữ') {
                                return 'Giới tính không hợp lệ';
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
                              if (_formkey.currentState!.validate()) {
                                _signup();
                              }
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

  Future<void> _signup() async {
    String id = DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    final hs = Student(
      id: id,
      ten: _tenController.text,
      tuoi: _tuoiController.text,
      diemTrungBinh: _diemtrungbinhController.text,
      gioiTinh: _gioitinhController.text,);
    try {
      await DbHelper.saveData(hs);

      Navigator.pop(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      // Handle the error, e.g., show an error message
    }
  }

}