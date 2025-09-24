import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../widgets/shared_ui.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  final List<Map<String, String>> _guidedSessions = const [
    {'title': 'Gratitude Practice', 'description': 'Cultivate appreciation for the good things.'},
    {'title': 'Mindful Breathing', 'description': 'Center yourself and reduce stress.'},
    {'title': 'Working Through Anxiety', 'description': 'Explore and understand anxious feelings.'},
    {'title': 'Sleep Preparation', 'description': 'Wind down your mind for a restful sleep.'},
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = const Color(0xFF4C566A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const MagicalBackground(),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.5, -0.5),
                radius: 1.2,
                colors: [Colors.white.withOpacity(0.6), Colors.white.withOpacity(0.9)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Guided Sessions',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: textColor),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _guidedSessions.length,
                    itemBuilder: (context, index) {
                      final session = _guidedSessions[index];
                      return GlassmorphicContainer(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session['title']!,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        session['description']!,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor.withOpacity(0.7)),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, color: textColor.withOpacity(0.5), size: 18),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
