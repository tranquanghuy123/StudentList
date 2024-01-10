import 'package:flutter/material.dart';
import 'package:studentlist/data/DatabaseHelper.dart';
import 'package:studentlist/model/class_model.dart';
import 'package:studentlist/model/student_model.dart';
import 'package:studentlist/status_state.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({super.key});

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  ///global key
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _classAverageScoreController =
      TextEditingController();

  ///DatabaseHelper
  late DatabaseHelper dbHelper;

  // All classes
  List<ClassModel>? _classes;

  ///status state
  StatusState statusState = StatusState.init;

  void _initDb() async {
    setState(() {
      statusState = StatusState.loading;
    });
    final data = await DatabaseHelper.getAllClasses();
    print(data);
    if (data.isEmpty) {
      setState(() {
        _classes = null;
        statusState = StatusState.fail;
      });
    } else {
      setState(() {
        _classes = data;
        statusState = StatusState.success;
      });
    }
  }

  @override
  void initState() {
    _initDb();
    super.initState();
  }

  // Insert class
  void _addClass() async{
    await showModalBottomSheet(
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
                'Nhập lớp học',
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
                      controller: _classNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên lớp';
                        } else if (value.length < 2) {
                          return 'Tên lớp không hợp lệ. Tên lớp từ 1(A-D) - 12(A-D)';
                        }
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(hintText: 'Tên lớp'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _classAverageScoreController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập điểm trung bình lớp';
                        } else if (int.parse(value) < 1 ||
                            int.parse(value) > 10) {
                          return 'Điểm trung bình không hợp lệ (0 - 10). Xin vui lòng nhập lại';
                        }
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          hintText: 'Điểm trung bình lớp'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                          String createAt = DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
                          var newClass = ClassModel.parameter(
                            className: _classNameController.text,
                            classAverageScore: _classAverageScoreController.text,
                            createAt: createAt,
                          );
                             await DatabaseHelper.addClass(newClass);
                              // Clear the text fields
                              _classNameController.text = '';
                              _classAverageScoreController.text = '';
                              Navigator.of(context).pop();
                          await Future.delayed(const Duration(seconds: 1));

                          // setState(() {
                          //   _classes = classes;
                          // });

                        }

                      },
                      child: Text('Thêm lớp học'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    List<ClassModel>? classes = await DatabaseHelper.getAllClasses();
    setState(() {
      _classes = classes;
    });
    
  }

  // Update class
  Future<void> _updateClass(int id) async {
    String createAt =
        DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    final classes = ClassModel.parameter(
        className: _classNameController.text,
        classAverageScore: _classAverageScoreController.text,
        createAt: createAt);
    try {
      await DatabaseHelper.updateClass(classes);
      Navigator.of(context).pop();
    } catch (e) {
      // Handle the error, e.g., show an error message
    }
    _initDb();
  }

  // Delete class
  void _deleteClass(int id) async {
    await DatabaseHelper.deleteClass(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Xóa lớp học thành công!'),
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
            'Danh sách lớp học',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _addClass(),
        ),
        body: buildList());
  }

  Widget buildList() {
    switch (statusState) {
      case StatusState.init:
        return Container();
      case StatusState.loading:
        return const CircularProgressIndicator();
      case StatusState.success:
        return ListView.builder(
          itemCount: _classes?.length,
          itemBuilder: (context, index) => Card(
            color: Colors.blue[200],
            margin: const EdgeInsets.all(15),
            child: ListTile(
                leading: const Icon(Icons.class_),
                title: Text('${_classes?[index].className}'),
                subtitle: Text(
                    'Điểm trung bình: ${_classes?[index].classAverageScore}'),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                          }),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Xóa lớp học'),
                                    content: const Text(
                                        'Bạn có muốn xóa lớp học này không?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          print(
                                              'id là: ${_classes![index].classId}');
                                          _deleteClass(
                                              _classes![index].classId);
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
