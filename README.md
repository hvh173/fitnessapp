
# Bài tập lớn - Phát triển ứng dụng với Flutter
# Đề tài: App Tập luyện tại nhà

- **Họ và tên**: Hoàng Việt Hà


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



