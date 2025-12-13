import 'package:flutter/material.dart';

class ExerciseData {
  
  // 1. DANH SÁCH BÀI TẬP (LIBRARY)
  static const Map<String, List<String>> library = {
    'Ngực': ['Hít đất (Push Up)', 'Diamond Push Up', 'Dip','Pike Push Up', 'Bench Dip'],
    'Chân': ['Squat thường', 'Jump Squat', 'Lunge (Chùng chân)', 'Nhón bắp chân'],
    'Lưng': ['Hít xà (Pull Up)', 'Chin up', 'Tuck Front Lever'], 
    'Tay': ['Bench Dip', 'Diamond Push Up'],
    'Bụng': ['Plank', 'ABS Bike'],
    'Vai': ['Pike Push Up', 'Handstand Push Up'],
  };

  // 2. LOGIC LẤY ẢNH TỰ ĐỘNG 
  static String getImageFor(String exerciseName) {
    String name = exerciseName.toLowerCase();
    if (name.contains("pike")) return "assets/images/pike.gif";
    if (name.contains("diamond")) return "assets/images/kimcuong.gif"; 
    if (name.contains("hít đất") || name.contains("push up")) return "assets/images/pushup.gif";
    if (name.contains("dip")) return "assets/images/dip.gif"; 
    

    if (name.contains("hít xà") || name.contains("pull")) return "assets/images/pull.gif";
    if (name.contains("chin")) return "assets/images/chin.gif";
    if (name.contains("tuck")) return "assets/images/tuck.gif";

    if (name.contains("jump")) return "assets/images/jump.gif";
    if (name.contains("squat")) return "assets/images/squat.gif";
    if (name.contains("lunge") || name.contains("chùng")) return "assets/images/lunge.gif";
    if (name.contains("nhón") || name.contains("bắp chân")) return "assets/images/rise.gif";

    if (name.contains("plank")) return "assets/images/plank.gif";
    if (name.contains("abs") || name.contains("bike")) {
      return "assets/images/absbike.gif";
    }

    return "assets/images/ppl.jpg"; 
  }


  static const List<Map<String, dynamic>> categories = [
    {
      'name': 'ABS WORKOUT',
      'subtitle': 'Cơ bụng 6 múi',
      'colors': [0xFFFF4081, 0xFFFF80AB], // Hồng
      'image': 'assets/images/bung.jpg',
      'exercises': ['Plank', 'ABS Bike'],
      'group': 'Bụng' 
    },
    {
      'name': 'CHEST & ARMS',
      'subtitle': 'Ngực nở tay to',
      'colors': [0xFF7C4DFF, 0xFFB388FF], // Tím
      'image': 'assets/images/nguc.jpg',
      'exercises': ['Hít đất (Push Up)', 'Diamond Push Up', 'Dip'],
      'group': 'Ngực'
    },
    {
      'name': 'LEGS DAY',
      'subtitle': 'Chân đùi săn chắc',
      'colors': [0xFF448AFF, 0xFF82B1FF], // Xanh dương
      'image': 'assets/images/leg.jpg', 
      'exercises': ['Squat thường', 'Jump Squat', 'Lunge', 'Nhón bắp chân'],
      'group': 'Chân'
    },
    {
      'name': 'BACK & SHOULDER',
      'subtitle': 'Lưng xô vạm vỡ',
      'colors': [0xFFFF5252, 0xFFFF8A80], // Đỏ cam
      'image': 'assets/images/lung.jpg', 
      'exercises': ['Hít xà (Pull Up)', 'Chin up', 'Tuck Front Lever'],
      'group': 'Lưng'
    },
  ];
}