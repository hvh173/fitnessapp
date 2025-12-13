import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/screens/login_screen.dart'; 


Widget createTestableWidget(Widget child) {
  // Vì chúng ta đang test giao diện, cần cung cấp Provider và MaterialApp
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

      // Kiểm tra số lượng ô nhập liệu (Username và Password)
      expect(find.byType(TextField), findsNWidgets(2));
      
      // Kiểm tra nút Đăng nhập
      expect(find.byType(ElevatedButton), findsOneWidget); 
      
      // Kiểm tra Text "ĐĂNG NHẬP"
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
    testWidgets('3. Tapping Login button does not crash the application', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));
      
      final loginButton = find.widgetWithText(ElevatedButton, 'ĐĂNG NHẬP');
      
      await tester.tap(loginButton);
      

      await tester.pumpAndSettle(); 
      
      // Kiểm tra không có ngoại lệ (crash) xảy ra
      expect(tester.takeException(), isNull);
    });
  });
}
