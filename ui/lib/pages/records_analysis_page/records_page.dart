import 'package:flutter/material.dart';

class RecordsAnalysisPage extends StatelessWidget {
  const RecordsAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Records Analysis')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('BP')),
            DataColumn(label: Text('Heart Rate')),
            DataColumn(label: Text('Remarks')),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('2025-05-01')),
              DataCell(Text('120/80')),
              DataCell(Text('72')),
              DataCell(Text('Normal')),
            ]),
            DataRow(cells: [
              DataCell(Text('2025-05-02')),
              DataCell(Text('130/85')),
              DataCell(Text('78')),
              DataCell(Text('Slightly elevated')),
            ]),
          ],
        ),
      ),
    );
  }
}
