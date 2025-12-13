import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0; 
  

  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  
  String _gender = "Male";
  String _goal = "Gain"; 
  String _selectedLevel = "Beginner"; 

  @override
  void dispose() {
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //appBar title theo bước
    String title = "";
    if (_currentStep == 0) title = "Hồ Sơ Cá Nhân";
    else if (_currentStep == 1) title = "Mục Tiêu Của Bạn";
    else if (_currentStep == 2) title = "Bạn tập ở trình độ nào?";
    else title = "Chọn Lịch Tập Phù Hợp";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_currentStep == 0) return _buildStep0Stats();
    if (_currentStep == 1) return _buildStep1Goal();
    if (_currentStep == 2) return _buildStep2Level();
    return _buildStep3Plan();
  }

  //  NHẬP CHỈ SỐ 
  Widget _buildStep0Stats() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Chỉ số cơ thể", style: TextStyle(color: Color(0xFFFF4081), fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("Dữ liệu này giúp tính toán Calo chính xác.", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        
        _input("Cân nặng (kg)", _weightCtrl), 
        _input("Chiều cao (cm)", _heightCtrl), 
        _input("Tuổi", _ageCtrl),
        
        const SizedBox(height: 15),
        Row(children: [
            Radio(value: "Male", groupValue: _gender, activeColor: const Color(0xFFFF4081), onChanged: (v) => setState(() => _gender = v!)), const Text("Nam", style: TextStyle(color: Colors.white)),
            Radio(value: "Female", groupValue: _gender, activeColor: const Color(0xFFFF4081), onChanged: (v) => setState(() => _gender = v!)), const Text("Nữ", style: TextStyle(color: Colors.white)),
        ]),
        
        const SizedBox(height: 30),
        _btn("TIẾP TỤC", () {
           if (_weightCtrl.text.isEmpty || _heightCtrl.text.isEmpty || _ageCtrl.text.isEmpty) {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nhập đủ thông tin đi bạn ơi!"), backgroundColor: Colors.red));
             return;
           }
           setState(() => _currentStep = 1);
        })
    ]);
  }

  //CHỌN MỤC TIÊU 
  Widget _buildStep1Goal() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Mục tiêu của bạn?", style: TextStyle(color: Color(0xFFFF4081), fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      
      _goalCard("TĂNG CÂN", "Gain", "Dư thừa Calo (Bulking)", Colors.green),
      _goalCard("GIẢM CÂN", "Lose", "Thâm hụt Calo (Cutting)", Colors.orange),
      _goalCard("GIỮ CÂN", "Maintain", "Duy trì vóc dáng", Colors.blue),
      
      const SizedBox(height: 30),
      _btn("TIẾP TỤC", () {
        Provider.of<FitnessProvider>(context, listen: false).updateUserInfo(
          double.tryParse(_weightCtrl.text) ?? 60,
          double.tryParse(_heightCtrl.text) ?? 170,
          int.tryParse(_ageCtrl.text) ?? 20,
          _gender, _goal
        );
        setState(() => _currentStep = 2);
      })
    ]);
  }

  Widget _goalCard(String title, String val, String desc, Color color) {
    bool selected = _goal == val;
    return GestureDetector(
      onTap: () => setState(() => _goal = val),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: selected ? Border.all(color: color, width: 2) : null,
        ),
        child: Row(
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(color: selected ? color : Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ])),
            if (selected) Icon(Icons.check_circle, color: color)
          ],
        ),
      ),
    );
  }

  // CHỌN LEVEL 
  Widget _buildStep2Level() {
    final levels = [
      {'val': 'Beginner', 'color': Colors.green, 'img': 'assets/images/begin.jpg'},
      {'val': 'Intermediate', 'color': Colors.orange, 'img': 'assets/images/medium.jpg'},
      {'val': 'Advanced', 'color': Colors.red, 'img': 'assets/images/advan.jpg'},
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Trình độ tập?", style: TextStyle(color: Color(0xFFFF4081), fontSize: 24, fontWeight: FontWeight.bold)), 
        const SizedBox(height: 20),
        
        ...levels.map((lvl) {
          String val = lvl['val'] as String;
          Color color = lvl['color'] as Color;
          String img = lvl['img'] as String;
          bool isSelected = _selectedLevel == val;

          return GestureDetector(
            onTap: () => setState(() => _selectedLevel = val),
            child: Container(
              height: 100, 
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
                border: isSelected ? Border.all(color: color, width: 2) : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(children: [
                          Radio(value: val, groupValue: _selectedLevel, activeColor: color, onChanged: (v) => setState(() => _selectedLevel = v!)),
                          Text(val, style: TextStyle(color: isSelected ? color : Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                    child: Image.asset(
                      img, 
                      width: 100, 
                      height: double.infinity, 
                      fit: BoxFit.cover, 
                      errorBuilder: (ctx, err, stack) => Container(width: 100, color: Colors.grey[800], child: const Icon(Icons.broken_image, color: Colors.white))
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        
        const SizedBox(height: 20), 
        _btn("TIẾP TỤC", () => setState(() => _currentStep = 3))
    ]);
  }

  // CHỌN LỊCH 
  Widget _buildStep3Plan() {
    final plans = [
      {
        'title': 'FULL BODY', 
        'subtitle': '3 buổi/tuần.', 
        'split': 'Full Body', 
        'colors': [Colors.pinkAccent, Colors.pink], 
        'image': 'assets/images/full.jpg'
      },
      {
        'title': 'UPPER / LOWER', 
        'subtitle': '4 buổi/tuần.', 
        'split': 'Upper Lower', 
        'colors': [Colors.deepPurpleAccent, Colors.purple], 
        'image': 'assets/images/upl.jpg'
      },
      {
        'title': 'PUSH PULL LEGS', 
        'subtitle': '6 buổi/tuần.', 
        'split': 'Push Pull Legs (PPL)', 
        'colors': [Colors.blueAccent, Colors.blue], 
        'image': 'assets/images/ppl.jpg'
      },
    ];
    
    return Column(children: plans.map((p) {

      final List<Color> gradientColors = (p['colors'] as List).cast<Color>();
      final String imagePath = p['image'] as String;
      final String splitType = p['split'] as String;

      return GestureDetector(
        onTap: () async {
          final provider = Provider.of<FitnessProvider>(context, listen: false);
          
          // Show Loading
          showDialog(
            context: context, 
            barrierDismissible: false, 
            builder: (ctx) => const Center(child: CircularProgressIndicator(color: Color(0xFFFF4081)))
          );

          try {
            // Chạy logic tạo lịch với TIMEOUT 5 GIÂY 
            await provider.generatePlan(_selectedLevel, splitType)
                .timeout(const Duration(seconds: 5), onTimeout: () {
                  print("--- Timeout: Provider chạy quá lâu, bỏ qua ---");
                  return; 
                });

            // Kiểm tra widget còn tồn tại không
            if (!mounted) return;
            
            // Tắt Loading
            Navigator.of(context, rootNavigator: true).pop(); 

            // Chuyển màn hình và xóa stack cũ
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (_) => const HomeScreen()), 
              (route) => false
            );

          } catch (e) {
            // Xử lý lỗi
            print("Lỗi UI: $e");
            if (mounted) {
              Navigator.of(context, rootNavigator: true).pop(); // Tắt loading nếu còn
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red));
            }
          }
        },
        child: Container(
          height: 180, 
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), 
            gradient: LinearGradient(colors: gradientColors) 
          ),
          child: Stack(children: [
             Positioned(
               right: 0, top: 0, bottom: 0,
               child: ClipRRect(
                 borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                 child: Image.asset(
                   imagePath, 
                   width: 150, 
                   height: double.infinity, 
                   fit: BoxFit.cover, 
                   errorBuilder: (ctx, err, stack) => Container(width: 150, color: Colors.white24, child: const Icon(Icons.image_not_supported, color: Colors.white))
                 ),
               )
             ),
             Padding(
               padding: const EdgeInsets.fromLTRB(20, 20, 160, 20), 
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start, 
                 mainAxisAlignment: MainAxisAlignment.center, 
                 children: [
                   Text(p['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                   Text(p['subtitle'] as String, style: const TextStyle(color: Colors.white)),
                   const SizedBox(height: 10),
                   const Row(children: [
                     Icon(Icons.touch_app, color: Colors.yellow, size: 16), 
                     SizedBox(width: 5), 
                     Text("CHỌN NGAY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                   ])
                 ]
               )
             )
          ]),
        ),
      );
    }).toList());
  }

  // --- WIDGET CON ---
  Widget _input(String l, TextEditingController c) => Padding(padding: const EdgeInsets.only(bottom: 15), child: TextField(controller: c, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: l, filled: true, fillColor: const Color(0xFF1E1E1E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))));
  Widget _btn(String t, VoidCallback f) => SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4081)), onPressed: f, child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))));
}