import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:fitness/models/exercise_model.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/utils/exercise_data.dart';

class AddExerciseScreen extends StatelessWidget {
  const AddExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ExerciseData.categories;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("THƯ VIỆN BÀI TẬP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 50),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () => _showExerciseList(context, cat),
            child: Container(
              height: 150, // Chiều cao cố định chuẩn form
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // Gradient nền
                gradient: LinearGradient(
                  colors: [Color(cat['colors'][0]), Color(cat['colors'][1])],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [BoxShadow(color: Color(cat['colors'][0]).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Stack(
                children: [
                  // 1. ẢNH NẰM BÊN PHẢI 
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 140, 
                    child: ClipRRect(

                      borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                      child: Image.asset(
                        cat['image'],
                        fit: BoxFit.cover, // Ảnh tràn viền, cắt bớt phần thừa nếu cần
                        alignment: Alignment.center, // Căn giữa ảnh
                        errorBuilder: (_,__,___) => const Icon(Icons.fitness_center, size: 80, color: Colors.white24),
                      ),
                    ),
                  ),

                  // 2. CHỮ NẰM BÊN TRÁI
                  Positioned(
                    left: 20,
                    top: 20,
                    bottom: 20,
                    right: 130, 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cat['name'],
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                          maxLines: 2, overflow: TextOverflow.ellipsis, // Nếu tên dài quá thì xuống dòng
                        ),
                        const SizedBox(height: 5),
                        Text(
                          cat['subtitle'],
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        // Nút nhỏ xinh
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text("Chọn bài", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showExerciseList(BuildContext context, Map<String, dynamic> category) {
    final listExercises = category['exercises'] as List<String>;
    final groupName = category['name'];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bài tập $groupName", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey),
            Expanded(
              child: ListView.builder(
                itemCount: listExercises.length,
                itemBuilder: (context, i) {
                  final exName = listExercises[i];
                  final exImage = ExerciseData.getImageFor(exName);

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(exImage, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.fitness_center, color: Colors.white)),
                    ),
                    title: Text(exName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.greenAccent, size: 30),
                      onPressed: () {
                        _addExercise(context, exName, "Custom"); 
                        Navigator.pop(ctx); 
                        Navigator.pop(context); 
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addExercise(BuildContext context, String name, String muscleGroup) {
    final provider = Provider.of<FitnessProvider>(context, listen: false);
    if (provider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lỗi: Hãy đăng nhập lại!")));
      return;
    }

    final newEx = Exercise(
      id: const Uuid().v4(), name: name, routine: "Custom", muscleGroup: muscleGroup, level: "Custom",
      imageUrl: ExerciseData.getImageFor(name), 
      description: "Bài tập bổ sung: $name", sets: 3, reps: 12, weight: 0,
      date: provider.selectedDate, isCompleted: false,
    );

    provider.addOrUpdateExercise(newEx);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã thêm: $name"), backgroundColor: Colors.green));
  }
}