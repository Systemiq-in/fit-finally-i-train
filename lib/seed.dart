import 'package:cloud_firestore/cloud_firestore.dart';
import 'database.dart';

class DataSeeder {
  static final FirebaseFirestore db = DatabaseService.db;

  static Future<void> seedInitialData(String userId) async {
    // We will use a batch to ensure atomic writes
    WriteBatch batch = db.batch();

    // 1. Seed Routine (7-day split)
    final routineRef = db.collection('routines').doc('default_split');
    batch.set(routineRef, {
      'name': '7-Day Hybrid Split',
      'ownerId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'schedule': {
        'MON': 'chest_shoulders_vol',
        'TUE': 'back_biceps_vol',
        'WED': 'triceps_rear_delts',
        'THU': 'chest_shoulders_str',
        'FRI': 'back_biceps_str',
        'SAT': 'legs_core',
        'SUN': 'rest_stretch'
      }
    });

    // 2. Define standard exercise references (MuscleWiki library simulation)
    // Note: Normally exercises live in a global 'exercises' collection. We'll just define the specific workouts here.

    final workoutsRef = routineRef.collection('workouts');

    // MON: Chest + Shoulders (Volume)
    batch.set(workoutsRef.doc('chest_shoulders_vol'), {
      'day': 'MON',
      'name': 'Chest + Shoulders (Volume)',
      'exercises': [
        {'name': 'Barbell Bench Press', 'sets': 4, 'repRange': '8-10'},
        {'name': 'Incline DB Press', 'sets': 3, 'repRange': '10-12'},
        {'name': 'Cable Fly', 'sets': 3, 'repRange': '12-15'},
        {'name': 'Overhead Press', 'sets': 3, 'repRange': '8-10'},
        {'name': 'Lateral Raises', 'sets': 4, 'repRange': '15-20'},
      ]
    });

    // TUE: Back + Biceps (Volume)
    batch.set(workoutsRef.doc('back_biceps_vol'), {
      'day': 'TUE',
      'name': 'Back + Biceps (Volume)',
      'exercises': [
        {'name': 'Pull-ups', 'sets': 4, 'repRange': '8-10'},
        {'name': 'Barbell Row', 'sets': 4, 'repRange': '8-10'},
        {'name': 'Cable Row', 'sets': 3, 'repRange': '10-12'},
        {'name': 'Barbell Curl', 'sets': 3, 'repRange': '10-12'},
        {'name': 'Hammer Curl', 'sets': 3, 'repRange': '10-12'},
      ]
    });

    // WED: Triceps + Rear Delts
    batch.set(workoutsRef.doc('triceps_rear_delts'), {
      'day': 'WED',
      'name': 'Triceps + Rear Delts',
      'exercises': [
        {'name': 'Close-grip Bench', 'sets': 4, 'repRange': '8-10'},
        {'name': 'Skull Crushers', 'sets': 3, 'repRange': '10-12'},
        {'name': 'Cable Pushdown', 'sets': 3, 'repRange': '12-15'},
        {'name': 'Rear Delt Fly', 'sets': 4, 'repRange': '15-20'},
        {'name': 'Meadows Row', 'sets': 3, 'repRange': '10-12'},
      ]
    });

    // THU: Chest + Shoulders (Strength)
    batch.set(workoutsRef.doc('chest_shoulders_str'), {
      'day': 'THU',
      'name': 'Chest + Shoulders (Strength)',
      'exercises': [
        {'name': 'Bench Press', 'sets': 5, 'repRange': '5'},
        {'name': 'Incline Barbell', 'sets': 4, 'repRange': '6-8'},
        {'name': 'Weighted Dips', 'sets': 3, 'repRange': '6-8'},
        {'name': 'Barbell OHP', 'sets': 4, 'repRange': '5-6'},
        {'name': 'Arnold Press', 'sets': 3, 'repRange': '8-10'},
      ]
    });

    // FRI: Back + Biceps (Strength)
    batch.set(workoutsRef.doc('back_biceps_str'), {
      'day': 'FRI',
      'name': 'Back + Biceps (Strength)',
      'exercises': [
        {'name': 'Conventional Deadlift', 'sets': 4, 'repRange': '5'},
        {'name': 'Weighted Pull-ups', 'sets': 4, 'repRange': '5-6'},
        {'name': 'DB Row', 'sets': 3, 'repRange': '6-8'},
        {'name': 'EZ Bar Curl', 'sets': 4, 'repRange': '6-8'},
      ]
    });

    // SAT: Legs + Core
    batch.set(workoutsRef.doc('legs_core'), {
      'day': 'SAT',
      'name': 'Legs + Core',
      'exercises': [
        {'name': 'Squat', 'sets': 4, 'repRange': '5-8'},
        {'name': 'RDL', 'sets': 3, 'repRange': '8-10'},
        {'name': 'Leg Press', 'sets': 3, 'repRange': '10-12'},
        {'name': 'Walking Lunges', 'sets': 3, 'repRange': '12-15'},
        {'name': 'Calf Raises', 'sets': 4, 'repRange': '15-20'},
        {'name': 'Hanging Leg Raises', 'sets': 3, 'repRange': 'Failure'},
      ]
    });

    // SUN: Rest + Stretch
    batch.set(workoutsRef.doc('rest_stretch'), {
      'day': 'SUN',
      'name': 'Rest + Stretch (Mobility)',
      'exercises': [
        {'name': "Child's Pose", 'sets': 1, 'repRange': '60s'},
        {'name': 'Pigeon Pose', 'sets': 2, 'repRange': '60s'},
        {'name': 'Diaphragmatic Breathing', 'sets': 1, 'repRange': '5 mins'},
      ]
    });

    // 3. User Document
    final userRef = db.collection('users').doc(userId);
    batch.set(userRef, {
      'activeRoutineId': 'default_split',
      'onboardingComplete': true,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Commit all operations
    await batch.commit();
    print("Successfully seeded 7-Day Split into Firestore.");
  }
}
