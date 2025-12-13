import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/utils/food_data.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    final int target = provider.targetCalories > 0 ? provider.targetCalories : 2000; // Mặc định nếu chưa nhập
    final int current = provider.consumedCalories;
    final double progress = (current / target).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // 1. HEADER CALO
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 80, height: 80,
                    child: Stack(alignment: Alignment.center, children: [
                      CircularProgressIndicator(value: progress, color: Colors.white, backgroundColor: Colors.white24, strokeWidth: 8),
                      Text("${(progress*100).toInt()}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                    ]),
                  ),
                  const SizedBox(width: 20),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Đã ăn: $current kcal", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Mục tiêu: $target kcal", style: const TextStyle(color: Colors.white70)),
                  ])
                ],
              ),
            ),

            // 2. DANH SÁCH ĐÃ ĂN
            Expanded(
              child: provider.eatenFoods.isEmpty
              ? const Center(child: Text("Chưa ăn gì hôm nay", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: provider.eatenFoods.length,
                  itemBuilder: (ctx, index) {
                    final food = provider.eatenFoods[index];
                    return ListTile(
                      leading: const Icon(Icons.fastfood, color: Colors.orange),
                      title: Text(food['name'], style: const TextStyle(color: Colors.white)),
                      subtitle: Text("${food['cal']} kcal", style: const TextStyle(color: Colors.grey)),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => provider.removeFood(index),
                      ),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () => _showFoodMenu(context, provider),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showFoodMenu(BuildContext context, FitnessProvider provider) {
    showModalBottomSheet(
      context: context, backgroundColor: const Color(0xFF1E1E1E),
      builder: (ctx) => ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: FoodData.foods.length,
        itemBuilder: (c, i) {
          final food = FoodData.foods[i];
          return ListTile(
            leading: ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.asset(food['image'], width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.fastfood, color: Colors.white))),
            title: Text(food['name'], style: const TextStyle(color: Colors.white)),
            subtitle: Text("${food['cal']} kcal", style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.add_circle, color: Colors.green),
            onTap: () {
              provider.addFood(food['name'], food['cal']);
              Navigator.pop(ctx);
            },
          );
        },
      )
    );
  }
}