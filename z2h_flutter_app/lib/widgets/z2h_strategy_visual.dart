import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/z2h_theme.dart';
import 'z2h_logo.dart';

/// Pure wordless, transparent animated R&D visual art representing Z2H Innovations.
class Z2HStrategyVisual extends StatefulWidget {
  const Z2HStrategyVisual({super.key});

  @override
  State<Z2HStrategyVisual> createState() => _Z2HStrategyVisualState();
}

class _Z2HStrategyVisualState extends State<Z2HStrategyVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _orbitIcons = [
    (icon: Icons.psychology_rounded, color: Z2HColors.accentCyan, angleDeg: -135.0),
    (icon: Icons.devices_rounded, color: Z2HColors.accentIndigo, angleDeg: -45.0),
    (icon: Icons.cloud_done_rounded, color: Z2HColors.accentViolet, angleDeg: 45.0),
    (icon: Icons.rocket_launch_rounded, color: Z2HColors.accentEmerald, angleDeg: 135.0),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 380;
        final height = isCompact ? 280.0 : 360.0;
        final radius = isCompact ? 86.0 : 114.0;

        return RepaintBoundary(
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = _controller.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WordlessImaginationPainter(
                          progress: t,
                          radius: radius,
                          nodeAngles: _orbitIcons.map((e) => e.angleDeg).toList(),
                          nodeColors: _orbitIcons.map((e) => e.color).toList(),
                        ),
                      ),
                    ),

                    // Central transparent crystal Z2H core
                    Transform.scale(
                      scale: 1.0 + 0.05 * math.sin(t * 2 * math.pi),
                      child: Container(
                        width: isCompact ? 76 : 94,
                        height: isCompact ? 76 : 94,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Z2HColors.accentCyan.withOpacity(0.06),
                          border: Border.all(
                            color: Z2HColors.accentCyan.withOpacity(0.55),
                            width: 1.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Z2HColors.accentCyan.withOpacity(0.24),
                              blurRadius: 34,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Z2HLogoMark(
                          size: isCompact ? 48 : 58,
                          progress: t,
                          isHovered: true,
                        ),
                      ),
                    ),

                    // Floating icon-only orbs (zero text words)
                    for (int i = 0; i < _orbitIcons.length; i++)
                      _buildIconOrb(
                        icon: _orbitIcons[i].icon,
                        color: _orbitIcons[i].color,
                        angleDeg: _orbitIcons[i].angleDeg,
                        index: i,
                        radius: radius,
                        progress: t,
                        isCompact: isCompact,
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconOrb({
    required IconData icon,
    required Color color,
    required double angleDeg,
    required int index,
    required double radius,
    required double progress,
    required bool isCompact,
  }) {
    final rad = angleDeg * math.pi / 180.0;
    final orbitShift = progress * 0.25;
    final floatY = math.sin((progress + orbitShift) * 2 * math.pi + index * 1.5) * 7.0;
    final dx = math.cos(rad) * radius;
    final dy = math.sin(rad) * radius + floatY;
    final glow = 0.5 + 0.5 * math.sin(progress * 2 * math.pi + index * 1.57);

    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
        width: isCompact ? 46 : 56,
        height: isCompact ? 46 : 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.10 + 0.08 * glow),
          border: Border.all(
            color: color.withOpacity(0.45 + 0.35 * glow),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25 * glow),
              blurRadius: 20,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: isCompact ? 22 : 26),
      ),
    );
  }
}

class _WordlessImaginationPainter extends CustomPainter {
  const _WordlessImaginationPainter({
    required this.progress,
    required this.radius,
    required this.nodeAngles,
    required this.nodeColors,
  });

  final double progress;
  final double radius;
  final List<double> nodeAngles;
  final List<Color> nodeColors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Translucent ambient aura
    canvas.drawCircle(
      center,
      radius * 1.32,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Z2HColors.accentCyan.withOpacity(0.12),
            Z2HColors.accentIndigo.withOpacity(0.08),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.32)),
    );

    // Dual sinusoidal R&D wave ribbons behind the orbit
    for (int wave = 0; wave < 2; wave++) {
      final path = Path();
      final phase = progress * 2 * math.pi + wave * math.pi * 0.7;
      for (double x = 0; x <= size.width; x += 6) {
        final normX = x / size.width;
        final envelope = math.sin(normX * math.pi);
        final y = center.dy +
            math.sin(normX * 4 * math.pi + phase) * (24 + wave * 12) * envelope;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = (wave == 0 ? Z2HColors.accentCyan : Z2HColors.accentViolet)
              .withOpacity(0.22)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      );
    }

    // Translucent concentric orbital rings
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Z2HColors.accentCyan.withOpacity(0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    canvas.drawCircle(
      center,
      radius * 0.62,
      Paint()
        ..color = Z2HColors.accentIndigo.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Rotating luminous arc
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = SweepGradient(
          colors: [
            Colors.transparent,
            Z2HColors.accentCyan.withOpacity(0.65),
            Z2HColors.accentEmerald.withOpacity(0.55),
            Colors.transparent,
          ],
          transform: GradientRotation(progress * 2 * math.pi),
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6,
    );

    // Neural energy beams + traveling particles
    for (int i = 0; i < nodeAngles.length; i++) {
      final rad = nodeAngles[i] * math.pi / 180.0;
      final end = Offset(center.dx + math.cos(rad) * radius, center.dy + math.sin(rad) * radius);
      final color = nodeColors[i];

      canvas.drawLine(
        center,
        end,
        Paint()
          ..color = color.withOpacity(0.28)
          ..strokeWidth = 1.4,
      );

      final pulseT = (progress * 1.5 + i * 0.25) % 1.0;
      final pos = Offset.lerp(center, end, pulseT)!;
      canvas.drawCircle(pos, 4.0, Paint()..color = color.withOpacity(0.9));
    }
  }

  @override
  bool shouldRepaint(covariant _WordlessImaginationPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
