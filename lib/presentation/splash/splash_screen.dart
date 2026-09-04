import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../providers/app_initialization_provider.dart';
import 'animated_logo.dart';
import 'loading_messages.dart';
import 'barbell_loader.dart';
import 'heartbeat_painter.dart';
import '../../ui.dart'; // To access DashboardScreen
import '../../main.dart'; // To access AppTheme

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appInitializationProvider.notifier).initializeApp();
    });
  }

  void _triggerSuccessTransition() async {
    if (_isTransitioning) return;
    _isTransitioning = true;
    HapticFeedback.lightImpact();
    
    // Simulate short confetti logic delay
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<InitStage>(appInitializationProvider, (previous, next) {
      if (next == InitStage.complete && !_isTransitioning) {
        _triggerSuccessTransition();
      }
    });

    final initStage = ref.watch(appInitializationProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedLogo(),
                const SizedBox(height: 48),
                SizedBox(
                  height: 40,
                  child: initStage == InitStage.starting
                      ? HeartbeatLoader()
                      : BarbellLoader(),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 24,
                  child: LoadingMessages(),
                ),
                const SizedBox(height: 32),
                _buildProgressList(initStage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressList(InitStage stage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressItem(label: "Loading Workout Split", isActive: stage.index >= InitStage.loadingWorkoutSplit.index, isComplete: stage.index > InitStage.loadingWorkoutSplit.index),
          const SizedBox(height: 8),
          _ProgressItem(label: "Syncing Exercise Library", isActive: stage.index >= InitStage.syncingLibrary.index, isComplete: stage.index > InitStage.syncingLibrary.index),
          const SizedBox(height: 8),
          _ProgressItem(label: "Restoring Last Session", isActive: stage.index >= InitStage.restoringSession.index, isComplete: stage.index > InitStage.restoringSession.index),
          const SizedBox(height: 8),
          _ProgressItem(label: "Preparing Engine", isActive: stage.index >= InitStage.preparingEngine.index, isComplete: stage.index > InitStage.preparingEngine.index),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isComplete;

  const _ProgressItem({
    required this.label,
    required this.isActive,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActive ? 1.0 : 0.0,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isComplete ? AppTheme.primaryAccent : Colors.transparent,
              border: Border.all(
                color: isComplete ? AppTheme.primaryAccent : AppTheme.secondaryAccent,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: isComplete
                ? const Icon(Icons.check, size: 12, color: Colors.black)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isComplete ? Colors.white : AppTheme.secondaryAccent,
              fontSize: 12,
              fontWeight: isComplete ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
