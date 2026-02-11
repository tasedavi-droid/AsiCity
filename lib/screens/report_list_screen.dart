import 'package:flutter/material.dart';
import '../services/report_service.dart';
import '../widgets/report_card.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListState();
}

class _ReportListState extends State<ReportListScreen> {

  String selectedCategory = "Todos";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),

      body: Column(
        children: [

          DropdownButton<String>(
            value: selectedCategory,
            items: [
              "Todos",
              "Infraestrutura",
              "Segurança",
              "Iluminação",
              "Limpeza",
              "Outros"
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {
              setState(() => selectedCategory = v!);
            },
          ),

          Expanded(
            child: StreamBuilder(
              stream: ReportService().getReports(category: selectedCategory),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reports = snapshot.data!;

                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (_, i) {
                    return ReportCard(report: reports[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}