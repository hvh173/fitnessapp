import 'package:flutter/material.dart';
import 'package:fitness/models/exercise_model.dart';

class ExerciseCardWidget extends StatelessWidget {
  final Exercise item;
  final VoidCallback onToggle; // Hàm xử lý khi bấm Check
  final VoidCallback onEdit;   // Hàm xử lý khi bấm Sửa
  final VoidCallback onDelete; // Hàm xử lý khi bấm Xóa

  const ExerciseCardWidget({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Nền đen xám
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // 1. ẢNH MINH HỌA
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 15),

          // 2. THÔNG TIN (Tên, Sets, Reps)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  "${item.sets} sets • ${item.reps} reps",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // 3. CÁC NÚT THAO TÁC
          // Nút Sửa
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueGrey, size: 20),
            onPressed: onEdit,
          ),
          // Nút Xóa
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
            onPressed: onDelete,
          ),
          // Nút Check
          IconButton(
            icon: Icon(
              item.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: item.isCompleted ? Colors.green : Colors.grey,
              size: 30,
            ),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}