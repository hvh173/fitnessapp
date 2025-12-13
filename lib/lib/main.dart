import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FitnessProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: const Color(0xFFFF4081),
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}