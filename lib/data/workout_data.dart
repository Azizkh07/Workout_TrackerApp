import 'package:flutter/widgets.dart';
import 'package:workouttrucker/data/hive_database.dart';
import 'package:workouttrucker/models/exercise.dart';
import 'package:workouttrucker/models/workout.dart';

class workoutData extends ChangeNotifier {
  final db = HiveDatabase();
  List<Workout> WorkoutList = [
    Workout(name: "Upper Body", exercises: [
      Exercise(
          name: "Bench Press", weight: "60 KG", reps: " 12 / 10 ", sets: "3"),
    ]),
    Workout(name: "Lower Body", exercises: [
      Exercise(
          name: "Bench Press", weight: "60 KG", reps: " 12 / 10 ", sets: "3")
    ]),
  ];

  void intalizeWorkoutList() {
    if (db.previousDataExists()) {
      WorkoutList = db.readFromDataBase();
    } else {
      db.saveToDB(WorkoutList); // Save existing WorkoutList to the database
    }
  }

  List<Workout> getWorkouList() {
    return WorkoutList;
  }

  int numberOfExercisesInWorkout(String WorkoutName) {
    Workout releventWorkout = getReleventWorkout(WorkoutName);
    return releventWorkout.exercises.length;
  }

  void addWorkout(String name) {
    WorkoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    db.saveToDB(WorkoutList);
  }

  void addExercise(String WorkoutName, String exerciseName, String weight,
      String reps, String sets) {
    Workout releventWorkout = getReleventWorkout(WorkoutName);
    releventWorkout.exercises.add(Exercise(
      name: exerciseName,
      weight: weight,
      reps: reps,
      sets: sets,
    ));
    notifyListeners();
    db.saveToDB(WorkoutList);
  }

  void checkOfExercise(String WorkoutName, String exerciseName) {
    Exercise releventExercise = getReleventExercise(WorkoutName, exerciseName);
    releventExercise.isCompleted = !releventExercise.isCompleted;
    notifyListeners();
    db.saveToDB(WorkoutList);
  }

  Workout getReleventWorkout(String WorkoutName) {
    Workout releventWorkout =
        WorkoutList.firstWhere((Workout) => Workout.name == WorkoutName);
    return releventWorkout;
  }

  Exercise getReleventExercise(String WorkoutName, String exerciseName) {
    Workout releventWorkout = getReleventWorkout(WorkoutName);

    Exercise releventExercise = releventWorkout.exercises
        .firstWhere((Exercise) => Exercise.name == exerciseName);
    return releventExercise;
  }

  void deleteWorkout(int index) {
    WorkoutList.removeAt(index);
    notifyListeners();
    db.saveToDB(WorkoutList); // Save the updated WorkoutList to the database
  }

  void deleteExercise(String workoutName, String exerciseName) {}
}
