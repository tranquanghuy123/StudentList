class SubjectModel {
  final int subjectId;
  late String subjectName;
  final String createAt;

  SubjectModel({
    required this.subjectId,
    required this.subjectName,
    required this.createAt,
  });

  ///Tạo param mặc định
  factory SubjectModel.parameter({ required String subjectName,
    required String createAt,}) => SubjectModel(
    subjectId: 0,
    subjectName: subjectName,
    createAt: createAt,
  );

  factory SubjectModel.fromMap(Map<String, dynamic> json) => SubjectModel(
    subjectId: json["subjectId"],
    subjectName: json["subjectName"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toMap() => {
    "subjectId": subjectId,
    "subjectName": subjectName,
    "createAt": createAt,
  };
}