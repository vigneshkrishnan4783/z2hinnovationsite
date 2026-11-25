import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/z2h_theme.dart';

class Z2HLogoMark extends StatelessWidget {
  const Z2HLogoMark({super.key, this.size = 44, this.progress = 0.0, this.isHovered = false});

  final double size;
  final double progress;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(size),
        painter: _Z2HLogoPainter(progress: progress, isHovered: isHovered),
      ),
    );
  }
}

class _Z2HLogoPainter extends CustomPainter {
  const _Z2HLogoPainter({required this.progress, required this.isHovered});

  final double progress;
  final bool isHovered;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.5);
    final pulse = 0.5 + 0.5 * math.sin(progress * 2 * math.pi);

    final hexPath = Path()
      ..moveTo(w * 0.5, h * 0.06)
      ..lineTo(w * 0.88, h * 0.28)
      ..lineTo(w * 0.88, h * 0.72)
      ..lineTo(w * 0.5, h * 0.94)
      ..lineTo(w * 0.12, h * 0.72)
      ..lineTo(w * 0.12, h * 0.28)
      ..close();

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Z2HColors.accentCyan.withOpacity((isHovered ? 0.34 : 0.16) + 0.12 * pulse),
          Z2HColors.accentIndigo.withOpacity(0.1 + 0.08 * pulse),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: w * 0.58));
    canvas.drawCircle(center, w * 0.54, glowPaint);

    final fillPaint = Paint()
      ..color = Z2HColors.accentCyan.withOpacity(0.08 + 0.05 * pulse)
      ..style = PaintingStyle.fill;
    canvas.drawPath(hexPath, fillPaint);

    final strokePaint = Paint()
      ..shader = SweepGradient(
        colors: const [
          Z2HColors.accentCyan,
          Z2HColors.accentIndigo,
          Z2HColors.accentViolet,
          Z2HColors.accentCyan,
        ],
        transform: GradientRotation(progress * 2 * math.pi),
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.06;
    canvas.drawPath(hexPath, strokePaint);

    final zPath = Path()
      ..moveTo(w * 0.30, h * 0.35)
      ..lineTo(w * 0.62, h * 0.35)
      ..lineTo(w * 0.32, h * 0.65)
      ..lineTo(w * 0.70, h * 0.65);

    canvas.drawPath(
      zPath,
      Paint()
        ..color = Z2HColors.textPrimary.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.06
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    if (isHovered) {
      for (final metric in zPath.computeMetrics()) {
        final len = metric.length;
        final head = progress * len;
        final tail = math.max(0.0, head - len * 0.45);
        canvas.drawPath(
          metric.extractPath(tail, head),
          Paint()
            ..color = Z2HColors.accentCyan
            ..style = PaintingStyle.stroke
            ..strokeWidth = w * 0.08
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    canvas.drawCircle(
      Offset(w * 0.70, h * 0.35),
      w * 0.052,
      Paint()..color = Z2HColors.accentCyan,
    );
    canvas.drawCircle(
      Offset(w * 0.30, h * 0.65),
      w * 0.046,
      Paint()..color = Z2HColors.accentEmerald,
    );
  }

  @override
  bool shouldRepaint(covariant _Z2HLogoPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isHovered != isHovered;
}

class _HoverBubblesPainter extends CustomPainter {
  const _HoverBubblesPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const bubbleSpecs = [
      (x: 0.08, speed: 1.0, radius: 4.5, color: Z2HColors.accentCyan),
      (x: 0.22, speed: 1.4, radius: 3.5, color: Z2HColors.accentEmerald),
      (x: 0.36, speed: 1.2, radius: 5.0, color: Z2HColors.accentIndigo),
      (x: 0.52, speed: 1.6, radius: 3.2, color: Z2HColors.accentCyan),
      (x: 0.70, speed: 1.1, radius: 4.2, color: Z2HColors.accentViolet),
      (x: 0.88, speed: 1.5, radius: 3.8, color: Z2HColors.accentEmerald),
    ];

    for (int i = 0; i < bubbleSpecs.length; i++) {
      final b = bubbleSpecs[i];
      final life = (progress * b.speed + i * 0.17) % 1.0;
      final cx = size.width * b.x + math.sin(life * 2 * math.pi + i) * 5;
      final cy = size.height * (1.05 - life * 1.15);
      final alpha = (1.0 - life).clamp(0.0, 1.0) * 0.72;
      canvas.drawCircle(
        Offset(cx, cy),
        b.radius * (0.7 + 0.5 * life),
        Paint()
          ..color = b.color.withOpacity(alpha)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        Offset(cx, cy),
        b.radius * (0.7 + 0.5 * life),
        Paint()
          ..color = Colors.white.withOpacity(alpha * 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HoverBubblesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class Z2HBrandLockup extends StatefulWidget {
  const Z2HBrandLockup({super.key, this.compact = false});

  final bool compact;

  @override
  State<Z2HBrandLockup> createState() => _Z2HBrandLockupState();
}

class _Z2HBrandLockupState extends State<Z2HBrandLockup>
    with TickerProviderStateMixin {
  late final AnimationController _shadeController;
  late final AnimationController _danceController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _shadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
  }

  @override
  void dispose() {
    _shadeController.dispose();
    _danceController.dispose();
    super.dispose();
  }

  void _setHovered(bool hovered) {
    if (_isHovered == hovered) return;
    setState(() => _isHovered = hovered);
    if (hovered) {
      _danceController.repeat();
    } else {
      _danceController.stop();
      _danceController.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleSize = widget.compact ? 17.5 : 22.0;
    const z2hChars = ['Z', '2', 'H'];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([_shadeController, _danceController]),
          builder: (context, _) {
            final shadeT = _shadeController.value;
            final danceT = _danceController.value;
            final shift = -1.6 + 3.2 * shadeT;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                if (_isHovered)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _HoverBubblesPainter(progress: danceT),
                      ),
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: Offset(
                        0,
                        _isHovered ? math.sin(danceT * 2 * math.pi) * -3.5 : 0.0,
                      ),
                      child: Z2HLogoMark(
                        size: widget.compact ? 36 : 46,
                        progress: _isHovered ? danceT : shadeT,
                        isHovered: _isHovered,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment(shift - 0.9, -0.2),
                              end: Alignment(shift + 0.9, 0.2),
                              colors: const [
                                Z2HColors.textPrimary,
                                Z2HColors.accentCyan,
                                Color(0xFFA5B4FC),
                                Z2HColors.textPrimary,
                              ],
                            ).createShader(bounds),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < z2hChars.length; i++)
                                  Transform.translate(
                                    offset: Offset(
                                      0,
                                      _isHovered
                                          ? math.sin(danceT * 2 * math.pi + i * 1.15) * -5.0
                                          : 0.0,
                                    ),
                                    child: Transform.rotate(
                                      angle: _isHovered
                                          ? math.sin(danceT * 2 * math.pi + i * 1.15) * 0.09
                                          : 0.0,
                                      child: Text(
                                        z2hChars[i],
                                        style: TextStyle(
                                          fontSize: titleSize,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                Flexible(
                                  child: Text(
                                    ' Innovations',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: titleSize,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.4,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!widget.compact)
                            const Text(
                              'R&D LAB',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.6,
                                color: Z2HColors.accentCyan,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
