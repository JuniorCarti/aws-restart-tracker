import 'package:flutter/material.dart';
import 'package:aws_restart_tracker/models/module.dart';
import 'package:aws_restart_tracker/services/data_service.dart';

class StatsScreen extends StatelessWidget {
  final List<Module> modules;
  final Map<int, bool> progress;

  const StatsScreen({
    super.key,
    required this.modules,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final categoryStats = DataService.getCategoryStats(modules, progress);
    final totalCompleted = DataService.getTotalCompleted(progress);
    final overallProgress = DataService.getOverallProgress(modules, progress);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Statistics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Overall Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          'Completed',
                          '$totalCompleted',
                          Colors.green,
                        ),
                        _buildStatCard(
                          'Remaining',
                          '${modules.length - totalCompleted}',
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'Total',
                          '${modules.length}',
                          Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: overallProgress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(overallProgress * 100).toStringAsFixed(1)}% Complete',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Category Breakdown
            const Text(
              'Category Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: categoryStats.entries.map((entry) {
                  final categoryModules = modules
                      .where((module) => module.category == entry.key)
                      .length;
                  final completed = entry.value;
                  final percentage = categoryModules > 0
                      ? (completed / categoryModules * 100)
                      : 0;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('$completed/$categoryModules completed'),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: completed / categoryModules,
                            backgroundColor: Colors.grey[300],
                            color: percentage == 100 ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}