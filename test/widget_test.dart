import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/screens/login_screen.dart'; 

Widget createTestableWidget(Widget child) {
  return ChangeNotifierProvider<FitnessProvider>(
    create: (_) => FitnessProvider(),
    child: MaterialApp(
      home: child, 
    ),
  );
}

void main() {
  group('UI/Widget Test - Login Screen Functionality', () {

    testWidgets('1. Login screen loads and displays essential elements', (WidgetTester tester) async {
      // 1. Khởi chạy màn hình Login
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));

      // 2. Kiểm tra các Widget cơ bản
      // Phải có 2 ô nhập liệu (Username và Password)
      expect(find.byType(TextField), findsNWidgets(2));
      
      // Phải có 1 nút Đăng nhập
      expect(find.byType(ElevatedButton), findsOneWidget); 
      
      // Phải có Text "ĐĂNG NHẬP"
      expect(find.text('ĐĂNG NHẬP'), findsOneWidget);
    });

    testWidgets('2. Entering text in Username field works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));

      final usernameField = find.byType(TextField).first;

      await tester.enterText(usernameField, 'user_test_input');

      await tester.pump();
      expect(find.text('user_test_input'), findsOneWidget);
    });

    testWidgets('3. Tapping Login button does not crash the application', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));
      
      // Tìm nút Đăng nhập
      final loginButton = find.widgetWithText(ElevatedButton, 'ĐĂNG NHẬP');
      
      // Bấm nút
      await tester.tap(loginButton);
      
      // Vẽ lại frame
      await tester.pump();
      
      // Kiểm tra không có ngoại lệ (crash) xảy ra
      expect(tester.takeException(), isNull);
    });
  });
}
