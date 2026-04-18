import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../logic/providers.dart';
import '../logic/initialization_provider.dart';
import '../ui/screens/home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bookOpenAnimation;
  late Animation<double> _glowAnimation;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _bookOpenAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7, curve: Curves.easeInOutCubic)),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    if (_navigated) return;
    _navigated = true;
    
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(importProgressProvider);
    final initAsync = ref.watch(appInitializationProvider);

    // Trigger de navegação: Progresso 100% e Animação concluída
    if (progress >= 1.0 && _controller.isCompleted && !initAsync.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToHome());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(120, 100),
                  painter: BibleLogoPainter(
                    progress: _bookOpenAnimation.value,
                    glow: _glowAnimation.value,
                  ),
                ),
                const SizedBox(height: 40),
                Opacity(
                  opacity: _glowAnimation.value,
                  child: Column(
                    children: [
                      Text(
                        "BÍBLIA SAGRADA",
                        style: GoogleFonts.playfairDisplay(
                          color: const Color(0xFF5D4037),
                          letterSpacing: 4,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProgressBar(progress),
                      const SizedBox(height: 10),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: GoogleFonts.lato(
                          color: const Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      width: 200,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFF5D4037).withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withOpacity(0.3),
                blurRadius: 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BibleLogoPainter extends CustomPainter {
  final double progress;
  final double glow;
  BibleLogoPainter({required this.progress, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    final leftPath = Path()
      ..moveTo(center.dx, center.dy - 40)
      ..quadraticBezierTo(center.dx - 50 * progress, center.dy - 45, center.dx - 60 * progress, center.dy - 30)
      ..lineTo(center.dx - 60 * progress, center.dy + 40)
      ..quadraticBezierTo(center.dx - 50 * progress, center.dy + 35, center.dx, center.dy + 40);
    final rightPath = Path()
      ..moveTo(center.dx, center.dy - 40)
      ..quadraticBezierTo(center.dx + 50 * progress, center.dy - 45, center.dx + 60 * progress, center.dy - 30)
      ..lineTo(center.dx + 60 * progress, center.dy + 40)
      ..quadraticBezierTo(center.dx + 50 * progress, center.dy + 35, center.dx, center.dy + 40);
    canvas.drawPath(leftPath, paint);
    canvas.drawPath(rightPath, paint);
    if (glow > 0) {
      final glowPaint = Paint()
        ..color = const Color(0xFFD4AF37).withOpacity(0.3 * glow)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 * glow);
      canvas.drawCircle(center, 20 * glow, glowPaint);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
