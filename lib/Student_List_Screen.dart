import 'package:flutter/material.dart';
import 'package:studentlist/StudentModel.dart';
import 'DatabaseHelper.dart';
import 'package:path_provider/path_provider.dart';


class StudentListScreen extends StatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  DbHelper? dbHelper;
  List<Student>? hs;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    initData();
  }

  void initData() async {
    hs = await dbHelper?.getUserAccountFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: hs != null
          ? ListView.builder(
        itemCount: hs!.length,
        itemBuilder: (context, index) {
          final hocSinh = hs![index];

          return ListTile(
              leading: const Icon(Icons.person),
              title: Text(hocSinh.id ?? '', style: const TextStyle(
                  color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700
              ),),
              //subtitle: Text(user.phone_number ?? ''),
              isThreeLine: true,
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hocSinh.ten ?? ''),
                  Text(hocSinh.gioiTinh ?? ''),
                  Text(hocSinh.tuoi ?? ''),
                  Text(hocSinh.diemTrungBinh ?? ''),


                ],
              )
          );
        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}