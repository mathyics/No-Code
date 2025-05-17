import 'package:flutter/material.dart';

class SymptomCheckerPage extends StatelessWidget {
  const SymptomCheckerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final symptoms = [
      {'symptom': 'Fever', 'likelihood': 'High'},
      {'symptom': 'Cough', 'likelihood': 'Medium'},
      {'symptom': 'Fatigue', 'likelihood': 'Low'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Symptom Checker')),
      body: ListView.builder(
        itemCount: symptoms.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.healing),
            title: Text(symptoms[index]['symptom']!),
            subtitle: Text('Likelihood: ${symptoms[index]['likelihood']}'),
          );
        },
      ),
    );
  }
}
