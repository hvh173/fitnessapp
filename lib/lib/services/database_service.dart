import 'package:localstore/localstore.dart';
import 'package:fitness/models/exercise_model.dart';
import 'package:fitness/models/user_model.dart';

class DatabaseService {
  final _db = Localstore.instance;

  Future<void> saveUser(User user) async {
    return _db.collection('users').doc(user.username).set(user.toMap());
  }

  Future<User?> getUser(String username) async {
    final data = await _db.collection('users').doc(username).get();
    if (data != null) return User.fromMap(data);
    return null;
  }

  Future<void> saveExercise(String username, Exercise exercise) async {
    return _db.collection('users').doc(username).collection('workouts').doc(exercise.id).set(exercise.toMap());
  }

  Future<void> deleteExercise(String username, String exerciseId) async {
    return _db.collection('users').doc(username).collection('workouts').doc(exerciseId).delete();
  }

  Future<List<Exercise>> getUserExercises(String username) async {
    final items = await _db.collection('users').doc(username).collection('workouts').get();
    if (items == null) return [];
    return items.entries.map((e) => Exercise.fromMap(e.value)).toList();
  }
}