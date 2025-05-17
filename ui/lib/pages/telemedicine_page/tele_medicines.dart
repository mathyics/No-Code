import 'package:flutter/material.dart';

class TelemedicinePage extends StatefulWidget {
  const TelemedicinePage({super.key});

  @override
  State<TelemedicinePage> createState() => _TelemedicinePageState();
}

class _TelemedicinePageState extends State<TelemedicinePage> {
  final List<Map<String, dynamic>> _doctors = [
    {'name': 'Dr. Ayesha', 'specialty': 'Cardiology', 'rating': 4.5, 'available': true},
    {'name': 'Dr. Rahul', 'specialty': 'Dermatology', 'rating': 4.0, 'available': false},
    {'name': 'Dr. Tanvi', 'specialty': 'Neurology', 'rating': 4.8, 'available': true},
    {'name': 'Dr. Kumar', 'specialty': 'Pediatrics', 'rating': 4.2, 'available': true},
    {'name': 'Dr. Gupta', 'specialty': 'Orthopedics', 'rating': 3.9, 'available': false},
  ];
  String _search = '';
  String _filterSpecialty = 'All';

  @override
  Widget build(BuildContext context) {
    final specialties = ['All'] + _doctors.map((d) => d['specialty'] as String).toSet().toList();
    final filtered = _doctors.where((d) {
      final matchesSearch = d['name'].toLowerCase().contains(_search.toLowerCase());
      final matchesSpec = _filterSpecialty == 'All' || d['specialty'] == _filterSpecialty;
      return matchesSearch && matchesSpec;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Telemedicine')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search doctor...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _search = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<String>(
              value: _filterSpecialty,
              items: specialties.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _filterSpecialty = val!),
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Filter by Specialty'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final d = filtered[i];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text(d['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d['specialty']),
                        Row(
                          children: List.generate(
                            5,
                                (idx) => Icon(
                              idx < d['rating'].floor() ? Icons.star : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: d['available'] ? () {} : null,
                      child: Text(d['available'] ? 'Call' : 'Offline'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}