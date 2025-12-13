class Exercise {
  final String id;
  final String name;
  final String routine;
  final String muscleGroup;
  final String level;
  final String imageUrl;
  final String description;
  final int sets;
  final int reps;
  final double weight;
  final DateTime date;
  final bool isCompleted;

  Exercise({
    required this.id, required this.name, required this.routine, required this.muscleGroup,
    required this.level, required this.imageUrl, required this.description,
    required this.sets, required this.reps, required this.weight, required this.date,
    this.isCompleted = false,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'], name: map['name'], routine: map['routine'], muscleGroup: map['muscleGroup'],
      level: map['level'], imageUrl: map['imageUrl'], description: map['description'],
      sets: map['sets'], reps: map['reps'], weight: map['weight'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']), isCompleted: map['isCompleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, 'name': name, 'routine': routine, 'muscleGroup': muscleGroup,
      'level': level, 'imageUrl': imageUrl, 'description': description,
      'sets': sets, 'reps': reps, 'weight': weight, 'date': date.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
    };
  }

  Exercise copyWith({int? sets, int? reps, double? weight, bool? isCompleted}) {
    return Exercise(
      id: id, name: name, routine: routine, muscleGroup: muscleGroup, level: level,
      imageUrl: imageUrl, description: description, date: date,
      sets: sets ?? this.sets, reps: reps ?? this.reps, weight: weight ?? this.weight,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}