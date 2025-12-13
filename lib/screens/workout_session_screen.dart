import 'dart:async'; // viện này để chạy đồng hồ
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness/models/exercise_model.dart';
import 'package:fitness/providers/fitness_provider.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final List<Exercise> exercises;
  const WorkoutSessionScreen({super.key, required this.exercises});

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int _currentIndex = 0;
  int _currentSet = 1;

  @override
  void initState() {
    super.initState();
    _currentSet = 1;
  }

  // Hàm xử lý logic chuyển Set/Bài (được gọi sau khi nghỉ xong)
  void _performSetUpdate() {
    final currentExercise = widget.exercises[_currentIndex];

    // Nếu vẫn còn Set chưa tập
    if (_currentSet < currentExercise.sets) {
      setState(() {
        _currentSet++;
      });
    } else {
      // Nếu đã hết Set -> Đánh dấu xong bài -> Chuyển bài tiếp theo
      Provider.of<FitnessProvider>(context, listen: false)
          .toggleExerciseStatus(currentExercise);
      _goToNextExercise();
    }
  }

  // Khi bấm nút V (Hoàn thành) -> Hiện bảng đếm ngược nghỉ ngơi
  void _onSetCompleted() {
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho bấm ra ngoài để tắt
      builder: (ctx) => RestTimerDialog(
        durationSeconds: 90, // Cài đặt 90 giây nghỉ
        onComplete: () {
          _performSetUpdate(); // Hết giờ hoặc bấm Skip thì chạy hàm này
        },
      ),
    );
  }

  void _goToNextExercise() {
    if (_currentIndex < widget.exercises.length - 1) {
      setState(() {
        _currentIndex++;
        _currentSet = 1;
      });
    } else {
      _finishSession();
    }
  }

  void _goToPreviousExercise() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _currentSet = 1;
      });
    }
  }

  void _finishSession() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Chúc mừng! Bạn đã hoàn thành buổi tập!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.exercises[_currentIndex];
    const Color primaryBlue = Color(0xFF007AFF);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Bài ${_currentIndex + 1}/${widget.exercises.length}",
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
      extendBodyBehindAppBar: true, 
      body: Column(
        children: [
          // ẢNH BÀI TẬP 
          Expanded(
            flex: 4, 
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E), 
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.asset(
                  currentExercise.imageUrl,
                  fit: BoxFit.contain, 
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),

          // THÔNG TIN VÀ NÚT ĐIỀU KHIỂN
          Expanded(
            flex: 6, 
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tên bài tập
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      currentExercise.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  
                  // SET 1 / 3
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[800]!)
                    ),
                    child: Text(
                      "SET $_currentSet / ${currentExercise.sets}",
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2
                      ),
                    ),
                  ),
                  
                  // SỐ REPS
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "x ${currentExercise.reps}",
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  // Hàng nút điều khiển
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _currentIndex > 0 ? _goToPreviousExercise : null,
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 30,
                          color: _currentIndex > 0 ? Colors.white : Colors.white24,
                        ),
                      ),

                      // NÚT HOÀN THÀNH 
                      GestureDetector(
                        onTap: _onSetCompleted,
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: primaryBlue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 50,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: _currentIndex < widget.exercises.length - 1
                            ? _goToNextExercise
                            : null,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 30,
                          color: _currentIndex < widget.exercises.length - 1
                              ? Colors.white
                              : Colors.white24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Đồng hồ
class RestTimerDialog extends StatefulWidget {
  final int durationSeconds;
  final VoidCallback onComplete;

  const RestTimerDialog({
    super.key,
    required this.durationSeconds,
    required this.onComplete,
  });

  @override
  State<RestTimerDialog> createState() => _RestTimerDialogState();
}

class _RestTimerDialogState extends State<RestTimerDialog> {
  late int _timeLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.durationSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _skip();
      }
    });
  }

  void _skip() {
    _timer?.cancel();
    Navigator.of(context).pop(); 
    widget.onComplete(); //
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Format giây thành MM:SS
  String get _timerString {
    final m = (_timeLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_timeLeft % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("NGHỈ NGƠI", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100, height: 100,
                child: CircularProgressIndicator(
                  value: _timeLeft / widget.durationSeconds,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[800],
                  color: const Color(0xFF007AFF),
                ),
              ),
              Text(_timerString, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          const Text("Hít thở sâu...", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          
          // Nút Bỏ qua
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
              ),
              onPressed: _skip, 
              child: const Text("BỎ QUA & TẬP TIẾP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

}

