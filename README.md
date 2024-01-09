# HomeScreen
- Tại đây sẽ có 3 nút push vào 3 màn hình: Class list, Student list, Subject list

# class_list_screen
B1:
- Phân tích dữ liệu: Dữ liệu được lấy từ local sqlite (class list table).
    + Hiển thị: Nếu có dữ liệu thì hiện ra màn hình một listview 
    + child card có child listitle hiển thị thông tin của lớp học
    + Gồm 2 column (properties): classId (mặc định),  className và classAverageScore).
    + Nếu không có dữ liệu thì hiển thị hiện chưa có lớp học.
      
B2:
- Khởi tạo dữ liệu:
  + Các biến chứa dữ liệu của đối tượng:
  // All classes: List<ClassModel>? _classes; 
  // TextFormField: Dùng để nhâp dữ liệu đối tượng vào.

+ Các phương thức để hiển thị ra màn hình những dối tượng khai báo (tên lớp học và điểm trung bình lớp học). 
  + // SQL Database: DatabaseHelper dbHelper; (SQL hỗ trợ các phương thức để lấy data từ local)
  
    + StatusState(hiển thị các bước in ra màn hình gồm: init, loading, success, fail)
    //init: (ở B1) lấy dữ liệu từ local 
    //loading (chờ init data)
    //success (khi init thành công - hiển thị ra màn hình)
    //fail (Khi init không thành công - error)
    
  + Hiển thị ra màn hình (setState những phương thức để cập nhật lên màn hình)

B3: Xác định được những sự kiện cần sử lí (nút thêm, sửa, xóa lớp)

- nút thêm (add class)
  + Sử dụng widget floating action button
  + Khi nhấn vào sẽ hiển thị ra một form cho người dùng điền vào (widget ModalBottomSheet)
  + Form hiển thị sẽ gồm 2 TestFormField nhập vào className và classAverageScore
  + OnPress: (validate khi người dùng nhập k đúng yêu cầu của TestFormField về className và classAverageScore).
  + Sử dụng phương thức được thư viện sqlite data local cung cấp để lưu trữ thông tin sau khi đã nhập
  và đã validate
  
- nút sửa (update class)
  + Sử dụng widget IconButon(Icons.edit)
  + Widget nằm ngay tại widget Card thông tin lớp để biết lớp nào sừa (classId)
  + Khi nhấn vào sẽ hiển thị ra một form cho người dùng điền vào (widget ModalBottomSheet)
  + Form hiển thị sẽ gồm 2 TestFormField nhập thông tin className và classAverageScore cần sửa
  + OnPress: (validate khi người dùng nhập k đúng yêu cầu của TestFormField về className và classAverageScore).
  + Sử dụng phương thức được thư viện sqlite data local cung cấp để cập nhật thông tin sau khi đã nhập

- nút xóa (delete class)
  + Sử dụng widget IconButon(Icons.delete)
  + Widget nằm ngay tại widget Card thông tin lớp để biết lớp nào cần xóa (classId)
  + Sau khi nhấn sẽ hiển thị một AlertDialog để hỏi người dùng thật sự muốn xóa (tránh xóa nhầm)
  + OnPress: Khi nhấn vào sẽ gọi pt xóa được cung cấp bởi database local sqlite;
  + Card thông tin lớp học đã được xóa
  
B4: clear bộ nhớ (dispose).
