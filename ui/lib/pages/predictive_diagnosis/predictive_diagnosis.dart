import 'package:flutter/material.dart';

class PredictiveDiagnosticsPage extends StatelessWidget {
  const PredictiveDiagnosticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conditions = <Map<String,dynamic>>[
      {'name': 'Diabetes Risk', 'risk': 0.65},
      {'name': 'Heart Disease Risk', 'risk': 0.45},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Predictive Diagnostics')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: conditions.map((c) {
          return Card(
            child: ListTile(
              title: Text(c['name']!),
              subtitle: LinearProgressIndicator(value: c['risk'] as double),
              trailing: Text('${(c['risk']! * 100).toInt()}%'),
            ),
          );
        }).toList(),
      ),
    );
  }
}
