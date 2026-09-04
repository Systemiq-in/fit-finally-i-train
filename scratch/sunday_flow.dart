import 'package:flutter/material.dart';

// Phase 4: Sunday (Rest + Stretch) Stories Flow UI
class SundayRecoveryFlow extends StatefulWidget {
  @override
  _SundayRecoveryFlowState createState() => _SundayRecoveryFlowState();
}

class _SundayRecoveryFlowState extends State<SundayRecoveryFlow> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _timerController;

  final List<Map<String, String>> _poses = [
    {
      'title': "Child's Pose",
      'duration': '60',
      'instruction': 'Knees wide, toes together, reach arms forward and breathe into your lower back.'
    },
    {
      'title': 'Pigeon Pose (Left)',
      'duration': '60',
      'instruction': 'Left knee to left wrist, right leg straight back. Sink your hips.'
    },
    {
      'title': 'Pigeon Pose (Right)',
      'duration': '60',
      'instruction': 'Right knee to right wrist, left leg straight back. Sink your hips.'
    },
    {
      'title': 'Diaphragmatic Breathing',
      'duration': '300', // 5 minutes
      'instruction': 'Breathe in for 4s, hold for 4s, exhale for 4s, hold for 4s.'
    },
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimerForCurrentPose();
  }

  void _startTimerForCurrentPose() {
    int duration = int.parse(_poses[_currentIndex]['duration']!);
    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: duration),
    );
    _timerController.forward();
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_currentIndex < _poses.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        } else {
          Navigator.pop(context); // End flow
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _timerController.dispose();
    _startTimerForCurrentPose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // AMOLED Black
      body: SafeArea(
        child: Column(
          children: [
            // Stories-style progress bars
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: List.generate(_poses.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: _buildProgressBar(index),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _poses.length,
                itemBuilder: (context, index) {
                  return _buildPoseCard(_poses[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int index) {
    if (index < _currentIndex) {
      return Container(height: 4, color: Colors.white);
    } else if (index == _currentIndex) {
      return AnimatedBuilder(
        animation: _timerController,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: _timerController.value,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          );
        },
      );
    } else {
      return Container(height: 4, color: Colors.white24);
    }
  }

  Widget _buildPoseCard(Map<String, String> pose) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for visual
          Container(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Center(
              child: Icon(Icons.accessibility_new, size: 120, color: Colors.white24),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            pose['title']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            pose['instruction']!,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 18,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          // Countdown Timer Visual
          AnimatedBuilder(
            animation: _timerController,
            builder: (context, child) {
              int remaining = int.parse(pose['duration']!) - (_timerController.value * int.parse(pose['duration']!)).floor();
              return Text(
                '${remaining}s',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textScaler: TextScaler.noScaling,
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
