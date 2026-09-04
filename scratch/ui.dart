import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// AMOLED Colors
const Color amoledBlack = Color(0xFF000000);
const Color surfaceColor = Color(0xFF111111);
const Color accentColor = Color(0xFF007AFF);
const Color textPrimary = Color(0xFFFFFFFF);
const Color textSecondary = Color(0xFF8E8E93);

class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadius? borderRadius;

  const BouncyButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = Colors.transparent,
    this.borderRadius,
  }) : super(key: key);

  @override
  _BouncyButtonState createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Using a spring simulation internally or easeOut for responsive feedback
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      reverseDuration: const Duration(milliseconds: 160),
    );
    // scale(0.97) as per Emil's design engineering spec
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    HapticFeedback.lightImpact(); // Multi-modal feedback
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class FrictionlessKeypad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onLogSet;

  const FrictionlessKeypad({
    Key? key,
    required this.onKeyPressed,
    required this.onLogSet,
  }) : super(key: key);

  Widget _buildKey(String label, BuildContext context, {bool isPrimary = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Semantics(
          label: isPrimary ? 'Log set' : 'Keypad $label',
          button: true,
          child: BouncyButton(
            onTap: () {
              if (isPrimary) {
                onLogSet();
              } else {
                onKeyPressed(label);
              }
            },
            backgroundColor: isPrimary ? accentColor : const Color(0xFF222222),
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : Colors.white,
                  letterSpacing: -0.02 * 24, // optical sizing tracking
                ),
                textScaler: TextScaler.noScaling,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 48x48dp minimum touch targets satisfied by padding + constraints
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [_buildKey('1', context), _buildKey('2', context), _buildKey('3', context)]),
        Row(children: [_buildKey('4', context), _buildKey('5', context), _buildKey('6', context)]),
        Row(children: [_buildKey('7', context), _buildKey('8', context), _buildKey('9', context)]),
        Row(children: [_buildKey('.', context), _buildKey('0', context), _buildKey('LOG', context, isPrimary: true)]),
      ],
    );
  }
}

class AmoledLoggingScreen extends StatefulWidget {
  @override
  _AmoledLoggingScreenState createState() => _AmoledLoggingScreenState();
}

class _AmoledLoggingScreenState extends State<AmoledLoggingScreen> {
  void _openDataEntrySheet(BuildContext context) {
    // Fluid bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            top: 24,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),
              // Simulated Inputs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Text('Weight (kg)', style: TextStyle(color: textSecondary, fontSize: 14)),
                      SizedBox(height: 8),
                      Text('100.0', style: TextStyle(color: textPrimary, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: -1.0)),
                    ],
                  ),
                  Container(width: 1, height: 60, color: Colors.white12),
                  Column(
                    children: const [
                      Text('Reps', style: TextStyle(color: textSecondary, fontSize: 14)),
                      SizedBox(height: 8),
                      Text('8', style: TextStyle(color: textPrimary, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: -1.0)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              FrictionlessKeypad(
                onKeyPressed: (key) {},
                onLogSet: () {
                  Navigator.pop(context);
                  // Trigger rest timer
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: amoledBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bench Press',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.64,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chest + Shoulders (Volume)',
                style: TextStyle(color: textSecondary, fontSize: 16),
              ),
              const Spacer(),
              Semantics(
                label: 'Log set 1 of Bench Press',
                child: BouncyButton(
                  onTap: () => _openDataEntrySheet(context),
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: const Center(
                    child: Text(
                      'Log Set 1',
                      style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
