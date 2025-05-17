import 'package:flutter/material.dart';

class MedicationRemindersPage extends StatefulWidget {
  const MedicationRemindersPage({super.key});

  @override
  State<MedicationRemindersPage> createState() => _MedicationRemindersPageState();
}

class _MedicationRemindersPageState extends State<MedicationRemindersPage> {
  final List<bool> reminders = [true, false, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medication Reminders')),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          return SwitchListTile(
            title: Text('Medicine ${index + 1} - ${['Morning', 'Afternoon', 'Night'][index]}'),
            value: reminders[index],
            onChanged: (val) => setState(() => reminders[index] = val),
          );
        },
      ),
    );
  }
}
