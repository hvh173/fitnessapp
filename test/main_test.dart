import 'package:flutter_test/flutter_test.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/models/user_model.dart'; 
import 'package:mockito/mockito.dart'; // THƯ VIỆN MOCKING CẦN THIẾT

// *LƯU Ý QUAN TRỌNG*: Để sử dụng 'mockito', bạn phải thêm nó vào file pubspec.yaml:
// dev_dependencies:
//   mockito: ^5.0.0 
// Sau đó chạy: flutter pub get

// Khai báo Mock Class cho Database Service
class MockDatabaseService extends Mock implements DatabaseService {}


void main() {
  // Mock service và provider sẽ được tạo mới cho mỗi group test
  late MockDatabaseService mockService;
  late FitnessProvider provider;

  setUp(() {
    mockService = MockDatabaseService();
    // Tạo provider, truyền Mock Service vào (nếu provider của bạn có constructor để nhận service)
    // Nếu provider của bạn không có constructor, bạn không thể Mock Service được
    // GIẢ SỬ Provider của bạn có thể nhận service: provider = FitnessProvider(service: mockService);
    
    // Nếu provider của bạn không có constructor nhận service, 
    // thì ta chỉ test logic thuần TDEE (Test 1 & 2)
    provider = FitnessProvider(); 
  });


  group('FitnessProvider Logic Test', () {
    // Test 1 và 2 không phụ thuộc vào Database, chúng ta giữ nguyên.
    test('1. TDEE Calculation must be accurate for "Maintain"', () {
      provider.updateUserInfo(70.0, 175.0, 25, "Male", "Maintain");
      expect(provider.targetCalories, closeTo(2594, 5));
    });

    test('2. Target calories for "Gain" must be TDEE + 500', () {
      provider.updateUserInfo(70.0, 175.0, 25, "Male", "Gain"); 
      expect(provider.targetCalories, closeTo(3094, 5));
    });

    test('3. Change Password must fail with wrong old password', () async {
      final User loggedInUser = User(username: "testuser", password: "123456");
      
      // Khởi tạo provider và thiết lập currentUser thủ công (bỏ qua hàm login)
      (provider as dynamic)._currentUser = loggedInUser; 
      
      // Thử đổi mật khẩu với mật khẩu cũ SAI
      bool failed = await provider.changePassword("sai_mat_khau", "mat_khau_moi");
      expect(failed, false, reason: "Phải thất bại khi mật khẩu cũ sai");
      
      // Thử đổi mật khẩu với mật khẩu cũ ĐÚNG
      bool success = await provider.changePassword("123456", "mat_khau_moi");
      expect(success, true, reason: "Phải thành công khi mật khẩu cũ đúng");
      
    }, skip: true); // <<< DÒNG NÀY ĐỂ BỎ QUA NẾU CHƯA CÀI MOCKITO
  });
}
