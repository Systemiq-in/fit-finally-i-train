import 'providers/workout_provider.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart'; // Access AppTheme

// ==========================================
// Emil Kowalski-style Bouncy Physics
// ==========================================
class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;

  const BouncyButton({
    super.key,
    required this.child,
    required this.onTap,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = Colors.transparent,
    this.borderRadius,
    this.border,
  });

  @override
  _BouncyButtonState createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Ultra-snappy duration for immediate tactile feedback
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.elasticOut, // Apple-style spring-back
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    HapticFeedback.lightImpact();
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
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
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
            border: widget.border,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ==========================================
// Dashboard Screen (Completely Rewritten)
// ==========================================
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // True AMOLED Black
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "F.I.T.",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "FINALLY I TRAIN",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                            color: AppTheme.primaryAccent,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: AppTheme.surfaceElevation2,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 20),
                    )
                  ],
                ),
              ),
            ),

            // Weekly Carousel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 80,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final isToday = index == 2;
                    return Container(
                      width: 64,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isToday ? AppTheme.primaryAccent : AppTheme.surfaceElevation1,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ['M','T','W','T','F','S','S'][index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isToday ? Colors.black : AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${index + 12}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFeatures: const [FontFeature.tabularFigures()],
                              color: isToday ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),


// Hero Card
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, ref, _) {
                  final todayWorkout = ref.watch(todayWorkoutProvider);
                  
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                    child: BouncyButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (_, __, ___) => const AmoledLoggingScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutExpo,
                                )),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      backgroundColor: AppTheme.surfaceElevation1,
                      borderRadius: BorderRadius.circular(24),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  todayWorkout.focus,
                                  style: const TextStyle(color: AppTheme.primaryAccent, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.0),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, color: AppTheme.textSecondary, size: 14),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            todayWorkout.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            todayWorkout.subtitle,
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "\${todayWorkout.exerciseCount} exercises • \${todayWorkout.estimatedMins} mins",
                            style: TextStyle(color: AppTheme.textTertiary, fontSize: 14),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "START WORKOUT",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 1.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// Frictionless Keypad (iOS Calculator Style)
