import 'package:flutter/material.dart';

class AppointmentBookingPage extends StatefulWidget {
  const AppointmentBookingPage({super.key});

  @override
  State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  DateTime _selectedDate = DateTime.now();
  final Map<String, bool> _slotStatus = {
    '10:00 AM': false,
    '11:00 AM': false,
    '2:00 PM': false,
    '4:00 PM': false,
  };
  String _filterPeriod = 'All';

  List<String> get _filteredSlots {
    return _slotStatus.keys.where((slot) {
      if (_filterPeriod == 'All') return true;
      final hour = int.parse(slot.split(':')[0]);
      if (_filterPeriod == 'Morning') return hour < 12;
      if (_filterPeriod == 'Afternoon') return hour >= 12;
      return true;
    }).toList();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _bookSlot(String slot) {
    setState(() => _slotStatus[slot] = true);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Confirmed'),
        content: Text('Your appointment on ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year} at $slot is booked.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.date_range),
                  label: Text('${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}'),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _filterPeriod,
                  items: ['All', 'Morning', 'Afternoon']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) => setState(() => _filterPeriod = val!),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredSlots.length,
                itemBuilder: (context, index) {
                  final slot = _filteredSlots[index];
                  final booked = _slotStatus[slot]!;
                  return Card(
                    color: booked ? Colors.grey[300] : null,
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(slot),
                      trailing: ElevatedButton(
                        onPressed: booked ? null : () => _bookSlot(slot),
                        child: Text(booked ? 'Booked' : 'Book'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
