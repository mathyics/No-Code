import 'package:flutter/material.dart';

class TelemedicinePage extends StatelessWidget {
  const TelemedicinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = ['Dr. Ayesha', 'Dr. Rahul', 'Dr. Tanvi'];

    return Scaffold(
      appBar: AppBar(title: const Text('Telemedicine')),
      body: ListView(
        children: doctors.map((doc) {
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(doc),
              trailing: IconButton(
                icon: const Icon(Icons.video_call, color: Colors.green),
                onPressed: () {},
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
