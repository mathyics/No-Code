import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarePlanPage extends StatefulWidget {
  const CarePlanPage({super.key});

  @override
  State<CarePlanPage> createState() => _CarePlanPageState();
}

class _CarePlanPageState extends State<CarePlanPage> {
  List<Map<String, dynamic>> plans = [
    {
      'title': 'Diet Plan',
      'progress': 0.7,
      'startDate': DateTime.now().subtract(const Duration(days: 10)),
      'targetDate': DateTime.now().add(const Duration(days: 20)),
      'steps': ['Eat vegetables daily', 'Reduce sugar intake', 'Stay hydrated']
    },
    {
      'title': 'Exercise Routine',
      'progress': 0.4,
      'startDate': DateTime.now().subtract(const Duration(days: 5)),
      'targetDate': DateTime.now().add(const Duration(days: 25)),
      'steps': ['Walk 30 mins daily', 'Strength training twice a week']
    },
  ];

  Color getProgressColor(double progress) {
    if (progress < 0.4) return Colors.red;
    if (progress < 0.75) return Colors.orange;
    return Colors.green;
  }

  void _showPlanDetails(int index) {
    final plan = plans[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(plan['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress: ${(plan['progress'] * 100).toInt()}%'),
            Text(
              'Duration: ${DateFormat.yMMMd().format(plan['startDate'])} - ${DateFormat.yMMMd().format(plan['targetDate'])}',
            ),
            const SizedBox(height: 10),
            const Text('Steps:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...List<Widget>.from(
              (plan['steps'] as List<String>).map((step) => Text('• $step')),
            )
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _addPlan() {
    final titleController = TextEditingController();
    final stepsController = TextEditingController();

    DateTime startDate = DateTime.now();
    DateTime targetDate = DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Care Plan'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Plan Title'),
              ),
              TextField(
                controller: stepsController,
                decoration: const InputDecoration(
                  labelText: 'Steps (comma separated)',
                ),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedStart = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (pickedStart != null) {
                    startDate = pickedStart;
                    setState(() {});
                  }
                },
                child: const Text('Select Start Date'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedTarget = await showDatePicker(
                    context: context,
                    initialDate: targetDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (pickedTarget != null) {
                    targetDate = pickedTarget;
                    setState(() {});
                  }
                },
                child: const Text('Select Target Date'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final title = titleController.text.trim();
              final stepsText = stepsController.text.trim();

              if (title.isNotEmpty && stepsText.isNotEmpty) {
                final steps = stepsText.split(',').map((s) => s.trim()).toList();

                setState(() {
                  plans.add({
                    'title': title,
                    'progress': 0.0,
                    'startDate': startDate,
                    'targetDate': targetDate,
                    'steps': steps,
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deletePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Care plan deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personalized Care Plans')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          final progress = plan['progress'] as double;
          return Dismissible(
            key: Key(plan['title'] + index.toString()),
            background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 20), child: const Icon(Icons.delete, color: Colors.white)),
            secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
            onDismissed: (_) => _deletePlan(index),
            child: Card(
              child: ListTile(
                title: Text(plan['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      color: getProgressColor(progress),
                      backgroundColor: Colors.grey[300],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('${(progress * 100).toInt()}% completed',
                          style: TextStyle(color: getProgressColor(progress))),
                    ),
                    Text(
                      'Duration: ${DateFormat.yMMMd().format(plan['startDate'])} - ${DateFormat.yMMMd().format(plan['targetDate'])}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                onTap: () => _showPlanDetails(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlan,
        tooltip: 'Add Care Plan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
