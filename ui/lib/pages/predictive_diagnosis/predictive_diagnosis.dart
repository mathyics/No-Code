import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class PredictiveDiagnosticsPage extends StatefulWidget {
  const PredictiveDiagnosticsPage({super.key});

  @override
  State<PredictiveDiagnosticsPage> createState() => _PredictiveDiagnosticsPageState();
}

class _PredictiveDiagnosticsPageState extends State<PredictiveDiagnosticsPage> {
  List<Map<String, dynamic>> conditions = [
    {
      'name': 'Diabetes Risk',
      'risk': 0.65,
      'description': 'Moderate risk of diabetes. Consider regular exercise and a balanced diet.',
      'timestamp': DateTime.now()
    },
    {
      'name': 'Heart Disease Risk',
      'risk': 0.45,
      'description': 'Moderate heart disease risk. Monitor blood pressure and cholesterol.',
      'timestamp': DateTime.now()
    },
  ];

  String selectedFilter = 'All';

  Color getRiskColor(double risk) {
    if (risk < 0.33) return Colors.green;
    if (risk < 0.66) return Colors.orange;
    return Colors.red;
  }

  String getRiskLabel(double risk) {
    if (risk < 0.33) return 'Low';
    if (risk < 0.66) return 'Moderate';
    return 'High';
  }

  void _addNewCondition() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Condition"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Condition Name")),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newCondition = {
                'name': nameController.text,
                'description': descriptionController.text,
                'risk': double.parse((Random().nextDouble()).toStringAsFixed(2)),
                'timestamp': DateTime.now()
              };
              setState(() => conditions.add(newCondition));
              Navigator.pop(ctx);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = selectedFilter == 'All'
        ? conditions
        : conditions.where((c) => getRiskLabel(c['risk']) == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Predictive Diagnostics')),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // Risk Filter Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: ['All', 'Low', 'Moderate', 'High'].map((filter) {
                final isSelected = selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedFilter = filter),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey[200],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final condition = filtered[index];
                final risk = condition['risk'] as double;
                final name = condition['name'] as String;
                final description = condition['description'] as String;
                final timestamp = condition['timestamp'] as DateTime;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            value: risk,
                            strokeWidth: 4,
                            color: getRiskColor(risk),
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                        Text('${(risk * 100).toInt()}%', style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Level: ${getRiskLabel(risk)}', style: const TextStyle(fontSize: 13)),
                        Text('Last checked: ${DateFormat('MMM d, y – h:mm a').format(timestamp)}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.share),
                      tooltip: 'Share Report',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Shared '${name}' diagnostics")),
                        );
                      },
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(name),
                          content: Text(description),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCondition,
        child: const Icon(Icons.add),
        tooltip: 'Add Diagnostic',
      ),
    );
  }
}
