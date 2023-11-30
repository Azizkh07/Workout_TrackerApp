import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workouttrucker/components/exercise_tile.dart';
import 'package:workouttrucker/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onCheckBoxChanged(String WorkoutName, String exerciseName) {
    Provider.of<workoutData>(context, listen: false)
        .checkOfExercise(WorkoutName, exerciseName);
    void deleteExercise(String exerciseName) {
      Provider.of<workoutData>(context, listen: false)
          .deleteExercise(widget.workoutName, exerciseName);
      void modifyExercise(String exerciseName) {
        // You can implement modification logic here
        // For example, navigate to a modification page or show a dialog
      }
    }
  }

  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Zid Exercice"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: exerciseNameController,
                  ),
                  TextField(controller: weightController),
                  TextField(controller: repsController),
                  TextField(controller: setsController),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: Text("save"),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: Text("cancel"),
                ),
              ],
            ));
  }

  void save() {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    Provider.of<workoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<workoutData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(title: Text(widget.workoutName)),
              floatingActionButton: FloatingActionButton(
                onPressed: createNewExercise,
                child: Icon(Icons.add),
              ),
              body: ListView.builder(
                  itemCount:
                      value.numberOfExercisesInWorkout(widget.workoutName),
                  itemBuilder: (context, index) => ExerciseTile(
                      exerciseName: value
                          .getReleventWorkout(widget.workoutName)
                          .exercises[index]
                          .name,
                      weight: value
                          .getReleventWorkout(widget.workoutName)
                          .exercises[index]
                          .weight,
                      reps: value
                          .getReleventWorkout(widget.workoutName)
                          .exercises[index]
                          .reps,
                      sets: value
                          .getReleventWorkout(widget.workoutName)
                          .exercises[index]
                          .sets,
                      isCompleted: value
                          .getReleventWorkout(widget.workoutName)
                          .exercises[index]
                          .isCompleted,
                      onCheckBoxChanged: (val) => onCheckBoxChanged(
                          widget.workoutName,
                          value
                              .getReleventWorkout(widget.workoutName)
                              .exercises[index]
                              .name))),
            ));
  }
}
