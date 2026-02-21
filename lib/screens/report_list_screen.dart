import 'package:flutter/material.dart';

import '../models/report_model.dart';
import '../services/report_service.dart';
import '../widgets/report_card.dart';
import 'comments_screen.dart';

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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final reports = snapshot.data!;

          if (reports.isEmpty) {
            return const Center(
              child: Text("Nenhum report ainda"),
            );
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (_, i) {
              final report = reports[i];

              return ReportCard(
                report: report,
                onOpenComments: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CommentsScreen(reportId: report.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}