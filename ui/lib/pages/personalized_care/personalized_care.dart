import 'package:flutter/material.dart';

class CarePlanPage extends StatelessWidget {
  const CarePlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = <Map<String,dynamic>>[
      {'title': 'Diet Plan', 'progress': 0.7},
      {'title': 'Exercise Routine', 'progress': 0.4},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Personalized Care Plans')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: plans.map((p) {
          return Card(
            child: ListTile(
              title: Text(p['title']!),
              subtitle: LinearProgressIndicator(value: p['progress'] as double),
              trailing: Text('${(p['progress']! * 100).toInt()}%'),
            ),
          );
        }).toList(),
      ),
    );
  }
}