// ==========================================
class FrictionlessKeypad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onLogSet;

  const FrictionlessKeypad({
    super.key,
    required this.onKeyPressed,
    required this.onLogSet,
  });

  Widget _buildKey(String label, {bool isAction = false, Color? bgColor, Color? textColor, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: BouncyButton(
          onTap: () => isAction ? onLogSet() : onKeyPressed(label),
          backgroundColor: bgColor ?? const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isAction ? 20 : 28,
                fontWeight: isAction ? FontWeight.bold : FontWeight.w500,
                color: textColor ?? Colors.white,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMicroPlate(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: BouncyButton(
          onTap: () => onKeyPressed(label),
          backgroundColor: AppTheme.secondaryAccent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
        left: 12,
        right: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildMicroPlate("+1.25"),
              _buildMicroPlate("+2.5"),
              _buildMicroPlate("+5"),
              _buildMicroPlate("+10"),
            ],
          ),
          const SizedBox(height: 12),
          Row(children: [_buildKey('1'), _buildKey('2'), _buildKey('3')]),
          Row(children: [_buildKey('4'), _buildKey('5'), _buildKey('6')]),
          Row(children: [_buildKey('7'), _buildKey('8'), _buildKey('9')]),
          Row(
            children: [
              _buildKey('.'),
              _buildKey('0'),
              _buildKey('NEXT', isAction: true, bgColor: AppTheme.primaryAccent, textColor: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// AMOLED Active Logging Screen
// ==========================================
class AmoledLoggingScreen extends StatefulWidget {
  const AmoledLoggingScreen({super.key});
  @override
  _AmoledLoggingScreenState createState() => _AmoledLoggingScreenState();
}

enum InputFocus { weight, reps, none }

class _AmoledLoggingScreenState extends State<AmoledLoggingScreen> {
  bool set1Completed = false;
  String currentWeight = "140";
  String currentReps = "5";
  InputFocus activeFocus = InputFocus.none;
  
  // Rest Timer State
  bool isResting = false;
  int restTimeRemaining = 90; // 1m 30s
  
  void _startRestTimer() {
    setState(() {
      isResting = true;
      restTimeRemaining = 90;
    });
    _tickRestTimer();
  }

  void _tickRestTimer() {
    if (!isResting) return;
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || !isResting) return;
      setState(() {
        if (restTimeRemaining > 0) {
          restTimeRemaining--;
          _tickRestTimer();
        } else {
          isResting = false;
          HapticFeedback.heavyImpact(); // Timer done
        }
      });
    });
  }

  void _handleKeyPress(String val) {
    HapticFeedback.selectionClick();
    setState(() {
      if (val.startsWith("+")) {
        // Handle Micro-plates mathematically
        if (activeFocus == InputFocus.weight) {
          double cw = double.tryParse(currentWeight) ?? 0;
          double add = double.tryParse(val.replaceAll("+", "")) ?? 0;
          currentWeight = (cw + add).toString().replaceAll(RegExp(r'\.0\$'), '');
        }
      } else {
        // Handle standard numeric input
        if (activeFocus == InputFocus.weight) {
          if (currentWeight == "0" || currentWeight == "140") currentWeight = "";
          currentWeight += val;
        } else if (activeFocus == InputFocus.reps) {
          if (currentReps == "0" || currentReps == "5") currentReps = "";
          currentReps += val;
        }
      }
    });
  }

  void _openDataEntrySheet(InputFocus initialFocus) {
    HapticFeedback.mediumImpact();
    setState(() {
      activeFocus = initialFocus;
      set1Completed = false; // Uncheck if editing
      isResting = false; // Stop timer if editing
    });
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      barrierColor: Colors.transparent, // Allow seeing the row highlight
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => FrictionlessKeypad(
          onKeyPressed: (val) {
            _handleKeyPress(val);
          },
          onLogSet: () {
            HapticFeedback.heavyImpact();
            if (activeFocus == InputFocus.weight) {
              // Move to reps
              setState(() => activeFocus = InputFocus.reps);
            } else {
              // Complete set
              setState(() {
                activeFocus = InputFocus.none;
                set1Completed = true;
              });
              Navigator.pop(context); // Close sheet
              _startRestTimer(); // Trigger Rest Timer feature
            }
          },
        )
      ),
    ).whenComplete(() {
      if (mounted) setState(() => activeFocus = InputFocus.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = "\${(restTimeRemaining ~/ 60)}:\${(restTimeRemaining % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "PULL DAY",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Exercise Header
                  Text(
                    "Conventional Deadlift",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Brace hard, drive through floor",
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  
                  // Labels Row
                  Row(
                    children: const [
                      SizedBox(width: 32, child: Text("SET", style: TextStyle(color: AppTheme.textTertiary, fontSize: 12, fontWeight: FontWeight.bold))),
                      Expanded(child: Text("PREVIOUS", style: TextStyle(color: AppTheme.textTertiary, fontSize: 12, fontWeight: FontWeight.bold))),
                      SizedBox(width: 70, child: Text("KG", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textTertiary, fontSize: 12, fontWeight: FontWeight.bold))),
                      SizedBox(width: 60, child: Text("REPS", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textTertiary, fontSize: 12, fontWeight: FontWeight.bold))),
                      SizedBox(width: 48, child: Icon(Icons.check, size: 16, color: AppTheme.textTertiary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Interactive Set Row
                  BouncyButton(
                    onTap: () => _openDataEntrySheet(InputFocus.weight),
                    backgroundColor: set1Completed ? AppTheme.success.withValues(alpha: 0.1) : AppTheme.surfaceElevation1,
                    border: Border.all(
                      color: activeFocus != InputFocus.none ? AppTheme.secondaryAccent : (set1Completed ? AppTheme.success.withValues(alpha: 0.3) : Colors.transparent),
                      width: activeFocus != InputFocus.none ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 24, 
                          child: Center(
                            child: Text("1", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "140 kg × 5", 
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Weight Field
                        GestureDetector(
                          onTap: () {
                            if (activeFocus != InputFocus.none) setState(() => activeFocus = InputFocus.weight);
                          },
                          child: Container(
                            width: 70,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: activeFocus == InputFocus.weight ? AppTheme.secondaryAccent.withValues(alpha: 0.2) : (set1Completed ? Colors.transparent : AppTheme.surfaceElevation2),
                              border: Border.all(color: activeFocus == InputFocus.weight ? AppTheme.secondaryAccent : Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentWeight, 
                              textAlign: TextAlign.center, 
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 18, 
                                color: activeFocus == InputFocus.weight ? AppTheme.secondaryAccent : (set1Completed ? AppTheme.success : Colors.white),
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Reps Field
                        GestureDetector(
                          onTap: () {
                            if (activeFocus != InputFocus.none) setState(() => activeFocus = InputFocus.reps);
                          },
                          child: Container(
                            width: 52,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: activeFocus == InputFocus.reps ? AppTheme.secondaryAccent.withValues(alpha: 0.2) : (set1Completed ? Colors.transparent : AppTheme.surfaceElevation2),
                              border: Border.all(color: activeFocus == InputFocus.reps ? AppTheme.secondaryAccent : Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentReps, 
                              textAlign: TextAlign.center, 
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 18, 
                                color: activeFocus == InputFocus.reps ? AppTheme.secondaryAccent : (set1Completed ? AppTheme.success : Colors.white),
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Check Button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: set1Completed ? AppTheme.success : AppTheme.surfaceElevation2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.check, 
                            color: set1Completed ? Colors.black : AppTheme.textTertiary, 
                            size: 20
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Rest Timer UI (Dynamic Feature)
                  if (isResting)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.secondaryAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined, color: AppTheme.secondaryAccent),
                                const SizedBox(width: 12),
                                Text(
                                  "Rest Timer",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                color: AppTheme.secondaryAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Finish Workout Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.surfaceElevation1,
                border: Border(top: BorderSide(color: AppTheme.borders)),
              ),
              child: SafeArea(
                top: false,
                child: BouncyButton(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    Navigator.pop(context); // Go back to Dashboard
                  },
                  backgroundColor: AppTheme.primaryAccent,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
                    child: Text(
                      "FINISH WORKOUT",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

