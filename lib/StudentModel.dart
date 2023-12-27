
class StudentModel {
  final int? studentId;
  final String studentName;
  final String studentAge;
  final String studentGender;
  final String averageScore;
  final String createAt;

  StudentModel({
    this.studentId,
    required this.studentName,
    required this.studentAge,
    required this.studentGender,
    required this.averageScore,
    required this.createAt,
  });

  factory StudentModel.fromMap(Map<String, dynamic> json) => StudentModel(
    studentId: json["studentId"],
    studentName: json["studentName"],
    studentAge: json["studentAge"],
    studentGender: json["studentGender"],
    averageScore: json["averageScore"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toMap() => {
    "studentId": studentId,
    "studentName": studentName,
    "studentAge": studentAge,
    "studentGender": studentGender,
    "averageScore": averageScore,
    "createAt": createAt,
  };
}
