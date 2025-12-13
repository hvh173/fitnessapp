import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/screens/home_screen.dart';
import 'package:fitness/screens/onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isLogin = true; 

  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/background.jpg"), 
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                const Icon(Icons.fitness_center, color: Color(0xFFFF4081), size: 80),
                const SizedBox(height: 10),
                const Text("FITNESS PRO", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const SizedBox(height: 50),
                
                // TIÊU ĐỀ (Thay đổi theo trạng thái)
                Text(
                  _isLogin ? "ĐĂNG NHẬP" : "TẠO TÀI KHOẢN",
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // FORM NHẬP LIỆU
                _buildTextField(_usernameCtrl, "Tên tài khoản", Icons.person, false),
                const SizedBox(height: 15),
                _buildTextField(_passwordCtrl, "Mật khẩu", Icons.lock, true),
                
                // Ô nhập lại mật khẩu (Chỉ hiện khi Đăng ký)
                if (!_isLogin) ...[
                  const SizedBox(height: 15),
                  _buildTextField(_confirmPassCtrl, "Nhập lại mật khẩu", Icons.lock_outline, true),
                ],
                
                const SizedBox(height: 40),
                
                // NÚT CHÍNH
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4081),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _handleSubmit,
                    child: Text(
                      _isLogin ? "VÀO TẬP LUYỆN" : "ĐĂNG KÝ NGAY", 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // DÒNG CHUYỂN ĐỔI (LOGIN <-> REGISTER)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? "Chưa có tài khoản? " : "Đã có tài khoản? ",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin; // Đảo trạng thái
                          _usernameCtrl.clear();
                          _passwordCtrl.clear();
                          _confirmPassCtrl.clear();
                        });
                      },
                      child: Text(
                        _isLogin ? "Đăng ký ngay" : "Đăng nhập",
                        style: const TextStyle(color: Color(0xFFFF4081), fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, bool isPass) {
    return TextField(
      controller: ctrl,
      obscureText: isPass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFFF4081)), borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white10,
      ),
    );
  }

  void _handleSubmit() async {
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    
    if (username.isEmpty || password.isEmpty) {
      _showMsg("Vui lòng nhập đầy đủ thông tin!", Colors.orange);
      return;
    }

    final provider = Provider.of<FitnessProvider>(context, listen: false);
    bool success = false;

    if (_isLogin) {
      // --- LOGIC ĐĂNG NHẬP ---
      success = await provider.login(username, password);
      if (success) {
        if (!mounted) return;
        
        // KIỂM TRA: Mới hay Cũ?
        // Nếu chưa có bài tập nào => Người mới => Vào Onboarding
        if (provider.exercises.isEmpty) {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
        } else {
           // Nếu đã có bài tập => Người cũ => Vào Home
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      } else {
        _showMsg("Sai tài khoản hoặc mật khẩu!", Colors.red);
      }
    } else {
      // --- LOGIC ĐĂNG KÝ ---
      if (password != _confirmPassCtrl.text.trim()) {
        _showMsg("Mật khẩu nhập lại không khớp!", Colors.red);
        return;
      }

      success = await provider.register(username, password);
      if (success) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
        _showMsg("Tạo tài khoản thành công!", Colors.green);
      } else {
        _showMsg("Tài khoản đã tồn tại!", Colors.red);
      }
    }
  }

  void _showMsg(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}