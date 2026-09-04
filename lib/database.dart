import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> initializeOfflinePersistence() async {
    try {
      db.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      if (kDebugMode) {
        print("Firestore offline persistence strictly enabled.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error setting persistence (might already be set): $e");
      }
    }
  }
}
