import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui'; // Required for ImageFilter.blur

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
    // Initialize with random properties
    reset();
  }

  void reset({Size bounds = Size.zero}) {
    final random = math.Random();
    // ENHANCED: Particles are even larger for a softer look
    radius = random.nextDouble() * 25 + 20;
    // ENHANCED: Slower and calmer movement
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
  // ENHANCED: Reduced count as particles are much larger
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
      duration: const Duration(seconds: 25), // Slower animation loop
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
    // ENHANCED: Paint now includes a stronger blur effect
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


// --- Main Converse Screen Widget ---
class ConverseScreen extends StatefulWidget {
  const ConverseScreen({super.key});

  @override
  State<ConverseScreen> createState() => _ConverseScreenState();
}

class _ConverseScreenState extends State<ConverseScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbController;

  bool _isRecording = false;
  final List<Map<String, String>> _messages = [
    {'type': 'aura', 'text': 'I understand. What specifically made you feel down?'},
    {'type': 'user', 'text': 'I was feeling a bit down about work today.'},
    {'type': 'aura', 'text': 'Hello, how can I help you today?'},
  ];

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _orbController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _orbController.repeat(reverse: true);
      } else {
        _orbController.stop();
        _orbController.animateTo(0, duration: const Duration(milliseconds: 300));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NEW: A pure white background color
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // The new colorful, blurred magical background
          const MagicalBackground(),

          // NEW: The overlay is now more prominent to enhance the "behind the screen" effect.
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.5, -0.5),
                radius: 1.2,
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.9),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Solace',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: const Color(0xFF4C566A)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUser = message['type'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: GlassmorphicContainer(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              message['text']!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: const Color(0xFF3B4252).withOpacity(0.8)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
                  child: GestureDetector(
                    onTap: _toggleRecording,
                    child: AnimatedBuilder(
                      animation: _orbController,
                      builder: (context, child) {
                        final pulse = _isRecording ? _orbController.value : 0.0;
                        return CustomPaint(
                          painter: GlowingOrbPainter(
                            animationValue: pulse,
                            color: _isRecording
                                ? Theme.of(context).colorScheme.primary
                                : const Color(0xFF4C566A),
                          ),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Icon(
                                _isRecording ? Icons.stop : Icons.mic,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Glassmorphic Container Widget
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
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // ENHANCED: Gradient is more subtle to look better on a pure white background.
                colors: [
                  Colors.white.withOpacity(0.4),
                  Colors.white.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                // ENHANCED: Border is now a very light grey for subtle definition.
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

// Custom painter for the orb (No change)
class GlowingOrbPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  GlowingOrbPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2;
    final glowRadius = baseRadius * (1 + animationValue * 0.3);
    final glowPaint = Paint()
      ..color = color.withOpacity(0.1 + animationValue * 0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, baseRadius * 0.6);
    canvas.drawCircle(center, glowRadius, glowPaint);
    final mainPaint = Paint()..color = color;
    canvas.drawCircle(center, baseRadius * 0.8, mainPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

