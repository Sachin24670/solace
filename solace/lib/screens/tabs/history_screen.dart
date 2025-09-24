import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../utils/date_formatter.dart'; // Assuming you have this helper
import '../../widgets/shared_ui.dart'; // Using the shared UI components

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Placeholder for conversation history
  final List<Map<String, dynamic>> _dummyConversations = [
    {
      'id': 'conv_001',
      'date': DateTime.now().subtract(const Duration(hours: 3)),
      'summary': 'Discussed work stress and feeling overwhelmed by project deadlines.',
      'mood': 'Anxious',
    },
    {
      'id': 'conv_002',
      'date': DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      'summary': 'Reflected on a positive interaction with a friend and feeling grateful.',
      'mood': 'Joyful',
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
                    'History',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: textColor),
                  ),
                ),
                // Glassmorphic Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: GlassmorphicContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        style: TextStyle(color: textColor.withOpacity(0.8)),
                        decoration: InputDecoration(
                          hintText: 'Search journals...',
                          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                          prefixIcon: Icon(Icons.search, color: textColor.withOpacity(0.7)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _dummyConversations.length,
                    itemBuilder: (context, index) {
                      final conversation = _dummyConversations[index];
                      return GlassmorphicContainer(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormatter.formatDateTimeShort(conversation['date']),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textColor.withOpacity(0.7)),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  conversation['summary'],
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Chip(
                                    label: Text(conversation['mood']),
                                    backgroundColor: const Color(0xFF88C0D0).withOpacity(0.3),
                                    labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF3B4252)),
                                  ),
                                ),
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
