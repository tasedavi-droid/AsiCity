import 'package:flutter/material.dart';
import '../services/report_service.dart';

class ReportListScreen extends StatelessWidget {
  final service = ReportService();

  ReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: service.getReports(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final data = docs[i];

            return Card(
              child: ListTile(
                title: Text(data["description"]),
                subtitle: Image.network(data["imageUrl"]),
              ),
            );
          },
        );
      },
    );
  }
}
