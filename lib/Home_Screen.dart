import 'package:flutter/material.dart';
import 'package:studentlist/Data_Global.dart';
import 'package:studentlist/DatabaseHelper.dart';
import 'package:studentlist/StudentModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///global key
  final _formKey = GlobalKey<FormState>();

  ///DatabaseHelper
  DatabaseHelper? databaseHelper;

  ///Student model
  StudentModel? studentModel;

  // All students
  List<StudentModel> _students = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshStudents() async {
    final data = await DatabaseHelper.getAllStudents();
    setState(() {
      _students = data;
      _isLoading = false;
    });
  }

  String name = '';
  String age = '';
  String averageScore = '';
  List<String> gender = <String>['Nam', 'Nữ', 'Khác'];
  String selectedGender = '';

  @override
  void initState() {
    super.initState();
    _refreshStudents(); // Loading the diary when the app starts
    initData();
  }

  void initData() async {
    String tempStudentID = '';
    if (DataGlobal.studentID != null) {
      tempStudentID = DataGlobal.studentID!;
    }

    ///Gia tri moi da gan vao bien temp
    //databaseHelper?.getStudentById(tempStudentID);
    studentModel = await databaseHelper?.getStudentById(tempStudentID);

    name = studentModel?.studentName ?? '';
    age = studentModel?.studentAge ?? '';
    averageScore = studentModel?.studentAverageScore ?? '';
    selectedGender = studentModel?.studentGender ?? '';
  }

  void _showForm(int? id) async {
    selectedGender = gender[0];

    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item

      // final existingStudent =
      //     _students.firstWhere((element) => element['id'] == id);
      // name = existingStudent['studentName'];
      // age = existingStudent['studentAge'];
      // selectedGender = existingStudent['studentGender'];
      // averageScore = existingStudent['studentAverageScore'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => Container(
                padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  // this will prevent the soft keyboard from covering the text fields
                  bottom: MediaQuery.of(context).viewInsets.bottom + 120,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          name = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập Họ và tên';
                          } else if (value.length < 2) {
                            return 'Họ và tên phải có ít nhất 2 kí tự';
                          } else if (value.contains(RegExp(r'[0-9]'))) {
                            return 'Họ tên không hợp lệ. Xin vui lòng nhập lại';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(hintText: 'Tên'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          age = value;
                        },
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tuổi';
                          } else if (int.parse(value) < 1 ||
                              int.parse(value) > 100) {
                            return 'Số tuổi không hợp lệ. Xin vui lòng nhập lại';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(hintText: 'Tuổi'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButton(
                        value: selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            selectedGender = value!;
                            print('value: $value');
                            print('value2: $selectedGender');
                          });
                        },
                        items: gender.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          averageScore = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập điểm trung bình';
                          } else if (int.parse(value) < 1 ||
                              int.parse(value) > 10) {
                            return 'Điểm trung bình không hợp lệ. Xin vui lòng nhập lại';
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(hintText: 'Điểm trung bình'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          //Save new journal
                          if (id == null) {
                            await _addStudent();
                          }

                          if (id != null) {
                            await _updateStudent(id);
                          }

                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, perform some action
                            _formKey.currentState!.save();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(id == null ? 'Thêm học sinh' : 'Cập nhật'),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

// Insert a new student to the database
  Future<void> _addStudent() async {
    String id =
        DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    final student = StudentModel(
      studentId: id,
      studentName: name,
      studentAge: age,
      studentGender: selectedGender,
    );
    try {
      await DatabaseHelper.addStudent(student);

      Navigator.of(context).pop();
    } catch (e) {
      // Handle the error, e.g., show an error message
    }
    _refreshStudents();
  }

  // Update an existing student
  Future<void> _updateStudent(int id) async {
    String studentName = name;
    String studentAge = age;
    String? studentGender = selectedGender;
    String studentId = DataGlobal.studentID ?? '';
    print('abc');
    print(studentName);
    _refreshStudents();
  }

  // Delete an item
  void _deleteStudent(String id) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Xóa học sinh thành công!'),
    ));
    await DatabaseHelper.deleteStudent(id);
    _refreshStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách học sinh'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    title: Text(_students[index]['studentName']),
                    subtitle: Column(
                      children: [
                        Text('Tuổi: ${_students[index]['studentAge']}'),
                        Text('Giới tính: ${_students[index]['studentGender']}'),
                        Text(
                            'Điểm trung bình: ${_students[index]['studentAverageScore']}'),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(_students[index]['studentId']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteStudent(_students[indexs]['id']),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
