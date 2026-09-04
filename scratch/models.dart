import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MuscleGroup { chest, back, shoulders, biceps, triceps, legs, core }

class Exercise {
  final String id;
  final String name;
  final MuscleGroup targetMuscleGroup;
  final List<MuscleGroup> synergists;
  final String instructions;
  final String? mediaUrl;
  final bool isCompound;

  const Exercise({
    required this.id,
    required this.name,
    required this.targetMuscleGroup,
    required this.synergists,
    required this.instructions,
    this.mediaUrl,
    required this.isCompound,
  });
}

class SetRecord {
  final double weight;
  final int reps;
  final int? rpe;

  const SetRecord({
    required this.weight,
    required this.reps,
    this.rpe,
  });
}

class WorkoutSession {
  final String id;
  final String routineId;
  final DateTime date;
  final Map<String, List<SetRecord>> exerciseSets; // exerciseId -> sets

  const WorkoutSession({
    required this.id,
    required this.routineId,
    required this.date,
    required this.exerciseSets,
  });
}

// Progressive Overload Logic
class OverloadConfig {
  final int targetMinReps;
  final int targetMaxReps;
  final int targetSets;

  const OverloadConfig({
    required this.targetMinReps,
    required this.targetMaxReps,
    required this.targetSets,
  });
}

class ProgressiveOverloadEngine {
  static double calculateE1RM(double weight, int reps) {
    if (reps == 0) return 0;
    return weight * (1 + (reps / 30));
  }

  static bool shouldIncreaseLoad(List<SetRecord> loggedSets, OverloadConfig config) {
    if (loggedSets.length < config.targetSets) return false;
    // Check if ALL working sets hit the max reps of the range
    for (int i = 0; i < config.targetSets; i++) {
      if (loggedSets[i].reps < config.targetMaxReps) {
        return false;
      }
    }
    return true;
  }

  static double calculateNextWeight(double currentWeight) {
    // Increase weight by 2.5%
    return double.parse((currentWeight * 1.025).toStringAsFixed(1));
  }
}
