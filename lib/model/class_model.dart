class ClassModel {
  final int classId;
  late String className;
  final String classAverageScore;
  final String createAt;

  ClassModel({
    required this.classId,
    required this.className,
    required this.classAverageScore,
    required this.createAt,
  });


  ///Tạo param mặc định
  factory ClassModel.parameter({ required String className,
    required String classAverageScore,
    required String createAt,}) => ClassModel(
    classId: 0,
    className: className,
    classAverageScore: classAverageScore,
    createAt: createAt,
  );

  factory ClassModel.fromMap(Map<String, dynamic> json) => ClassModel(
    classId: json["classId"],
    className: json["className"],
    classAverageScore: json["classAverageScore"],
    createAt: json["createAt"],
  );

  Map<String, dynamic> toMap() => {
    "classId": classId,
    "className": className,
    "classAverageScore": classAverageScore,
    "createAt": createAt,
  };
}