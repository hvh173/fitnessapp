import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/models/exercise_model.dart';
import 'package:fitness/screens/workout_session_screen.dart';
import 'package:fitness/screens/login_screen.dart';
import 'package:fitness/screens/add_exercise_screen.dart';
import 'package:fitness/screens/onboarding_screen.dart';
import 'package:fitness/screens/schedule_screen.dart'; 
import 'package:fitness/screens/diet_screen.dart';
import 'package:fitness/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      
      // --- CẤU TRÚC 4 TAB ---
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildWorkoutTab(context),     
          const ScheduleScreen(),        
          const DietScreen(),            
          const ProfileScreen(),         
        ],
      ),

      // --- THANH MENU DƯỚI ---
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: const Color(0xFF1E1E1E)),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF1E1E1E),
          selectedItemColor: const Color(0xFFFF4081),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed, // Cố định 4 tab
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Hôm nay"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Lịch trình"),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Dinh dưỡng"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Hồ sơ"),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutTab(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    final exercises = provider.exercises;
    
    // Logic kiểm tra ngày nghỉ:
    bool isRestDay = exercises.isNotEmpty && exercises.first.routine == 'Rest';

    // Tính toán tiến độ
    double monthlyProgress = provider.monthlyProgress;
    bool isAllDone = !isRestDay && exercises.isNotEmpty && exercises.every((e) => e.isCompleted);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("HÔM NAY", style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(DateFormat('EEEE, dd/MM').format(provider.selectedDate), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        ]),
        actions: [
    
          // Nút thêm bài lẻ
          IconButton(icon: const Icon(Icons.add_circle, color: Colors.greenAccent, size: 28), 
             onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExerciseScreen()))),
          // Nút chọn ngày
          IconButton(icon: const Icon(Icons.edit_calendar, color: Color(0xFFFF4081)), onPressed: () => _pickDate(context, provider)) 
        ],
      ),
      body: Column(
        children: [
          //  HEADER TIẾN ĐỘ
          if (!isRestDay) 
          Container(
            margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                SizedBox(width: 60, height: 60, child: CircularProgressIndicator(value: monthlyProgress, strokeWidth: 6, backgroundColor: Colors.grey[800], color: const Color(0xFFFF4081))),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("Tiến độ tháng này", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("${(monthlyProgress * 100).toInt()}% hoàn thành", style: const TextStyle(color: Colors.grey)),
                  ]),
                )
              ],
            ),
          ),
          
          // DANH SÁCH BÀI TẬP 
          Expanded(
            child: (exercises.isEmpty || isRestDay) 
              ? _buildEmptyState(isRestDay) // Hiện màn hình Rest Day
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: exercises.length,
                  itemBuilder: (ctx, index) => _buildCard(context, exercises[index], provider),
                ),
          ),

          if (exercises.isNotEmpty && !isRestDay)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF121212),
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, -5))]
              ),
              child: SizedBox(
                height: 55,
                child: isAllDone 
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chúc mừng! Bạn đã hoàn thành xuất sắc!"))),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 10), 
                      Text("ĐÃ HOÀN THÀNH", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
                    ]),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4081), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    onPressed: () {
                        final remaining = exercises.where((e) => !e.isCompleted).toList();
                        if(remaining.isNotEmpty) Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutSessionScreen(exercises: remaining)));
                    },
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.play_circle_fill, color: Colors.white), SizedBox(width: 10), 
                      Text("BẮT ĐẦU TẬP", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
                    ]),
                  ),
              ),
            ),
        ],
      ),
    );
  }

  // WIDGET THẺ BÀI tẬP
  Widget _buildCard(BuildContext context, Exercise item, FitnessProvider provider) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(10), 
              child: Image.asset(
                item.imageUrl, width: 70, height: 70, fit: BoxFit.cover, 
                errorBuilder: (_,__,___) => Container(width: 70, height: 70, color: Colors.grey[800], child: const Icon(Icons.fitness_center, color: Colors.white))
              )
            ),
            const SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("${item.sets} sets • ${item.reps} reps", style: const TextStyle(color: Colors.grey))
            ])),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueGrey, size: 20),
              onPressed: () => _showEditDialog(context, item, provider),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20), 
              onPressed: () => _confirmDelete(context, provider, item.id), 
            ),
            IconButton(
              icon: Icon(item.isCompleted ? Icons.check_circle : Icons.circle_outlined, color: item.isCompleted ? Colors.green : Colors.grey, size: 30), 
              onPressed: () => provider.toggleExerciseStatus(item)
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isRestDay) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Image.asset(
            'assets/images/restday.gif',
            width: 200, height: 200, fit: BoxFit.contain,
            errorBuilder: (_,__,___) => const Icon(Icons.hotel_class, size: 100, color: Colors.amber),
          ),
        ),
        Text(isRestDay ? "REST DAY" : "CHƯA CÓ BÀI TẬP", style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            isRestDay 
              ? "Hôm nay là ngày nghỉ theo lịch trình.\nHãy thư giãn để cơ bắp phục hồi!" 
              : "Bạn chưa có bài tập nào hôm nay.\nHãy thêm bài hoặc tạo lịch mới.",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 16)
          ),
        ),
        const SizedBox(height: 30),
        if (!isRestDay)
        OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF4081)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExerciseScreen())), 
            icon: const Icon(Icons.add, color: Color(0xFFFF4081)),
            label: const Text("Thêm bài tập", style: TextStyle(color: Color(0xFFFF4081), fontWeight: FontWeight.bold))
          )
    ]));
  }


  void _confirmDelete(BuildContext context, FitnessProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Xóa bài tập?", style: TextStyle(color: Colors.white)),
        content: const Text("Bạn có chắc chắn muốn xóa bài này?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hủy", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () { provider.deleteExercise(id); Navigator.pop(ctx); }, 
            child: const Text("Xóa", style: TextStyle(color: Colors.white))
          ),
        ],
      )
    );
  }

  void _showEditDialog(BuildContext context, Exercise exercise, FitnessProvider provider) {
    final setsCtrl = TextEditingController(text: exercise.sets.toString());
    final repsCtrl = TextEditingController(text: exercise.reps.toString());
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Sửa thông số", style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: setsCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Sets", labelStyle: TextStyle(color: Colors.grey))),
            TextField(controller: repsCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Reps", labelStyle: TextStyle(color: Colors.grey))),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hủy", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4081)),
            onPressed: () {
              final updated = exercise.copyWith(sets: int.tryParse(setsCtrl.text) ?? exercise.sets, reps: int.tryParse(repsCtrl.text) ?? exercise.reps);
              provider.addOrUpdateExercise(updated);
              Navigator.pop(ctx);
            },
            child: const Text("Lưu", style: TextStyle(color: Colors.white)),
          )
        ],
      )
    );
  }

  Future<void> _pickDate(BuildContext context, FitnessProvider provider) async {
    final picked = await showDatePicker(context: context, initialDate: provider.selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030), builder: (c, child) => Theme(data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: Color(0xFFFF4081))), child: child!));
    if (picked != null) provider.setDate(picked);
  }
}