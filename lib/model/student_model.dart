class StudentModel {
  final int studentId;
  final String studentName;
  final String studentLastName;
  final String studentAge;
  final String studentGender;
  final String averageScore;
  final String createAt;

  StudentModel({
    required this.studentId,
    required this.studentName,
    required this.studentLastName,
    required this.studentAge,
    required this.studentGender,
    required this.averageScore,
    required this.createAt,
  });

  ///Tạo param mặc định
  factory StudentModel.parameter({ required String studentName,
    required String studentLastName,
    required String studentAge, required String studentGender,
    required String averageScore,
    required String createAt,}) => StudentModel(
    studentId: 0,
    studentName: studentName,
    studentLastName: studentLastName,
    studentAge: studentAge,
    studentGender: studentGender,
    averageScore: averageScore,
    createAt: createAt,
  );

  factory StudentModel.fromMap(Map<String, dynamic> json) => StudentModel(
    studentId: json["studentId"],
    studentName: json["studentName"],
    studentLastName: json["studentLastName"],
    studentAge: json["studentAge"],
    studentGender: json["studentGender"],
    averageScore: json["averageScore"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toMap() => {
    "studentId": studentId,
    "studentName": studentName,
    "studentLastName": studentLastName,
    "studentAge": studentAge,
    "studentGender": studentGender,
    "averageScore": averageScore,
    "createAt": createAt,
  };
}