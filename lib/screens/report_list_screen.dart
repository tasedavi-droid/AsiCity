import 'package:flutter/material.dart';
import '../services/report_service.dart';
import '../widgets/report_card.dart';
import '../models/report_model.dart';

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),

      body: StreamBuilder<List<ReportModel>>(
        stream: ReportService().getReports(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data!;

          if (reports.isEmpty) {
            return const Center(child: Text("Nenhum report"));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              return ReportCard(report: reports[index]);
            },
          );
        },
      ),
    );
  }
}
