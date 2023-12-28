import 'package:flutter/material.dart';
import 'package:studentlist/DatabaseHelper.dart';
import 'package:studentlist/StudentModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      _genderController.text = existingStudent['studentGender'];
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Tên'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(hintText: 'Tuổi'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _genderController,
                decoration: const InputDecoration(hintText: 'Giới tính'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _averageScoreController,
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
                  _genderController.text = '';
                  _averageScoreController.text = '';
                  // Close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Thêm học sinh' : 'Cập nhật'),
              )
            ],
          ),
        ));
  }

// Insert a new journal to the database
  Future<void> _addStudent() async {
    await DatabaseHelper.addStudent(
        _nameController.text, _ageController.text,_genderController.text,_averageScoreController.text);
    _refreshStudents();
  }

  // Update an existing journal
  Future<void> _updateStudent(int id) async {
    await DatabaseHelper.updateStudent(id,
        _nameController.text, _ageController.text,_genderController.text,_averageScoreController.text);
    _refreshStudents();
  }

  // Delete an item
  void _deleteStudent(int id) async {
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
            isThreeLine: true,
              title: Text(_students[index]['studentName']),
              subtitle: Text(_students[index]['studentAge'],),
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
