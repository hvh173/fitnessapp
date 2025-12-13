import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness/providers/fitness_provider.dart';
import 'package:fitness/models/exercise_model.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    final allExercises = provider.allExercises;

    allExercises.sort((a, b) => a.date.compareTo(b.date));

    DateTime startDate = allExercises.isNotEmpty 
        ? DateTime(allExercises.first.date.year, allExercises.first.date.month, allExercises.first.date.day)
        : DateTime.now();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Lịch Trình 4 Tuần", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ),
      body: allExercises.isEmpty 
      ? const Center(child: Text("Chưa có lịch tập. Hãy tạo mới!", style: TextStyle(color: Colors.grey)))
      : ListView.builder(
        padding: const EdgeInsets.only(bottom: 50),
        itemCount: 4, 
        itemBuilder: (context, weekIndex) {
          int weekNum = weekIndex + 1;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Container(width: 4, height: 25, color: const Color(0xFFFF4081), margin: const EdgeInsets.only(right: 10)),
                    Text("WEEK $weekNum", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    const Spacer(),
                    const Text("50 - 70 MIN each day", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              
              SizedBox(
                height: 140, 
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: 7, 
                  itemBuilder: (ctx, dayIndex) {
                    int daysToAdd = (weekIndex * 7) + dayIndex;
                    DateTime currentDayDate = startDate.add(Duration(days: daysToAdd));
                    var dailyExs = allExercises.where((e) => isSameDay(e.date, currentDayDate)).toList();

                    return _buildDayCard(dayIndex + 1, dailyExs);
                  },
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDayCard(int dayNum, List<Exercise> dailyExs) {
    String muscleGroup = "Rest";
    int exCount = 0;
    bool isCompleted = false;

    if (dailyExs.isNotEmpty) {
       var mainExList = dailyExs.where((e) => e.name != "Rest").toList();
       if (mainExList.isNotEmpty) {
         muscleGroup = mainExList.first.routine;
         exCount = mainExList.length;
         isCompleted = mainExList.every((e) => e.isCompleted);
       }
    }

    bool isRest = muscleGroup == "Rest";

    Color bgColor = isRest 
        ? const Color(0xFF111111) 
        : (isCompleted ? const Color(0xFFFF4081) : const Color(0xFF2C3E50));

    Color textColor = isCompleted ? Colors.white : Colors.grey;
    if (!isRest && !isCompleted) textColor = Colors.white70;


    IconData iconData = Icons.fitness_center;

    if (muscleGroup.contains("Ngực") || muscleGroup.contains("Chest")) {
      iconData = Icons.accessibility_new_rounded;
    } else if (muscleGroup.contains("Lưng") || muscleGroup.contains("Back")) {
      iconData = Icons.rowing_rounded;
    } else if (muscleGroup.contains("Chân") || muscleGroup.contains("Leg")) {
      iconData = Icons.directions_run_rounded;
    } else if (muscleGroup.contains("Tay") || muscleGroup.contains("Arm")) {
      iconData = Icons.fitness_center_rounded;
    }

    // Nếu là ngày nghỉ
    if (isRest) {
      iconData = Icons.nightlight_round; 
    }

    return Container(
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: isRest ? Border.all(color: Colors.white10) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$dayNum", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          Icon(
            iconData, 
            size: 32, 
            color: isCompleted ? Colors.white : (isRest ? Colors.grey[800] : const Color(0xFFFF4081))
          ),
          
          const SizedBox(height: 12),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              isRest ? "Rest" : muscleGroup.split('&').first.trim(), 
              style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 1, 
              overflow: TextOverflow.ellipsis
            ),
          ),
          
          if (!isRest)
            Text("$exCount Exercises", style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 9)),
        ],
      ),
    );
  }
}