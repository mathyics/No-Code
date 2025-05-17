import 'dart:developer';

import 'package:flutter/material.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final List<Map<String, String>> _allSymptoms = [
    {'symptom': 'Fever', 'likelihood': 'High', 'description': 'Elevated body temperature.'},
    {'symptom': 'Cough', 'likelihood': 'Medium', 'description': 'Persistent dry or productive cough.'},
    {'symptom': 'Fatigue', 'likelihood': 'Low', 'description': 'General feeling of tiredness.'},
    {'symptom': 'Shortness of Breath', 'likelihood': 'Medium', 'description': 'Difficulty breathing.'},
    {'symptom': 'Sore Throat', 'likelihood': 'Low', 'description': 'Irritation in throat.'},
    {'symptom': 'Headache', 'likelihood': 'Medium', 'description': 'Pain in head region.'},
    {'symptom': 'Nausea', 'likelihood': 'Low', 'description': 'Feeling of sickness.'},
    {'symptom': 'Chest Pain', 'likelihood': 'High', 'description': 'Pain or discomfort in chest.'},
  ];
  List<Map<String, String>> _filteredSymptoms = [];
  String _searchQuery = '';
  String _selectedSeverity = 'All';

  @override
  void initState() {
    super.initState();
    _filteredSymptoms = List.from(_allSymptoms);
  }

  void _filterList() {
    setState(() {
      _filteredSymptoms = _allSymptoms.where((sym) {
        final matchesSearch = sym['symptom']!.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesSeverity = (_selectedSeverity == 'All') || (sym['likelihood'] == _selectedSeverity);
        return matchesSearch && matchesSeverity;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Symptom Checker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search symptoms...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _filterList();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedSeverity,
              items: ['All', 'High', 'Medium', 'Low']
                  .map((level) => DropdownMenuItem(
                value: level,
                child: Text(level),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _selectedSeverity = value;
                  _filterList();
                }
              },
              decoration: const InputDecoration(
                labelText: 'Filter by severity',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSymptoms.length,
              itemBuilder: (context, index) {
                final item = _filteredSymptoms[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: ExpansionTile(
                    leading: const Icon(Icons.healing),
                    title: Text(item['symptom']!),
                    subtitle: Text('Likelihood: ${item['likelihood']}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(item['description']!),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Advice for ${item['symptom']}'),
                                  content: Text(_getAdvice(item['symptom']!)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.info_outline),
                          label: const Text('View Advice'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  String _getAdvice(String symptom) {
    switch (symptom) {
      case 'Fever':
        return 'Stay hydrated, rest, and take paracetamol as needed.';
      case 'Cough':
        return 'Drink warm fluids, use cough lozenges, and consider a humidifier.';
      case 'Fatigue':
        return 'Ensure adequate sleep, balanced diet, and light exercise.';
    // Add more cases for other symptoms...
      default:
        return 'Consult a healthcare professional for more information.';
    }
  }

}
