import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'screens/careers_screen.dart';
import 'screens/home_screen.dart';
import 'screens/services_screen.dart';
import 'theme/z2h_theme.dart';
import 'widgets/z2h_logo.dart';

void main() {
  runApp(const Z2HApp());
}

class Z2HApp extends StatelessWidget {
  const Z2HApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Z2H Innovations & R&D Lab',
      debugShowCheckedModeBanner: false,
      theme: buildZ2HTheme(),
      home: const Z2HShell(),
    );
  }
}

enum _SideDock { none, left, right }

class Z2HShell extends StatefulWidget {
  const Z2HShell({super.key});

  @override
  State<Z2HShell> createState() => _Z2HShellState();
}

class _Z2HShellState extends State<Z2HShell> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  _SideDock _activeDock = _SideDock.none;
  Timer? _hideTimer;

  bool _headerHovered = false;
  Offset? _headerCursor;
  Offset? _bgCursor;

  late final AnimationController _revealController;
  late final AnimationController _waveController;
  late final AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _revealController.dispose();
    _waveController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  void _navigateTo(int index) {
    setState(() => _selectedIndex = index);
    _hideNavNow();
  }

  void _showSideNav(_SideDock side) {
    _hideTimer?.cancel();
    if (_activeDock != side) {
      setState(() => _activeDock = side);
    }
    _revealController.forward();
    if (!_waveController.isAnimating) {
      _waveController.repeat();
    }
  }

  void _scheduleHide(_SideDock side) {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 420), () {
      if (!mounted || _activeDock != side) return;
      _hideNavNow();
    });
  }

  void _hideNavNow() {
    _hideTimer?.cancel();
    _revealController.reverse().then((_) {
      if (mounted && _revealController.isDismissed) {
        _waveController.stop();
        setState(() => _activeDock = _SideDock.none);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sizeClass = classifyWidth(constraints.maxWidth);
        final isCompactHeader = sizeClass == ScreenSizeClass.smallPhone;

        final currentPage = switch (_selectedIndex) {
          0 => HomeScreen(onNavigate: _navigateTo),
          1 => ServicesScreen(onNavigate: _navigateTo),
          _ => CareersScreen(onNavigate: _navigateTo),
        };

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(76),
            child: MouseRegion(
              onEnter: (e) => setState(() {
                _headerHovered = true;
                _headerCursor = e.localPosition;
              }),
              onHover: (e) => setState(() {
                _headerHovered = true;
                _headerCursor = e.localPosition;
              }),
              onExit: (_) => setState(() {
                _headerHovered = false;
                _headerCursor = null;
              }),
              child: AppBar(
                toolbarHeight: 76,
                titleSpacing: 18,
                // Top navigation removed; moving cursor across header animates tiny floating bubbles
                flexibleSpace: RepaintBoundary(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _bubbleController,
                      builder: (context, _) => CustomPaint(
                        painter: _HeaderBubblesPainter(
                          progress: _bubbleController.value,
                          active: _headerHovered,
                          cursor: _headerCursor,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Z2HBrandLockup(compact: isCompactHeader),
                actions: [
                  if (isCompactHeader)
                    IconButton(
                      tooltip: 'Menu',
                      onPressed: () {
                        if (_activeDock == _SideDock.right) {
                          _hideNavNow();
                        } else {
                          _showSideNav(_SideDock.right);
                        }
                      },
                      icon: Icon(
                        _activeDock == _SideDock.right
                            ? Icons.close_rounded
                            : Icons.menu_rounded,
                        color: Z2HColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: MouseRegion(
              hitTestBehavior: HitTestBehavior.translucent,
              onHover: (e) => setState(() => _bgCursor = e.localPosition),
              onExit: (_) => setState(() => _bgCursor = null),
              child: Stack(
                children: [
                  // Animated cursor-reactive background bubbles
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: IgnorePointer(
                        child: AnimatedBuilder(
                          animation: _bubbleController,
                          builder: (context, _) => CustomPaint(
                            painter: _BackgroundBubblesPainter(
                              progress: _bubbleController.value,
                              cursor: _bgCursor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned.fill(child: currentPage),

                  // Left-edge cursor hover strip
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    width: 28,
                    child: MouseRegion(
                      hitTestBehavior: HitTestBehavior.translucent,
                      opaque: false,
                      onEnter: (_) => _showSideNav(_SideDock.left),
                      onExit: (_) => _scheduleHide(_SideDock.left),
                      child: const ColoredBox(color: Colors.transparent),
                    ),
                  ),

                  // Right-edge cursor hover strip
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    width: 28,
                    child: MouseRegion(
                      hitTestBehavior: HitTestBehavior.translucent,
                      opaque: false,
                      onEnter: (_) => _showSideNav(_SideDock.right),
                      onExit: (_) => _scheduleHide(_SideDock.right),
                      child: const ColoredBox(color: Colors.transparent),
                    ),
                  ),

                  // Left-side borderless animated wave navigation (no square box)
                  if (_activeDock == _SideDock.left)
                    Positioned(
                      left: 16,
                      top: 28,
                      child: MouseRegion(
                        onEnter: (_) => _showSideNav(_SideDock.left),
                        onExit: (_) => _scheduleHide(_SideDock.left),
                        child: AnimatedBuilder(
                          animation: Listenable.merge([_revealController, _waveController]),
                          builder: (context, _) => _FloatingWaveSideNav(
                            fromLeft: true,
                            reveal: _revealController.value,
                            wavePhase: _waveController.value,
                            selectedIndex: _selectedIndex,
                            onSelect: _navigateTo,
                          ),
                        ),
                      ),
                    ),

                  // Right-side borderless animated wave navigation (no square box)
                  if (_activeDock == _SideDock.right)
                    Positioned(
                      right: 16,
                      top: 28,
                      child: MouseRegion(
                        onEnter: (_) => _showSideNav(_SideDock.right),
                        onExit: (_) => _scheduleHide(_SideDock.right),
                        child: AnimatedBuilder(
                          animation: Listenable.merge([_revealController, _waveController]),
                          builder: (context, _) => _FloatingWaveSideNav(
                            fromLeft: false,
                            reveal: _revealController.value,
                            wavePhase: _waveController.value,
                            selectedIndex: _selectedIndex,
                            onSelect: _navigateTo,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Borderless, open floating wave navigation without any square container box.
class _FloatingWaveSideNav extends StatelessWidget {
  const _FloatingWaveSideNav({
    required this.fromLeft,
    required this.reveal,
    required this.wavePhase,
    required this.selectedIndex,
    required this.onSelect,
  });

  final bool fromLeft;
  final double reveal;
  final double wavePhase;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const items = [
      (label: 'Home', icon: Icons.home_rounded),
      (label: 'Services', icon: Icons.layers_rounded),
      (label: 'Careers', icon: Icons.work_rounded),
    ];

    final curve = Curves.easeOutBack.transform(reveal.clamp(0.0, 1.0));
    final dir = fromLeft ? -1.0 : 1.0;

    return Opacity(
      opacity: reveal.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset((1.0 - curve) * 90 * dir, 0),
        child: Material(
          color: Colors.transparent,
          child: CustomPaint(
            painter: _WaveLinePainter(phase: wavePhase, onLeft: fromLeft),
            child: Padding(
              padding: EdgeInsets.only(left: fromLeft ? 14 : 4, right: fromLeft ? 4 : 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: fromLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  for (int i = 0; i < items.length; i++)
                    _buildNavItem(items[i].label, items[i].icon, i, dir),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, int i, double dir) {
    final step = ((reveal - i * 0.14) / 0.72).clamp(0.0, 1.0);
    final waveX = math.sin(wavePhase * 2 * math.pi + i * 1.2) * 5.0 * step;
    final active = selectedIndex == i;

    return Transform.translate(
      offset: Offset((1.0 - step) * 28 * dir + waveX, 0),
      child: Opacity(
        opacity: step,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: InkWell(
            borderRadius: BorderRadius.circular(99),
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: active
                    ? Z2HColors.accentCyan
                    : Z2HColors.bgSecondary.withOpacity(0.75),
                borderRadius: BorderRadius.circular(99),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: Z2HColors.accentCyan.withOpacity(0.35),
                          blurRadius: 16,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 17,
                    color: active ? const Color(0xFF040711) : Z2HColors.accentCyan,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: active ? const Color(0xFF040711) : Z2HColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WaveLinePainter extends CustomPainter {
  const _WaveLinePainter({required this.phase, required this.onLeft});

  final double phase;
  final bool onLeft;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final baseX = onLeft ? 4.0 : size.width - 4.0;
    for (double y = 4; y <= size.height - 4; y += 4) {
      final x = baseX + math.sin(y * 0.085 + phase * 2 * math.pi) * 3.0;
      if (y == 4) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = Z2HColors.accentCyan.withOpacity(0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _WaveLinePainter oldDelegate) =>
      oldDelegate.phase != phase;
}

class _HeaderBubblesPainter extends CustomPainter {
  const _HeaderBubblesPainter({
    required this.progress,
    required this.active,
    required this.cursor,
  });

  final double progress;
  final bool active;
  final Offset? cursor;

  @override
  void paint(Canvas canvas, Size size) {
    if (!active) return;

    const colors = [
      Z2HColors.accentCyan,
      Z2HColors.accentIndigo,
      Z2HColors.accentEmerald,
      Z2HColors.accentViolet,
    ];

    // Tiny playful header bubbles moving horizontally & vertically
    for (int i = 0; i < 16; i++) {
      final speed = 0.7 + (i % 4) * 0.35;
      final t = (progress * speed + i * 0.13) % 1.0;
      final baseX = ((i * 0.068 + t * 0.18) % 1.0) * size.width;
      final baseY = size.height * (0.18 + ((i * 0.23) % 0.65)) +
          math.sin(t * 2 * math.pi + i) * 10;

      Offset pos = Offset(baseX, baseY);
      if (cursor != null) {
        final delta = pos - cursor!;
        final dist = delta.distance;
        if (dist < 140 && dist > 1) {
          pos = pos + (delta / dist) * (140 - dist) * 0.18;
        }
      }

      final radius = 2.4 + (i % 4) * 1.3;
      final color = colors[i % colors.length];
      canvas.drawCircle(
        pos,
        radius,
        Paint()..color = color.withOpacity(0.42),
      );
      canvas.drawCircle(
        pos,
        radius,
        Paint()
          ..color = Colors.white.withOpacity(0.28)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.7,
      );
    }

    // Extra tiny sparkle cluster around the cursor in the header
    if (cursor != null) {
      for (int j = 0; j < 6; j++) {
        final angle = progress * 2 * math.pi + j * (math.pi / 3);
        final r = 14.0 + math.sin(progress * 4 * math.pi + j) * 6;
        final p = cursor! + Offset(math.cos(angle) * r, math.sin(angle) * r);
        canvas.drawCircle(
          p,
          2.6,
          Paint()..color = colors[j % colors.length].withOpacity(0.55),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeaderBubblesPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.active != active ||
      oldDelegate.cursor != cursor;
}

class _BackgroundBubblesPainter extends CustomPainter {
  const _BackgroundBubblesPainter({
    required this.progress,
    required this.cursor,
  });

  final double progress;
  final Offset? cursor;

  @override
  void paint(Canvas canvas, Size size) {
    const colors = [
      Z2HColors.accentCyan,
      Z2HColors.accentIndigo,
      Z2HColors.accentViolet,
      Z2HColors.accentEmerald,
    ];

    for (int i = 0; i < 18; i++) {
      final speed = 0.4 + (i % 5) * 0.15;
      final life = (progress * speed + i * 0.09) % 1.0;
      final xFrac = (0.06 + (i * 0.055)) % 0.94;
      double cx = size.width * xFrac + math.sin(life * 2 * math.pi + i) * 18;
      double cy = size.height * (1.05 - life * 1.1);

      if (cursor != null) {
        final dx = cx - cursor!.dx;
        final dy = cy - cursor!.dy;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist < 180 && dist > 1) {
          final push = (180 - dist) * 0.16;
          cx += (dx / dist) * push;
          cy += (dy / dist) * push;
        }
      }

      final r = 4.0 + (i % 4) * 3.0;
      final color = colors[i % colors.length];
      final alpha = (cursor != null ? 0.18 : 0.10) * (1.0 - (life - 0.5).abs() * 1.4).clamp(0.2, 1.0);

      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()..color = color.withOpacity(alpha),
      );
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..color = color.withOpacity(alpha * 1.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundBubblesPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.cursor != cursor;
}
