import 'package:flutter_riverpod/flutter_riverpod.dart';

enum InitStage {
  starting,
  loadingWorkoutSplit,
  syncingLibrary,
  restoringSession,
  preparingEngine,
  calibratingTimers,
  complete,
}

class AppInitializationNotifier extends Notifier<InitStage> {
  @override
  InitStage build() {
    return InitStage.starting;
  }

  Future<void> initializeApp() async {
    // Simulated sequence of loading
    await Future.delayed(const Duration(milliseconds: 800));
    state = InitStage.loadingWorkoutSplit;
    
    await Future.delayed(const Duration(milliseconds: 600));
    state = InitStage.syncingLibrary;
    
    await Future.delayed(const Duration(milliseconds: 500));
    state = InitStage.restoringSession;
    
    await Future.delayed(const Duration(milliseconds: 500));
    state = InitStage.preparingEngine;
    
    await Future.delayed(const Duration(milliseconds: 400));
    state = InitStage.calibratingTimers;
    
    await Future.delayed(const Duration(milliseconds: 400));
    state = InitStage.complete;
  }
}

final appInitializationProvider = NotifierProvider<AppInitializationNotifier, InitStage>(() {
  return AppInitializationNotifier();
});
