class StudentModel {
  String? studentId;
  String? studentName;
  String? studentAge;
  String? studentGender;
  String? studentAverageScore;
  String? createAt;

  StudentModel({
    this.studentId,
    this.studentName,
    this.studentAge,
    this.studentGender,
    this.studentAverageScore,
    this.createAt,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'studentId': studentId,
      'studentName': studentName,
      'studentAge': studentAge,
      'studentGender': studentGender,
      'studentAverageScore': studentAverageScore,
      'createAt': createAt,
    };
    return map;
  }

  StudentModel.fromMap(Map<String, dynamic> map) {
    studentId = map["studentId"];
    studentName = map["studentName"];
    studentAge = map["studentAge"];
    studentAverageScore = map["studentAverageScore"];
    studentGender = map["studentGender"];
    createAt = map["createAt"];
  }
}
