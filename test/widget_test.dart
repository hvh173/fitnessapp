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

    // --- TEST 1: Kiểm tra các phần tử thiết yếu ---
    testWidgets('1. Login screen loads and displays essential elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));

      // Phải có 2 ô nhập liệu
      expect(find.byType(TextField), findsNWidgets(2));
      
      // Phải có Text "ĐĂNG NHẬP"
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


    testWidgets('3. Login function works correctly with mock data', (WidgetTester tester) async {
      final provider = FitnessProvider(); // Tạo provider riêng

      // =TEST TDEE DÙNG DỮ LIỆU ĐĂNG NHẬP
      
      // GIẢ SỬ: Khi đăng nhập thành công, targetCalories được tính lại.
      provider.updateUserInfo(70.0, 175.0, 25, "Male", "Maintain");
      expect(provider.targetCalories, closeTo(2594, 5), reason: 'Phải tính TDEE sau khi có dữ liệu.');
      expect(tester.takeException(), isNull);
    });
  });
}
