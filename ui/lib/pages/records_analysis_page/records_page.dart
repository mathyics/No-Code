import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordsAnalysisPage extends StatefulWidget {
  const RecordsAnalysisPage({super.key});

  @override
  State<RecordsAnalysisPage> createState() => _RecordsAnalysisPageState();
}

class _RecordsAnalysisPageState extends State<RecordsAnalysisPage> {
  DateTimeRange? _selectedRange;
  bool _showChart = false;

  final List<Map<String, String>> _records = [
    {'date': '2025-05-01', 'bp': '120/80', 'hr': '72', 'remarks': 'Normal'},
    {'date': '2025-05-02', 'bp': '130/85', 'hr': '78', 'remarks': 'Slightly elevated'},
    {'date': '2025-05-03', 'bp': '125/82', 'hr': '75', 'remarks': 'Normal'},
    {'date': '2025-05-04', 'bp': '135/88', 'hr': '80', 'remarks': 'Monitor'},
  ];

  void _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedRange = picked;
      });
    }
  }

  List<Map<String, String>> get _filteredRecords {
    if (_selectedRange == null) return _records;
    return _records.where((r) {
      final date = DateTime.parse(r['date']!);
      return date.isAfter(_selectedRange!.start.subtract(const Duration(days: 1))) &&
          date.isBefore(_selectedRange!.end.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Records Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickDateRange,
                    icon: const Icon(Icons.date_range),
                    label: Text(_selectedRange == null
                        ? 'Select Date Range'
                        : '${_selectedRange!.start.month}/${_selectedRange!.start.day} - '
                        '${_selectedRange!.end.month}/${_selectedRange!.end.day}'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _showChart = !_showChart),
                    icon: Icon(_showChart ? Icons.table_chart : Icons.show_chart),
                    label: Text(_showChart ? 'Show Table' : 'Show Chart'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement export CSV functionality
                    },
                    icon: const Icon(Icons.file_download),
                    label: const Text('Export'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _showChart
                  ? Center(
                child: Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: Text('Chart Placeholder')),
                ),
              )
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('BP')),
                    DataColumn(label: Text('HR')),
                    DataColumn(label: Text('Remarks')),
                  ],
                  rows: _filteredRecords.map((r) => DataRow(cells: [
                    DataCell(Text(r['date']!)),
                    DataCell(Text(r['bp']!)),
                    DataCell(Text(r['hr']!)),
                    DataCell(Text(r['remarks']!)),
                  ])).toList(),
                ),
              ),
            ),
          ],
        ),
      )

    );
  }
}
