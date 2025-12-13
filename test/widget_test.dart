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
  group('UI/Widget Test - Login Screen', () {
    testWidgets('1. Login screen must have 2 input fields and 2 buttons', (WidgetTester tester) async {
      // Khởi chạy màn hình Login
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));


      expect(find.byType(TextField), findsNWidgets(2));
      
      // Kiểm tra nút Đăng nhập và nút Đăng ký
      expect(find.byType(ElevatedButton), findsOneWidget); // Nút Đăng nhập
      expect(find.text('Đăng ký'), findsOneWidget); // Nút Đăng ký (thường là TextButton)
    });

    testWidgets('2. Entering text in fields must work', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));
      final usernameField = find.byType(TextField).first;
      await tester.enterText(usernameField, 'test_user_for_ui');

      expect(find.text('test_user_for_ui'), findsOneWidget);
    });

    testWidgets('3. Tapping Login button must trigger logic', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const LoginScreen()));

      final loginButton = find.widgetWithText(ElevatedButton, 'ĐĂNG NHẬP');

      await tester.tap(loginButton);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
