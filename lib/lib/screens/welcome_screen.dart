import 'package:flutter/material.dart';
import 'package:fitness/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // LỚP PHỦ GRADIENT 
        
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,      
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.9), 
                ],
                stops: const [0.4, 0.7, 1.0], 
              ),
            ),
          ),

          // 3. NỘI DUNG CHÍNH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TEXT TIÊU ĐỀ
                const Text(
                  "WORKOUT\nFROM HOME",
                  style: TextStyle(
                    fontSize: 48, 
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1, 
                    letterSpacing: 1.0,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(2, 2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                
      
                Text(
                  "Xây dựng cơ bắp & giữ dáng\nvới lộ trình chuẩn khoa học.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.85), 
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 50),

                // NÚT BẤM 
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF4081).withOpacity(0.5), 
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4081),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0, 
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "BẮT ĐẦU NGAY",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}