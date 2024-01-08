import 'package:flutter/material.dart';
import 'package:studentlist/data/DatabaseHelper.dart';
import 'package:studentlist/model/subject_model.dart';
import 'package:studentlist/status_state.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  ///global key
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _subjectNameController = TextEditingController();


  ///DatabaseHelper
  final DatabaseHelper dbHelper = DatabaseHelper();

  // All subject
  List<SubjectModel>? _subjects;

  ///status state
  StatusState statusState = StatusState.init;

  void _initDb() async {
    setState(() {
      statusState = StatusState.loading;
    });
    final data = await DatabaseHelper.getAllSubjects();
    print(data);
    if (data.isEmpty) {
      setState(() {
        _subjects = [];
        statusState = StatusState.fail;
      });
    } else {
      setState(() {
        _subjects = data;
        statusState = StatusState.success;
      });
    }
  }

  @override
  void initState() {
    _initDb();
    super.initState();
    _initDb(); // Loading the diary when the app starts
  }

  // Insert class
  Future<void> _addSubject(SubjectModel subject) async {
    String createAt = DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    var subject = SubjectModel.parameter(
        subjectName: _subjectNameController.text,
        createAt: createAt);
    try {
      await DatabaseHelper.addSubject(subject);
      Navigator.of(context).pop();
    } catch (e) {
      // Handle the error, e.g., show an error message
    }
    _initDb();
  }

  // Update an existing journal
  Future<void> _updateSubject(SubjectModel subject) async {
    String createAt = DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    var subject = SubjectModel.parameter(
        subjectName: _subjectNameController.text,
        createAt: createAt);
    try {
      await DatabaseHelper.updateSubject(subject);
      Navigator.of(context).pop();
    } catch (e) {
      // Handle the error, e.g., show an error message
    }
    _initDb();
  }

  // Delete an item
  void _deleteSubject(int id) async {
    await DatabaseHelper.deleteSubject(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Xóa môn học thành công!'),
      backgroundColor: Colors.green,
    ));
    _initDb();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Danh sách môn học',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30,),
          ),
          backgroundColor: Colors.blue,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _showForm,
        ),
        body: buildList()
    );
  }

  void _showForm(int id) async {
    // id == null -> create new item
    // id != null -> update an existing item
    String creatAt = DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    var existingSubject = SubjectModel(
        subjectId: id,
        subjectName: _subjectNameController.text,
        createAt: creatAt
    );
    if (id != null) {
      _updateSubject(existingSubject);
    }
    else{
      _addSubject(existingSubject);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: double.infinity,
      ),
      builder: (BuildContext context) => GestureDetector(
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
              const Text(
                'Nhập môn học',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      controller: _subjectNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên môn học';
                        } else if (value.length < 2) {
                          return 'Tên môn học không hợp lệ. Xin vui lòng nhập lại';
                        }
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(hintText: 'Tên môn học'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Add student
                          if (id == null) {
                            await _addSubject(existingSubject);
                          }
                          if (id != null) {
                            await _updateSubject(existingSubject);
                          }
                        }
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, perform some action
                          _formKey.currentState!.save();
                          // Clear the text fields
                          _subjectNameController.text = '';
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(id == null ? 'Thêm môn học' : 'Cập nhật'),
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

  Widget buildList() {
    switch (statusState) {
      case StatusState.init:
        return Container();
      case StatusState.loading:
        return CircularProgressIndicator();
      case StatusState.success:
        return ListView.builder(
          itemCount: _subjects?.length,
          itemBuilder: (context, index) => Card(
            color: Colors.blue[200],
            margin: const EdgeInsets.all(15),
            child: ListTile(
                leading: const Icon(Icons.library_books),
                title: Text(
                    '${_subjects?[index].subjectName}'),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showForm(_subjects![index].subjectId);
                          }),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Xóa môn học'),
                                    content: const Text(
                                        'Bạn có muốn xóa môn học này không?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          print(
                                              'id là: ${_subjects![index].subjectId}');
                                          _deleteSubject(
                                              _subjects![index].subjectId);
                                          Navigator.pop(context, 'Xác nhận');
                                        },
                                        child: const Text('Xác nhận'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Hủy bỏ'),
                                        child: const Text('Hủy bỏ'),
                                      ),
                                    ],
                                  );
                                });
                          }),
                    ],
                  ),
                )),
          ),
        );
      case StatusState.fail:
        return const Text('Không có dữ liệu');
    }
  }
}
