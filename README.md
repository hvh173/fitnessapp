
# Bài tập lớn - Phát triển ứng dụng với Flutter
# Đề tài: App Tập luyện tại nhà
## Thông tin sinh viên
- **Họ và tên**: Hoàng Việt Hà
- **MSSV**: 2221050726
- **Lớp**: DCCTCLC67B

## Giới thiệu

Đây là ứng dụng theo dõi sức khỏe và tập luyện  được xây dựng bằng **Flutter**. Ứng dụng giúp người dùng quản lý thông tin cá nhân, tính toán chỉ số TDEE (Total Daily Energy Expenditure) và theo dõi các phiên tập luyện hàng ngày.

Dự án áp dụng quy trình **CI/CD với GitHub Actions** để tự động hóa việc kiểm thử và đảm bảo chất lượng mã nguồn.
## Tính năng chính (CRUD & UI)

1.  **Quản lý người dùng (User Management):**
    * Đăng nhập, Đăng ký
    * Cập nhật thông tin cá nhân: Cân nặng, chiều cao, tuổi, giới tính...
    * **Tính toán TDEE:** Tự động tính toán lượng calo tiêu thụ dựa trên mức độ vận động cũng như mục tiêu

2.  **Quản lý tập luyện (Workout Management):**
    * Xem danh sách bài tập.
    * Theo dõi phiên tập (Workout Session Screen)
    * Lên lịch tập luyện (Schedule)

3.  **Lưu trữ dữ liệu:**
    * Sử dụng lưu trữ cục bộ (Local Storage/NoSQL) để lưu trạng thái người dùng và lịch sử tập luyện, đảm bảo ứng dụng hoạt động offline.

## Công nghệ và Thư viện sử dụng

* **Framework:** Flutter & Dart
* **State Management:** `provider` (Quản lý trạng thái tập trung)
* **Database:** `localstore` 
* **Testing:** `flutter_test` (Main Test & Widget Test).
* **CI/CD:** GitHub Actions.






## Báo cáo kết quả

Hướng dẫn sử dụng ứng dụng: 
1. Tải mã nguồn từ repository.
    ```bash
    git clone https://github.com/HUMG-IT/flutter-final-project-hvh173

    ```

2. Cài đặt các dependencies:
cd flutter-final-project-hvh173
    ```bash
   flutter pub get
   ```
3. Thực hiện kiểm thử tự động và xem kết quả:
    ```bash
    flutter test
    ```    
4. Chạy ứng dụng:
   ```bash
   flutter run
   ```
5. Kiểm tra ứng dụng trên thiết bị hoặc máy ảo.
6. Tạo tài khoản mới để vào giao diện chính
7. Thực hiện tạo lịch tập và CRUD để test
8. Screenshots hoặc video demo về ứng dụng và quá trình kiểm thử tự động.


**Tóm tắt các mức điểm:**
- **5/10** | **Build thành công (GitHub Actions "Success")** |  **ĐẠT.** <br> - Workflow GitHub Actions đã được cấu hình và chạy thành công (màu xanh). <br> - Không có lỗi biên dịch |
- **6/10** | **Thành công với kiểm thử cơ bản (CRUD tối thiểu)** |  **ĐẠT.** <br> - Đã thực hiện trọn vẹn CRUD cho đối tượng `User Info` (Tạo hồ sơ, Xem chỉ số, Cập nhật cân nặng/chiều cao) |
- **7/10** | **Kiểm thử CRUD & Quản lý trạng thái (State Management)** |  **ĐẠT.** <br> - Sử dụng **`Provider`** để quản lý trạng thái. <br> - Khi cập nhật thông tin (Cân nặng, Mục tiêu), chỉ số TDEE và giao diện thay đổi tức thì mà không cần load lại app. <br> - Có thông báo phản hồi người dùng. |
- **8/10** | **Tích hợp API/CSDL & Xử lý lỗi** | **ĐẠT.** <br> - Tích hợp **`Localstore` (NoSQL)** để lưu trữ dữ liệu dùng offline. <br> - Xử lý các tác vụ bất đồng bộ (`Future`, `async/await`) đảm bảo UI không bị treo khi ghi/đọc dữ liệu. |
- **9/10** | **Kiểm thử tự động toàn diện & Giao diện hoàn thiện** |  **ĐẠT.** <br> - **Unit Test:** Đã kiểm thử logic nghiệp vụ tính toán TDEE phức tạp. <br> - **Widget Test:** Đã kiểm thử giao diện đăng nhập và các tương tác người dùng. <br> - **Giao diện:** Hoàn thiện, hỗ trợ chế độ tối (Dark theme), bố cục rõ ràng. <br> - **Chức năng nâng cao:** Tính toán tự động các chỉ số sức khỏe dựa trên input người dùng. |
- **10/10** | **UI/UX mượt mà, Tối ưu hóa, Tính năng nâng cao** |  **Cần cải thiện.** <br> - Dự án đã tối ưu hóa luồng dữ liệu nhưng chưa tích hợp các tính năng tìm kiếm, lọc phức tạp. CI/CD đã ổn định nhưng test case có thể mở rộng thêm độ bao phủ|


## Tự đánh giá điểm: 9/10

