import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class LoadingMessages extends StatefulWidget {
  @override
  _LoadingMessagesState createState() => _LoadingMessagesState();
}

class _LoadingMessagesState extends State<LoadingMessages> {
  final List<String> _messages = [
    "Finding your motivation...",
    "Convincing you it's leg day.",
    "Pretending warm-up sets count.",
    "Looking for your missing gym towel.",
    "Untangling headphone wires...",
    "Hydration level: suspicious.",
    "Scanning for pre-workout.",
    "Calculating ego lift...",
    "Spotter not found.",
    "Bench reserved by someone texting.",
    "Progressive overload activated.",
    "Adding 2.5kg because you survived.",
    "Counting reps honestly.",
    "Removing imaginary reps...",
    "Checking form... maybe.",
    "Loading muscle memory.",
    "Rest timer is watching you.",
    "Stretching your excuses.",
    "Your future self says thanks.",
    "Mobility isn't optional.",
    "Unlocking tomorrow's soreness.",
  ];

  final List<String> _easterEggs = [
    "PR incoming...",
    "Don't skip calves.",
    "Nice hoodie. Lift now.",
    "Remember: Full ROM.",
    "Touch grass... after the workout.",
  ];

  late String _currentMessage;
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _currentMessage = _getRandomMessage();
    _timer = Timer.periodic(const Duration(milliseconds: 850), (timer) {
      setState(() {
        _currentMessage = _getRandomMessage();
      });
    });
  }

  String _getRandomMessage() {
    bool isEasterEgg = _random.nextInt(100) < 5; // 5% chance
    String newMessage;
    do {
      if (isEasterEgg) {
        newMessage = _easterEggs[_random.nextInt(_easterEggs.length)];
      } else {
        newMessage = _messages[_random.nextInt(_messages.length)];
      }
    } while (newMessage == _currentMessage && _messages.length > 1);
    
    return newMessage;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        _currentMessage,
        key: ValueKey<String>(_currentMessage),
        style: const TextStyle(
          color: Color(0xFFA0A0A0),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        semanticsLabel: _currentMessage, // Accessibility
      ),
    );
  }
}
