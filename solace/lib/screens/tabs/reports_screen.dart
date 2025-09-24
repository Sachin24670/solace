import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../utils/date_formatter.dart';
import '../../widgets/shared_ui.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // Placeholder data
  final List<Map<String, dynamic>> _dummyReports = [
    {
      'date': DateTime.now(),
      'moodScore': 7,
      'keyThemes': ['Work', 'Stress'],
      'insightfulSummary': 'Reflected on a challenging work situation, exploring feelings of pressure.',
      'cognitiveReframing': 'Recognized a tendency to catastrophize outcomes. Challenges are opportunities for growth.',
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'moodScore': 8,
      'keyThemes': ['Friends', 'Weekend'],
      'insightfulSummary': 'Enjoyed a relaxing day with friends, feeling refreshed and re-energized.',
      'cognitiveReframing': 'N/A',
    },
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
                    'Reports',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: textColor),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _dummyReports.length,
                    itemBuilder: (context, index) {
                      final report = _dummyReports[index];
                      return GlassmorphicContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormatter.formatDateLong(report['date']),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                report['insightfulSummary'],
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor.withOpacity(0.8)),
                              ),
                              if (report['cognitiveReframing'] != 'N/A') ...[
                                const SizedBox(height: 12),
                                _buildInsightCard(context, report['cognitiveReframing'], textColor),
                              ],
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8.0,
                                children: (report['keyThemes'] as List<String>)
                                    .map((theme) => Chip(
                                          label: Text(theme),
                                          backgroundColor: const Color(0xFFA3BE8C).withOpacity(0.4),
                                          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF3B4252)),
                                        ))
                                    .toList(),
                              ),
                            ],
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

  Widget _buildInsightCard(BuildContext context, String insight, Color textColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Insight for Reflection:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(insight, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor.withOpacity(0.8))),
            ],
          ),
        ),
      ),
    );
  }
}
