import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/screens/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  String _goal = "Gain";

  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = Provider.of<FitnessProvider>(context, listen: false);
    _weightCtrl.text = p.weight.toString();
    _heightCtrl.text = p.height.toString();
    _ageCtrl.text = p.age.toString();
    _goal = p.goal;
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E), // Màu nền tối
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Đăng xuất", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text("Bạn có chắc chắn muốn đăng xuất không?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Đóng dialog
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); 
              Provider.of<FitnessProvider>(context, listen: false).logout();
              // Chuyển về màn hình Welcome
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (_) => const WelcomeScreen()), 
                (route) => false
              );
            },
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FitnessProvider>(context).currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Cài Đặt", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/background.jpg"),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 15),
            Text(
              user?.username.toUpperCase() ?? "USER",
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader("Chỉ số cơ thể"),
            const SizedBox(height: 15),
            
            Row(
              children: [
                Expanded(child: _buildInputBox("Cân nặng", _weightCtrl, suffix: "kg")),
                const SizedBox(width: 15),
                Expanded(child: _buildInputBox("Chiều cao", _heightCtrl, suffix: "cm")),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildInputBox("Tuổi", _ageCtrl, suffix: "tuổi")),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _goal,
                        dropdownColor: const Color(0xFF1E1E1E),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFF4081)),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: "Gain", child: Text("Tăng cơ")),
                          DropdownMenuItem(value: "Lose", child: Text("Giảm mỡ")),
                          DropdownMenuItem(value: "Maintain", child: Text("Giữ cân")),
                        ],
                        onChanged: (val) => setState(() => _goal = val!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4081),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  final p = Provider.of<FitnessProvider>(context, listen: false);
                  p.updateUserInfo(
                    double.tryParse(_weightCtrl.text) ?? p.weight,
                    double.tryParse(_heightCtrl.text) ?? p.height,
                    int.tryParse(_ageCtrl.text) ?? p.age,
                    p.gender,
                    _goal
                  );
                  _showMsg("Đã cập nhật chỉ số & Tính lại Calo!", true);
                },
                child: const Text("LƯU CHỈ SỐ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 40),

            // 3. BẢO MẬT
            _buildSectionHeader("Bảo mật"),
            const SizedBox(height: 15),
            _buildInputBox("Mật khẩu cũ", _oldPassCtrl, isPass: true, icon: Icons.lock_outline),
            const SizedBox(height: 15),
            _buildInputBox("Mật khẩu mới", _newPassCtrl, isPass: true, icon: Icons.lock),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () async {
                  if (_oldPassCtrl.text.isEmpty || _newPassCtrl.text.isEmpty) {
                    _showMsg("Vui lòng nhập mật khẩu!", false);
                    return;
                  }
                  final p = Provider.of<FitnessProvider>(context, listen: false);
                  bool success = await p.changePassword(_oldPassCtrl.text, _newPassCtrl.text);
                  
                  if (success) {
                    _showMsg("Đổi mật khẩu thành công!", true);
                    _oldPassCtrl.clear();
                    _newPassCtrl.clear();
                  } else {
                    _showMsg("Mật khẩu cũ không đúng!", false);
                  }
                },
                child: const Text("ĐỔI MẬT KHẨU", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 40),
            TextButton(
              onPressed: _confirmLogout, // Gọi hàm hỏi trước
              child: const Text("Đăng xuất", style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: 4, height: 18, color: const Color(0xFFFF4081), margin: const EdgeInsets.only(right: 10)),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInputBox(String label, TextEditingController ctrl, {String? suffix, bool isPass = false, IconData? icon}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      child: TextField(
        controller: ctrl,
        obscureText: isPass,
        keyboardType: isPass ? TextInputType.text : TextInputType.number,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixText: suffix,
          suffixStyle: const TextStyle(color: Color(0xFFFF4081), fontWeight: FontWeight.bold),
          icon: icon != null ? Icon(icon, color: Colors.grey, size: 20) : null,
        ),
      ),
    );
  }

  void _showMsg(String msg, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: isSuccess ? Colors.green[700] : Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      )
    );
  }
}