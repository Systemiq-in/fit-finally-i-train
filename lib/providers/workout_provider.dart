import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyWorkout {
  final String title;
  final String subtitle;
  final String focus;
  final int exerciseCount;
  final int estimatedMins;

  const DailyWorkout({
    required this.title,
    required this.subtitle,
    required this.focus,
    required this.exerciseCount,
    required this.estimatedMins,
  });
}

final scheduleProvider = Provider<Map<int, DailyWorkout>>((ref) {
  // Monday = 1, Sunday = 7
  return {
    1: const DailyWorkout(
      title: "Chest & Shoulders",
      subtitle: "Hypertrophy Volume",
      focus: "PUSH DAY",
      exerciseCount: 6,
      estimatedMins: 55,
    ),
    2: const DailyWorkout(
      title: "Back & Biceps",
      subtitle: "Hypertrophy Volume",
      focus: "PULL DAY",
      exerciseCount: 6,
      estimatedMins: 55,
    ),
    3: const DailyWorkout(
      title: "Triceps & Rear Delts",
      subtitle: "Accessory Focus",
      focus: "ARMS DAY",
      exerciseCount: 5,
      estimatedMins: 45,
    ),
    4: const DailyWorkout(
      title: "Chest & Shoulders",
      subtitle: "Heavy Strength",
      focus: "PUSH DAY",
      exerciseCount: 5,
      estimatedMins: 60,
    ),
    5: const DailyWorkout(
      title: "Back & Biceps",
      subtitle: "Heavy Strength",
      focus: "PULL DAY",
      exerciseCount: 5,
      estimatedMins: 60,
    ),
    6: const DailyWorkout(
      title: "Legs & Core",
      subtitle: "Lower Body Power",
      focus: "LEG DAY",
      exerciseCount: 7,
      estimatedMins: 70,
    ),
    7: const DailyWorkout(
      title: "Active Recovery",
      subtitle: "Stretching & Mobility",
      focus: "REST DAY",
      exerciseCount: 4,
      estimatedMins: 30,
    ),
  };
});

final todayWorkoutProvider = Provider<DailyWorkout>((ref) {
  final schedule = ref.watch(scheduleProvider);
  final weekday = DateTime.now().weekday; // 1-7
  return schedule[weekday] ?? schedule[1]!;
});
