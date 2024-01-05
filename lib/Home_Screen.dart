import 'package:flutter/material.dart';
import 'package:studentlist/DatabaseHelper.dart';
import 'status_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///global key
  final _formKey = GlobalKey<FormState>();

  ///DatabaseHelper
  final DatabaseHelper dbHelper = DatabaseHelper();

  // All students
  List<Map<String, dynamic>> _students = [];

  ///status state
  StatusState statusState = StatusState.init;

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _initDb() async {
    setState(() {
      statusState = StatusState.loading;
    });
    final data = await DatabaseHelper.getAllStudents();
    print(data);
    if(data.isEmpty){
      setState(() {
        _students = [];
        statusState = StatusState.fail;
      });
    }
    else{
      setState(() {
        _students = data;
        statusState = StatusState.success;
      });
    }
  }

  // void initDb() async{
  //   var db = await DatabaseHelper.getAllStudents();
  //   _students = db;
  // }


  @override
  void initState() {
    _initDb();
    super.initState();
    _initDb(); // Loading the diary when the app starts
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _averageScoreController = TextEditingController();



  String selectedGender = 'Nam';
  List<String> gender = <String>['Nam', 'Nữ', 'Khác'];



  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    selectedGender = gender[0];
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingStudent =
      _students.firstWhere((element) => element['studentId'] == id);
      _nameController.text = existingStudent['studentName'];
      _lastNameController.text = existingStudent['studentLastName'];
      _ageController.text = existingStudent['studentAge'];
      selectedGender = existingStudent['studentGender'];
      _averageScoreController.text = existingStudent['studentAverageScore'];

    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: double.infinity,
      ),
        builder: (BuildContext context)
          => GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
            child: Container(
              padding: const EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: 15,
              ),
              color: Colors.white,
              height: 700,
              child: Column(
                children: [
                  Text('Nhập thông tin học sinh', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                  SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập tên';
                            } else if (value.length < 2) {
                              return 'Họ và tên phải có ít nhất 2 kí tự';
                            }
                          },
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(hintText: 'Tên'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập Họ';
                            } else if (value.length < 2) {
                              return 'Họ và tên phải có ít nhất 2 kí tự';
                            }
                          },
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(hintText: 'Họ'),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: _ageController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập tuổi';
                            } else if (int.parse(value) < 6 ||
                                int.parse(value) > 24) {
                              return 'Số tuổi không đúng với học sinh (6 - 24). Xin vui lòng nhập lại';
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Tuổi'),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        DropdownButton<String>(
                          value: selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                          items: gender
                              .map<DropdownMenuItem<String>>((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: _averageScoreController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập điểm trung bình';
                            } else if (int.parse(value) < 1 ||
                                int.parse(value) > 10) {
                              return 'Điểm trung bình không hợp lệ (0 - 10). Xin vui lòng nhập lại';
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Điểm trung bình'),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Add student
                              if (id == null) {
                                await _addStudent();
                              }
                              if (id != null) {
                                await _updateStudent(id);
                              }
                            }
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, perform some action
                              _formKey.currentState!.save();
                              // Clear the text fields
                              _nameController.text = '';
                              _lastNameController.text = '';
                              _ageController.text = '';
                              selectedGender = '';
                              _averageScoreController.text = '';
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(id == null ? 'Thêm học sinh' : 'Cập nhật'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }

// Insert a new journal to the database
  Future<void> _addStudent() async {

    await DatabaseHelper.addStudent(
        _nameController.text,_lastNameController.text, _ageController.text,selectedGender,_averageScoreController.text);
    _initDb();
  }

  // Update an existing journal
  Future<void> _updateStudent(int id) async {
    await DatabaseHelper.updateStudent(id,
        _nameController.text,_lastNameController.text, _ageController.text,selectedGender,_averageScoreController.text);
    _initDb();
  }

  // Delete an item
  void _deleteStudent(int? id) async {
    await DatabaseHelper.deleteStudent(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Xóa học sinh thành công!'),
      backgroundColor: Colors.green,
    ));
    _initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách học sinh'),
      ),
      body: bodyBuilder(),


      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }


  Widget bodyBuilder() {
    switch(statusState){
      case StatusState.init:
        return Container();
      case StatusState.loading:
        return CircularProgressIndicator();
      case StatusState.success:
        return ListView.builder(
          itemCount: _students.length,
          itemBuilder: (context, index) => Card(
            color: Colors.orange[200],
            margin: const EdgeInsets.all(15),
            child: ListTile(
                leading: Icon(Icons.account_circle_rounded),
                title: Text('${_students[index]['studentLastName']} ${_students[index]['studentName']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tuổi: ${_students[index]['studentAge']}'
                    ),
                    Text(
                        'Giới tính: ${_students[index]['studentGender']}'
                    ),
                    Text(
                        'Điểm trung bình: ${_students[index]['studentAverageScore']}'
                    ),
                  ],
                ),

                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showForm(_students[index]['studentId']);
                          }
                      ),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: const Text('Xóa học sinh'),
                                    content: const Text('Bạn có muốn xóa học sinh này không?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          print('id là: ${_students[index]['studentId']}');
                                          _deleteStudent(_students[index]['studentId']);
                                          Navigator.pop(context, 'Xác nhận');
                                        },
                                        child: const Text('Xác nhận'),
                                      ),

                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'Hủy bỏ'),
                                        child: const Text('Hủy bỏ'),
                                      ),
                                    ],
                                  );
                                }
                            );
                          }

                      ),
                    ],
                  ),
                )),
          ),
        );
      case StatusState.fail:
        return Text('Không có dữ liệu');
    }
  }
}
