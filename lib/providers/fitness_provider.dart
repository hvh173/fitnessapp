import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:fitness/models/exercise_model.dart';
import 'package:fitness/models/user_model.dart';
import 'package:fitness/services/database_service.dart';
import 'package:fitness/utils/exercise_data.dart'; 

class FitnessProvider extends ChangeNotifier {
  final DatabaseService _service = DatabaseService();

  double _weight = 60.0;
  double _height = 170.0;
  int _age = 20;
  String _gender = "Male";
  String _goal = "Maintain"; 

  // Getter
  double get weight => _weight;
  double get height => _height;
  int get age => _age;
  String get gender => _gender;
  String get goal => _goal;

  List<Exercise> _allExercises = [];
  List<Exercise> _todayExercises = [];
  DateTime _selectedDate = DateTime.now();
  User? _currentUser;
  
  // Dinh dưỡng
  int _targetCalories = 2000;
  int _consumedCalories = 0;
  List<Map<String, dynamic>> _eatenFoods = [];

  User? get currentUser => _currentUser;
  List<Exercise> get exercises => _todayExercises; 
  List<Exercise> get allExercises => _allExercises;
  DateTime get selectedDate => _selectedDate;
  int get targetCalories => _targetCalories;
  int get consumedCalories => _consumedCalories;
  List<Map<String, dynamic>> get eatenFoods => _eatenFoods;

  
  void updateUserInfo(double w, double h, int a, String g, String targetGoal) {
    _weight = w; _height = h; _age = a; _gender = g; _goal = targetGoal;
    _calculateTDEE(); notifyListeners();
  }

  void _calculateTDEE() {
    double bmr;
    if (_gender == 'Male') {
      bmr = (10 * _weight) + (6.25 * _height) - (5 * _age) + 5;
    } else {
      bmr = (10 * _weight) + (6.25 * _height) - (5 * _age) - 161;
    }
    double tdee = bmr * 1.55;
    if (_goal == 'Gain') _targetCalories = (tdee + 500).toInt();
    else if (_goal == 'Lose') _targetCalories = (tdee - 500).toInt();
    else _targetCalories = tdee.toInt();
  }

  // LOGIC DINH DƯỠNG 
  void addFood(String name, int cal) {
    _eatenFoods.add({'name': name, 'cal': cal});
    _consumedCalories += cal; notifyListeners();
  }

  void removeFood(int index) {
    if (index >= 0 && index < _eatenFoods.length) {
      _consumedCalories -= (_eatenFoods[index]['cal'] as int);
      _eatenFoods.removeAt(index); notifyListeners();
    }
  }

  // LOGIC USER
  Future<bool> login(String username, String password) async {
    final user = await _service.getUser(username);
    if (user != null && user.password == password) {
      _currentUser = user; await loadData(); return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final existing = await _service.getUser(username);
    if (existing != null) return false;
    final newUser = User(username: username, password: password);
    await _service.saveUser(newUser); _currentUser = newUser;
    notifyListeners(); return true;
  }

  void logout() {
    _currentUser = null; _allExercises = []; _todayExercises = []; _eatenFoods = []; 
    _consumedCalories = 0; _targetCalories = 2000; notifyListeners();
  }

  // quản lý bài tập
  Future<void> loadData() async {
    if (_currentUser == null) return;
    _allExercises = await _service.getUserExercises(_currentUser!.username);
    _filterByDate(_selectedDate); notifyListeners();
  }

  Future<void> addOrUpdateExercise(Exercise exercise) async {
    if (_currentUser == null) return;
    await _service.saveExercise(_currentUser!.username, exercise);
    final index = _allExercises.indexWhere((e) => e.id == exercise.id);
    if (index >= 0) _allExercises[index] = exercise; else _allExercises.add(exercise);
    _filterByDate(_selectedDate); notifyListeners();
  }

  Future<void> deleteExercise(String id) async {
    if (_currentUser == null) return;
    await _service.deleteExercise(_currentUser!.username, id);
    _allExercises.removeWhere((e) => e.id == id);
    _filterByDate(_selectedDate); notifyListeners();
  }

  Future<void> toggleExerciseStatus(Exercise exercise) async {
    final updated = exercise.copyWith(isCompleted: !exercise.isCompleted);
    await addOrUpdateExercise(updated);
  }

  void setDate(DateTime date) { _selectedDate = date; _filterByDate(date); notifyListeners(); }

  void _filterByDate(DateTime date) {
    _todayExercises = _allExercises.where((e) => e.date.year == date.year && e.date.month == date.month && e.date.day == date.day).toList();
  }

 
  double get monthlyProgress {
    if (_currentUser == null || _allExercises.isEmpty) return 0.0;
    
    final now = DateTime.now();
    final thisMonth = _allExercises.where((e) => e.date.month == now.month && e.date.year == now.year).toList();
    
    final actualWorkouts = thisMonth.where((e) => e.name != "Rest").toList();

    if (actualWorkouts.isEmpty) return 0.0;
    
    return actualWorkouts.where((e) => e.isCompleted).length / actualWorkouts.length;
  }

  DateTime _stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }


