import 'package:flutter/material.dart';
import 'package:studentlist/DatabaseHelper.dart';

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
  String selectedGender = 'Nam';


  // All students
  List<Map<String, dynamic>> _students = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshStudents() async {
    final data = await DatabaseHelper.getAllStudents();
    setState(() {
      _students = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshStudents(); // Loading the diary when the app starts
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _averageScoreController = TextEditingController();


  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingStudent =
      _students.firstWhere((element) => element['id'] == id);
      _nameController.text = existingStudent['studentName'];
      _ageController.text = existingStudent['studentAge'];
      selectedGender = existingStudent['studentGender'];
      _averageScoreController.text = existingStudent['studentAverageScore'];

    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
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
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập Họ và tên';
                    } else if (value.length < 2) {
                      return 'Họ và tên phải có ít nhất 2 kí tự';
                    } else if (!value.contains(' ') ||
                        value.contains(RegExp(r'[0-9]'))) {
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
                  controller: _ageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tuổi';
                    } else if (value.length < 1 &&
                        value.length > 100) {
                      return 'Số tuổi không hợp lệ. Xin vui lòng nhập lại';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Tuổi'),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  value: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                  items: <String>['Nam', 'Nữ', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _averageScoreController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập điểm trung bình';
                    } else if (value.length < 1 &&
                        value.length > 10) {
                      return 'Điểm trung bình không hợp lệ. Xin vui lòng nhập lại';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Điểm trung bình'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Save new journal
                    if (id == null) {
                      await _addStudent();
                    }

                    if (id != null) {
                      await _updateStudent(id);
                    }

                    // Clear the text fields
                    _nameController.text = '';
                    _ageController.text = '';
                    selectedGender = '';
                    _averageScoreController.text = '';
                    // Close the bottom sheet
                    Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Thêm học sinh' : 'Cập nhật'),
                )
              ],
            ),
          ),
        ));
  }

// Insert a new journal to the database
  Future<void> _addStudent() async {
    await DatabaseHelper.addStudent(
        _nameController.text, _ageController.text,selectedGender,_averageScoreController.text);
    _refreshStudents();
  }

  // Update an existing journal
  Future<void> _updateStudent(int id) async {
    await DatabaseHelper.updateStudent(id,
        _nameController.text, _ageController.text,selectedGender,_averageScoreController.text);
    _refreshStudents();
  }

  // Delete an item
  void _deleteStudent(int? id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Xóa học sinh thành công!'),
    ));
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
                      onPressed: () => _showForm(_students[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteStudent(_students[index]['id']),
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
