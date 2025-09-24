import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

// --- List of calming, colorful particles for the background ---
const List<Color> particleColors = [
  Color(0xFFB48EAD), // Soft Lavender
  Color(0xFF88C0D0), // Calm Blue
  Color(0xFF81A1C1), // Deeper Blue
  Color(0xFFEBCB8B), // Soft Gold
  Color(0xFFA3BE8C), // Gentle Green
  Color(0xFFD08770), // Soft Terracotta
];

// --- Data class for a single particle ---
class Particle {
  late Offset position;
  late Color color;
  late double speed;
  late double theta;
  late double radius;

  Particle() {
    reset();
  }

  void reset({Size bounds = Size.zero}) {
    final random = math.Random();
    radius = random.nextDouble() * 25 + 20;
    speed = random.nextDouble() * 0.3 + 0.1;
    theta = random.nextDouble() * 2.0 * math.pi;
    color = particleColors[random.nextInt(particleColors.length)]
        .withOpacity(random.nextDouble() * 0.5 + 0.2);
    position = Offset(
      random.nextDouble() * (bounds.width == 0 ? 1 : bounds.width),
      random.nextDouble() * (bounds.height == 0 ? 1 : bounds.height),
    );
  }

  void update(Size bounds) {
    position = position + Offset(math.cos(theta) * speed, math.sin(theta) * speed);
    if (position.dx < -radius * 2 ||
        position.dx > bounds.width + radius * 2 ||
        position.dy < -radius * 2 ||
        position.dy > bounds.height + radius * 2) {
      reset(bounds: bounds);
    }
  }
}

// --- Widget to render the magical background ---
class MagicalBackground extends StatefulWidget {
  final int particleCount;
  const MagicalBackground({super.key, this.particleCount = 30});

  @override
  State<MagicalBackground> createState() => _MagicalBackgroundState();
}

class _MagicalBackgroundState extends State<MagicalBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
    particles = List.generate(widget.particleCount, (index) => Particle());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    for (var p in particles) {
      p.reset(bounds: size);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var p in particles) {
          p.update(MediaQuery.of(context).size);
        }
        return CustomPaint(
          painter: _ParticlePainter(particles),
          child: Container(),
        );
      },
    );
  }
}

// --- Custom painter to draw the particles ---
class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    for (var p in particles) {
      paint.color = p.color;
      canvas.drawCircle(p.position, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- Reusable Glassmorphic Container Widget ---
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  const GlassmorphicContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.4),
                  Colors.white.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
