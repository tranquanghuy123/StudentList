# HomeScreen
- Tại đây sẽ có 3 nút push vào 3 màn hình: Class list, Student list, Subject list

# class_list_screen
B1:
- Phân tích dữ liệu: Dữ liệu được lấy từ local sqlite (class list table). 
  + Gồm 2 column (properties): classId (mặc định),  className và classAverageScore).
  + Hiển thị: Nếu có dữ liệu thì hiện ra màn hình một listview 
  child card có child listitle hiển thị thông tin của lớp học (gồm tên lớp và điểm trung bình)
  + Nếu không có dữ liệu thì hiển thị hiện chưa có lớp học.
      
B2:
- Khởi tạo dữ liệu:
  + Các biến chứa dữ liệu của đối tượng:
  // All classes: List<ClassModel>? _classes; 
  // TextFormField: Dùng để nhâp dữ liệu đối tượng vào.
  // final TextEditingController _classNameController = TextEditingController();
  //final TextEditingController _classAverageScoreController = TextEditingController();
  // final DatabaseHelper dbHelper = DatabaseHelper();
  // StatusState statusState = StatusState.init();

+ Các phương thức để hiển thị ra màn hình những dối tượng khai báo (tên lớp học và điểm trung bình lớp học).
  
    + StatusState(hiển thị các bước in ra màn hình gồm: init, loading, success, fail)
    //init: (ở B1) lấy dữ liệu từ local 
    //loading (chờ init data)
    //success (khi init thành công - hiển thị ra màn hình)
    //fail (Khi init không thành công - error)
    
  + Hiển thị ra màn hình tên lớp và điểm trung bình lớp (setState những phương thức để cập nhật lên màn hình)

B3: Xác định được những sự kiện cần sử lí (nút thêm, sửa, xóa lớp)

- nút thêm (add class)
  + Sử dụng widget floating action button
  + Khi nhấn vào sẽ hiển thị ra một form cho người dùng điền vào (widget ModalBottomSheet)
  + Form hiển thị sẽ gồm 2 TestFormField nhập vào className và classAverageScore và button thêm
  
  + _showform() {
  ModalBottomSheet()
  ....
  //code
  }

    + Button thêm học sinh:
    Sử dụng phương thức được thư viện sqlite data local cung cấp để lưu trữ thông tin sau khi đã nhập
    Tạo pt để thêm học sinh
      Future<void> _addClass() async {
     // code
      } 
      OnPress: (validate khi người dùng nhập k đúng yêu cầu của TestFormField về className và classAverageScore).
      Khi nhập đúng sẽ lưu thông tin lớp học và hiển thị ra màn hình tên lớp và điểm trung bình lớp


  
- nút sửa (update class)
  + Sử dụng widget IconButon(Icons.edit)
  + Widget nằm ngay tại widget Card thông tin lớp để biết lớp nào sừa (classId)
  + Khi nhấn vào sẽ hiển thị ra một thông tin trước đã thêm (widget ModalBottomSheet)
  + _showform() {
    ModalBottomSheet()
    ....
    //code
    }

+ Button sửa học sinh:
  Sử dụng phương thức được thư viện sqlite cung cấp để cập nhật thông tin lớp học
  Tạo pt để cập nhật thông tin (truyền param vào để biết sửa cho lớp học nào)    
Future<void> _updateClass(int id) async {
    // code
    }

  + OnPress: (validate khi người dùng nhập k đúng yêu cầu của TestFormField về className và classAverageScore).
  + Nhập đúng dữ liệu sẽ lưu vào database local và hiển thị thông tin tên lớp và điểm trung bình đã
    cập nhật trên màn hình

- nút xóa (delete class)
 +Tương tự như nút sửa nhưng k xuất hiện form
  Future<void> _deleteClass(int id) async {
  // code
  }
- Khi xóa hiển thị AlertDialog để hỏi người dùng có muốn xóa hay không

  
B4: clear bộ nhớ (dispose).



# subject_list_screen
B1:
- Phân tích dữ liệu: Dữ liệu được lấy từ local sqlite (subject list table).
  + Gồm 1 column (properties): subjectName).
  + Hiển thị: Nếu có dữ liệu thì hiện ra màn hình một listview
    child card có child listitle hiển thị thông tin của môn học (tên môn học)
  + Nếu không có dữ liệu thì hiển thị không có môn học.

B2:
- Khởi tạo dữ liệu:
  + Các biến chứa dữ liệu của đối tượng:
    // All subject: List<SubjectModel>? _subjects;
    // final TextEditingController _subjectNameController = TextEditingController();
    // final DatabaseHelper dbHelper = DatabaseHelper();
    // StatusState statusState = StatusState.init();

+ Các phương thức để hiển thị ra màn hình những dối tượng khai báo (tên môn học).

  + StatusState(hiển thị các bước in ra màn hình gồm: init, loading, success, fail)
    //init: (ở B1) lấy dữ liệu từ local
    //loading (chờ init data)
    //success (khi init thành công - hiển thị ra màn hình)
    //fail (Khi init không thành công - error)

  + Hiển thị ra màn hình tên môn học (setState những phương thức để cập nhật lên màn hình)

B3: Xác định được những sự kiện cần sử lí (nút thêm, sửa, xóa môn học)

- nút thêm (add subject)
  + Sử dụng widget floating action button
  + Khi nhấn vào sẽ hiển thị ra một form cho người dùng điền vào (widget ModalBottomSheet)
  + Form hiển thị 1 TestFormField nhập vào subjectName và button thêm môn học

  + _showform() {
    ModalBottomSheet()
    ....
    //code
    }

    + Button thêm môn học:
      Sử dụng phương thức được thư viện sqlite data local cung cấp để lưu trữ thông tin môn học sau khi đã nhập
      Hàm để thêm môn học
      void _addSubject() async {
      // code
      }
      OnPress: (validate khi người dùng nhập k đúng yêu cầu của TestFormField về tên môn học).
      Khi nhập đúng sẽ lưu thông tin môn học và in ra màn hình mon học



- nút sửa (update subject)
  + Sử dụng widget IconButon(Icons.edit)
  + Widget nằm ngay tại widget Card thông tin môn học để biết môn học nào cần sửa
  + Khi nhấn vào sẽ hiển thị ra môn học trước đã thêm (widget ModalBottomSheet)
  + _showform() {
    ModalBottomSheet()
    ....
    //code
    }

+ Button sửa mon học:
  Sử dụng phương thức được thư viện sqlite cung cấp để cập nhật thông tin môn học
  Tạo pt để cập nhật thông tin (truyền param vào để biết sửa cho môn học nào)    
  _updateSubject(int id) async {
  // code
  }

  + OnPress: (validate khi người dùng nhập k đúng yêu cầu của TestFormField về subjectName).
  + Nhập đúng dữ liệu sẽ lưu vào database local và hiển thị thông tin tên môn học đã
    cập nhật trên màn hình

- nút xóa (delete class)
  +Tương tự như nút sửa nhưng k xuất hiện form
  Future<void> _deleteSubject(int id) async {
  // code
  }
- Khi xóa hiển thị AlertDialog để hỏi người dùng có muốn xóa hay không


B4: clear bộ nhớ (dispose).