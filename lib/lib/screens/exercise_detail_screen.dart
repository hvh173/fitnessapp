import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(exercise.name, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh lớn minh họa
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[800],
              child: const Icon(Icons.image, size: 100, color: Colors.white24), // Thay bằng Image.asset
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTag(exercise.level, Colors.blue),
                      _buildTag(exercise.muscleGroup, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Hướng dẫn thực hiện:", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    exercise.description.isEmpty ? "Chưa có hướng dẫn chi tiết." : exercise.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
                  ),
                  
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat("SETS", "${exercise.sets}"),
                        _buildStat("REPS", "${exercise.reps}"),
                        _buildStat("REST", "90s"),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Chip(
      label: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: color.withOpacity(0.2),
      side: BorderSide(color: color),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}