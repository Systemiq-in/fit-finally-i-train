import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart'; // for AppTheme

class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;

  const BouncyButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = Colors.transparent,
    this.borderRadius,
    this.border,
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      reverseDuration: const Duration(milliseconds: 160),
    );
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
            border: widget.border,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ==========================================
// A. Home Screen (Dashboard & Split Hub)
// ==========================================
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBase,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundBase,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.surfaceElevation3,
              child: const Icon(Icons.person, color: AppTheme.textPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            const Text("Friday, Sep 4", style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.fitness_center, color: AppTheme.primaryAccent),
            splashRadius: 24,
            tooltip: 'MuscleWiki',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: AppTheme.textSecondary),
            splashRadius: 24,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "F.I.T. – Finally I Train",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              _buildWeeklyCarousel(),
              const SizedBox(height: 32),
              _buildHeroCard(context),
              const SizedBox(height: 32),
              _buildRecoveryMatrix(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyCarousel() {
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final isToday = index == 4; // FRI
          return Container(
            width: 72,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevation1,
              borderRadius: BorderRadius.circular(999), // pill shape
              border: Border.all(
                color: isToday ? AppTheme.primaryAccent : AppTheme.borders,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    color: isToday ? AppTheme.textPrimary : AppTheme.textSecondary,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                if (isToday) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevation1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borders),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Back + Biceps [FRI]", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text("70–80 min", style: TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.secondaryAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "Strength Focus - Heavier / Lower Reps",
              style: TextStyle(color: AppTheme.secondaryAccent, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 24),
          const Text("• Conventional Deadlift 4×5\n• Weighted Pull-ups 4×5–6\n• EZ Bar Curl 4×6–8",
              style: TextStyle(color: AppTheme.textSecondary, height: 1.6)),
          const SizedBox(height: 24),
          BouncyButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AmoledLoggingScreen()),
              );
            },
            backgroundColor: AppTheme.primaryAccent,
            borderRadius: BorderRadius.circular(999),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Center(
              child: Text("START WORKOUT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryMatrix() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevation1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borders),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Muscle Frequency", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildMatrixRow("Chest", 0.8),
          _buildMatrixRow("Back", 0.9),
          _buildMatrixRow("Biceps", 0.6),
        ],
      ),
    );
  }

  Widget _buildMatrixRow(String muscle, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(muscle, style: const TextStyle(color: AppTheme.textSecondary))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppTheme.surfaceElevation3,
                color: AppTheme.primaryAccent,
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// B. Active Workout Logger Screen
// ==========================================
class AmoledLoggingScreen extends StatefulWidget {
  @override
  _AmoledLoggingScreenState createState() => _AmoledLoggingScreenState();
}

class _AmoledLoggingScreenState extends State<AmoledLoggingScreen> {
  // Mock Data
  bool set1Completed = false;
  bool isEditing = false;
  double currentWeight = 140.0;
  int currentReps = 5;

  void _openDataEntrySheet(BuildContext context) {
    setState(() { isEditing = true; });
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceElevation2,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FrictionlessKeypad(
          onKeyPressed: (key) {},
          onLogSet: () {
            Navigator.pop(context);
            setState(() {
              set1Completed = true;
              isEditing = false;
            });
            // Show Timer Pill
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Rest Timer: 120s started'),
                backgroundColor: AppTheme.secondaryAccent,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() { isEditing = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBase,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundBase,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Back + Biceps — Strength", style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
            Text("00:45:12", style: TextStyle(color: AppTheme.secondaryAccent, fontSize: 18, fontFeatures: [FontFeature.tabularFigures()])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Finish", style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold)),
          ),
          IconButton(icon: const Icon(Icons.keyboard_arrow_down), onPressed: () => Navigator.pop(context)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildExerciseCard(),
          ],
        ),
      ),
      floatingActionButton: set1Completed ? _buildRestTimerPill() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildRestTimerPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevation3,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.borders),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(value: 0.7, strokeWidth: 2, color: AppTheme.secondaryAccent),
          ),
          const SizedBox(width: 12),
          const Text("01:23", style: TextStyle(color: AppTheme.secondaryAccent, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 12),
          BouncyButton(
            onTap: () {},
            backgroundColor: AppTheme.surfaceElevation1,
            borderRadius: BorderRadius.circular(999),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: const Text("+30s", style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 8),
          BouncyButton(
            onTap: () => setState(() => set1Completed = false), // Mock skip
            backgroundColor: AppTheme.surfaceElevation1,
            borderRadius: BorderRadius.circular(999),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: const Text("Skip", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevation1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borders),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progressive Overload Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text("⚡ ", style: TextStyle(fontSize: 14)),
                const Expanded(
                  child: Text(
                    "Target met last week! Increase to 142.5 kg (+1.25kg)",
                    style: TextStyle(color: AppTheme.success, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Conventional Deadlift", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Brace hard, drive through floor", style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                ],
              ),
              IconButton(icon: const Icon(Icons.info_outline, color: AppTheme.textSecondary), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 24),
          // Header Row
          Row(
            children: const [
              SizedBox(width: 40, child: Text("SET", style: TextStyle(color: AppTheme.textTertiary, fontSize: 12))),
              Expanded(child: Text("PREVIOUS", style: TextStyle(color: AppTheme.textTertiary, fontSize: 12))),
              SizedBox(width: 80, child: Text("KG", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textTertiary, fontSize: 12))),
              SizedBox(width: 60, child: Text("REPS", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textTertiary, fontSize: 12))),
              SizedBox(width: 48, child: Icon(Icons.check, size: 16, color: AppTheme.textTertiary)),
            ],
          ),
          const SizedBox(height: 8),
          // Set Row
          GestureDetector(
            onTap: () => _openDataEntrySheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: set1Completed ? const Color(0xFF162010) : (isEditing ? AppTheme.surfaceElevation3 : Colors.transparent),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isEditing ? AppTheme.secondaryAccent : (set1Completed ? AppTheme.success : AppTheme.borders),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 40, child: Center(child: Text("1", style: TextStyle(fontWeight: FontWeight.bold)))),
                  const Expanded(child: Text("140 kg × 5", style: TextStyle(color: AppTheme.textSecondary))),
                  SizedBox(
                    width: 80,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevation2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("$currentWeight", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 52,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevation2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("$currentReps", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: set1Completed ? AppTheme.primaryAccent : AppTheme.surfaceElevation2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.check, color: set1Completed ? Colors.black : AppTheme.textTertiary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// Frictionless Keypad
// ==========================================
class FrictionlessKeypad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onLogSet;

  const FrictionlessKeypad({
    Key? key,
    required this.onKeyPressed,
    required this.onLogSet,
  }) : super(key: key);

  Widget _buildPill(String label) {
    return BouncyButton(
      onTap: () {},
      backgroundColor: AppTheme.surfaceElevation3,
      borderRadius: BorderRadius.circular(999),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildKey(String label, BuildContext context, {bool isAction = false, Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Semantics(
          label: isAction ? label : 'Key $label',
          button: true,
          child: BouncyButton(
            onTap: () => isAction ? onLogSet() : onKeyPressed(label),
            backgroundColor: color ?? AppTheme.surfaceElevation3,
            borderRadius: BorderRadius.circular(10),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: color != null ? Colors.black : AppTheme.textPrimary,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPill("+1.25"),
              _buildPill("+2.5"),
              _buildPill("+5"),
              _buildPill("+10"),
            ],
          ),
          const SizedBox(height: 16),
          Row(children: [_buildKey('1', context), _buildKey('2', context), _buildKey('3', context)]),
          Row(children: [_buildKey('4', context), _buildKey('5', context), _buildKey('6', context)]),
          Row(children: [_buildKey('7', context), _buildKey('8', context), _buildKey('9', context)]),
          Row(children: [_buildKey('.', context), _buildKey('0', context), _buildKey('Next', context, isAction: true, color: AppTheme.primaryAccent)]),
        ],
      ),
    );
  }
}