  Future<void> generatePlan(String level, String splitType) async {
    if (_currentUser == null) return;
    print("--- Provider: Đang tạo lịch $splitType cho cấp độ $level");

  
    for(var ex in _allExercises) { await _service.deleteExercise(_currentUser!.username, ex.id); }
    _allExercises.clear(); notifyListeners();

    List<Exercise> newPlan = [];
    DateTime startDate = _stripTime(DateTime.now()); 
    
    // Reps theo Level
    int baseSets = 3;
    int baseReps = 8; 

    if (level == "Intermediate" || level == "Trung bình") {
      baseSets = 4;
      baseReps = 12;
    } else if (level == "Advanced" || level == "Nâng cao") {
      baseSets = 5;
      baseReps = 15;
    }

    for (int i = 0; i < 28; i++) {
      DateTime d = startDate.add(Duration(days: i));
      int week = (i ~/ 7) + 1;

      //  Tăng tiến độ khó 
      int currentSets = baseSets;
      int currentReps = baseReps;

      if (week == 2) currentReps += 2; 
      if (week == 3) { currentSets += 1; }
      if (week == 4) { currentReps += 2; currentSets += 1; }

      // 3. Chia lịch theo Split Type
      if (splitType == "Push Pull Legs (PPL)") {
        int cycle = i % 4; 
        if (cycle == 0) {
           _addExs(newPlan, d, currentSets, currentReps, level, "Ngực & Tay Sau", 
             ['Hít đất (Push Up)', 'Diamond Push Up', 'Pike Push Up', 'Dip']);
        } 
        else if (cycle == 1) {
           _addExs(newPlan, d, currentSets, currentReps, level, "Lưng & Tay Trước", 
             ['Hít xà (Pull Up)', 'Chin up', 'Tuck Front Lever']);
        } 
        else if (cycle == 2) {
           _addExs(newPlan, d, currentSets, currentReps, level, "Chân & Mông", 
             ['Squat thường', 'Lunge (Chùng chân)', 'Nhón bắp chân']);
        } 
        else _addRestDay(newPlan, d);
        
      } else if (splitType == "Upper Lower") {
        int cycle = i % 7;
        if (cycle == 0 || cycle == 3) {
           _addExs(newPlan, d, currentSets, currentReps, level, "Thân Trên", 
             ['Hít đất (Push Up)', 'Hít xà (Pull Up)', 'Dip']);
        } 
        else if (cycle == 1 || cycle == 4) {
           _addExs(newPlan, d, currentSets, currentReps, level, "Thân Dưới", 
             ['Squat thường', 'Lunge (Chùng chân)', 'Plank']);
        } 
        else _addRestDay(newPlan, d);

      } else { 
        // Full Body
        if (i % 2 == 0) {
           _addExs(newPlan, d, currentSets, currentReps, level, "Toàn Thân", 
             ['Jump Squat', 'Hít đất (Push Up)', 'Plank']);
        } 
        else _addRestDay(newPlan, d);
      }
    }

    // Lưu vào database
    try {
      for (var ex in newPlan) {
        await _service.saveExercise(_currentUser!.username, ex);
        await Future.delayed(const Duration(milliseconds: 5)); 
      }
      await loadData();
    } catch (e) {
      print("Lỗi lưu plan: $e");
    }
  }

  void _addExs(List<Exercise> plan, DateTime d, int s, int r, String l, String muscle, List<String> names) {
    for (var n in names) {
      int finalReps = r;

      if (n.contains("Plank")) {
        int baseSec = (l == "Beginner" || l == "Người mới") ? 30 : 45;
        if (l == "Advanced" || l == "Nâng cao") baseSec = 60;
        
        // Tăng thêm giây dựa trên mức tăng reps của tuần
        finalReps = baseSec + ((r - 8) * 2); 
        if (finalReps < baseSec) finalReps = baseSec;
      }

      plan.add(Exercise(
        id: const Uuid().v4(), 
        name: n, 
        routine: muscle, 
        muscleGroup: muscle, 
        level: l,
        imageUrl: ExerciseData.getImageFor(n), 
        description: "Bài tập $n", 
        sets: s, 
        reps: finalReps, 
        weight: 0, 
        date: d, 
        isCompleted: false
      ));
    }
  }

  void _addRestDay(List<Exercise> plan, DateTime d) {
    plan.add(Exercise(
        id: const Uuid().v4(), 
        name: "Rest", routine: "Rest", muscleGroup: "Rest", level: "",
        imageUrl: "", description: "Nghỉ ngơi", sets: 0, reps: 0, weight: 0, 
        date: d, isCompleted: true
    ));
  }

  Future<bool> changePassword(String oldPass, String newPass) async {
    if (_currentUser == null) return false;

    // 1. Kiểm tra mật khẩu cũ có đúng không
    if (_currentUser!.password != oldPass) {
      return false; // Sai mật khẩu cũ
    }

    // Cập nhật mật khẩu mới
    final updatedUser = User(
        username: _currentUser!.username, 
        password: newPass 
    );
    // Database
    await _service.saveUser(updatedUser); 
    _currentUser = updatedUser;
    notifyListeners();
    return true; 
  }
}