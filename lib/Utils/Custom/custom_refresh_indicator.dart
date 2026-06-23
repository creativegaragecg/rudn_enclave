import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../Utils/Constants/colors.dart';

/// Drop-in pull-to-refresh wrapper with a custom animated spinner.
/// Shows 3 orbiting dots around a refresh icon while loading.
class AppRefreshIndicator extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  /// Spinner color. Defaults to [AppColors.accent].
  final Color? color;

  const AppRefreshIndicator({
    Key? key,
    required this.onRefresh,
    required this.child,
    this.color,
  }) : super(key: key);

  @override
  State<AppRefreshIndicator> createState() => _AppRefreshIndicatorState();
}

class _AppRefreshIndicatorState extends State<AppRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _rotateController.repeat();
    await widget.onRefresh();
    // Finish the current rotation gracefully before stopping
    await _rotateController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    _rotateController.reset();
    _rotateController.stop();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.accent;

    return RefreshIndicator(
      // Hide the built-in indicator — we draw our own
      color: AppColors.darkBlueCardColor,
      backgroundColor: Colors.white,
      strokeWidth: 0,
      displacement: 72,
      onRefresh: _handleRefresh,
      notificationPredicate: (n) => n.depth == 0,
      child: Stack(
        children: [
          widget.child,
          // Custom badge floats at the top-center during refresh
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _rotateController,
              builder: (_, __) {
                if (!_rotateController.isAnimating) {
                  return const SizedBox.shrink();
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Container()
                    /*_SpinnerBadge(
                      color: color,
                      progress: _rotateController.value,
                    )*/,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal — no need to use these directly
// ─────────────────────────────────────────────────────────────────────────────

class _SpinnerBadge extends StatelessWidget {
  final Color color;
  final double progress;

  const _SpinnerBadge({required this.color, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _OrbitPainter(progress: progress, color: color),
        child: Center(
          child: Icon(
            Icons.refresh_rounded,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// Draws 3 dots orbiting a circle, each 120° apart, with chasing opacity.
class _OrbitPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0
  final Color color;

  const _OrbitPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final orbitRadius = size.width / 2 - 6;
    const dotRadius = 4.0;
    const count = 3;

    for (int i = 0; i < count; i++) {
      final angle = (progress + i / count) * 2 * math.pi;
      final opacity = 0.25 + 0.75 * (1 - ((progress + i / count) % 1.0));
      final paint = Paint()
        ..color = color.withOpacity(opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      final pos = Offset(
        center.dx + orbitRadius * math.cos(angle),
        center.dy + orbitRadius * math.sin(angle),
      );
      canvas.drawCircle(pos, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.progress != progress || old.color != color;
}