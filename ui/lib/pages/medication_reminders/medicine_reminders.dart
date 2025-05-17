import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationRemindersPage extends StatefulWidget {
  const MedicationRemindersPage({super.key});

  @override
  State<MedicationRemindersPage> createState() =>
      _MedicationRemindersPageState();
}

class _MedicationRemindersPageState extends State<MedicationRemindersPage> {
  final List<bool> reminders = [true, false, true];
  final List<TimeOfDay?> reminderTimes = [
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 21, minute: 0),
  ];
  final List<String> medicineNames = ['Paracetamol', 'Vitamin D', 'Antibiotic'];

  void _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: reminderTimes[index] ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => reminderTimes[index] = picked);
    }
  }

  void _editMedicineName(int index) {
    final controller = TextEditingController(text: medicineNames[index]);
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Edit Medicine Name'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter medicine name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() => medicineNames[index] = controller.text);
                  Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Not set';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medication Reminders')),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: ListView.builder(
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: Icon(
                  Icons.medication,
                  color: reminders[index] ? Colors.green : Colors.grey,
                ),
                title: Text(
                  '${medicineNames[index]} - ${['Morning', 'Afternoon', 'Night'][index]}',
                ),
                subtitle: Text('Time: ${_formatTime(reminderTimes[index])}'),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: reminders[index],
                      onChanged:
                          (val) => setState(() => reminders[index] = val),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editMedicineName(index),
                      tooltip: 'Edit Name',
                    ),
                  ],
                ),
                onTap: () => _pickTime(index),
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            reminders.add(true);
            reminderTimes.add(TimeOfDay.now());
            medicineNames.add('New Medicine');
          });
        },
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add),
      ),
    );
  }
}
