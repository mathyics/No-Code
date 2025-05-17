import 'package:flutter/material.dart';

class AppointmentBookingPage extends StatelessWidget {
  const AppointmentBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final slots = ['10:00 AM', '11:00 AM', '2:00 PM', '4:00 PM'];

    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: ListView.builder(
        itemCount: slots.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: const Icon(Icons.access_time),
            title: Text('Available Slot: ${slots[index]}'),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text('Book'),
            ),
          ),
        ),
      ),
    );
  }
}
