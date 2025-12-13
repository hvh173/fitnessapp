import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/screens/login_screen.dart'; 
// Đảm bảo file login_screen.dart của bạn nằm trong lib/screens/

// Hàm tiện ích để bọc Widget vào môi trường cần thiết (MaterialApp + Provider)
Widget createTestableWidget(Widget child) {
  // Cung cấp Provider và MaterialApp để test
  return ChangeNotifierProvider<FitnessProvider>(
    create: (_) => FitnessProvider(),
    child: MaterialApp(
      home: child, 
    ),
  );
}

void main() {
  group('UI/Widget Test - Login Screen Functionality', () {

    // --- TEST 1: Kiểm tra các phần tử thiết yếu ---
    testWidgets('1. Login screen loads and displays essential elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));

      // Phải có 2 ô nhập liệu
      expect(find.byType(TextField), findsNWidgets(2));
      
      // Phải có 1 nút Đăng nhập
      expect(find.byType(ElevatedButton), findsOneWidget); 
      
      // Phải có Text "ĐĂNG NHẬP" (Chú ý viết hoa)
      expect(find.text('ĐĂNG NHẬP'), findsOneWidget);
    });

    // --- TEST 2: Kiểm tra việc nhập liệu ---
    testWidgets('2. Entering text in Username field works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));
      
      final usernameField = find.byType(TextField).first;
      
      await tester.enterText(usernameField, 'test_input');
      
      await tester.pump();
      expect(find.text('test_input'), findsOneWidget);
    });

    // --- TEST 3: Kiểm tra hành động bấm nút Đăng nhập (FIX LỖI CUỐI CÙNG) ---
    testWidgets('3. Tapping Login button does not crash the application', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));
      
      final loginButton = find.widgetWithText(ElevatedButton, 'ĐĂNG NHẬP');
      
      await tester.tap(loginButton);
      
      // *** DÒNG FIX QUAN TRỌNG: ĐỢI BẤT ĐỒNG BỘ ***
      // Lệnh này đợi cho các hàm async như provider.login() hoàn thành và UI ổn định.
      await tester.pumpAndSettle(); 
      
      // Kiểm tra không có ngoại lệ (crash) xảy ra
      expect(tester.takeException(), isNull);
    });
  });
}
