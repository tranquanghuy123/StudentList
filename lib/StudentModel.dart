

class Student {
  String? id;
  String? ten;
  String? tuoi;
  String? diemTrungBinh;
  String? gioiTinh;

  Student({ this.id, this.ten,
    this.tuoi, this.diemTrungBinh, this.gioiTinh});


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'ten': ten,
      'tuoi': tuoi,
      'diemTrungBinh': diemTrungBinh,
      'gioiTinh': gioiTinh
    };
    return map;
  }

  Student.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    ten = map['ten'];
    tuoi = map['tuoi'];
    diemTrungBinh = map['diemTrungBinh'];
    gioiTinh = map['gioiTinh'];
  }

}