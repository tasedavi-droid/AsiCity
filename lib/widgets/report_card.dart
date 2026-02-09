import 'package:flutter/material.dart';
import '../models/report_model.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(report.description),
          Image.network(report.imageUrl),
        ],
      ),
    );
  }
}
