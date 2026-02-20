import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../services/auth_service.dart';

class ReportCard extends StatelessWidget {

  final ReportModel report;
  final VoidCallback? onOpenComments;

  const ReportCard({
    super.key,
    required this.report,
    this.onOpenComments,
  });

  @override
  Widget build(BuildContext context) {

    final currentUser =
        AuthService().currentUser;

    final isOwner =
        currentUser?.uid == report.userId;

    return Card(
      margin: const EdgeInsets.all(10),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.userName ??
                      "Usuário",
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.bold),
                ),

                if (isOwner)
                  PopupMenuButton(
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: "delete",
                        child: Text("Deletar"),
                      )
                    ],
                    onSelected: (value) async {
                      if (value == "delete") {
                        await ReportService()
                            .deleteReport(
                                report.id);
                      }
                    },
                  )
              ],
            ),

            const SizedBox(height: 8),

            Text(report.category),

            const SizedBox(height: 8),

            Text(report.description),

            const SizedBox(height: 10),

            Row(
              children: [

                IconButton(
                  icon:
                      const Icon(Icons.thumb_up),
                  onPressed: () async {

                    final user =
                        AuthService()
                            .currentUser;

                    if (user == null) return;

                    await ReportService()
                        .addInteraction(
                      reportId: report.id,
                      userId: user.uid,
                      type: "like",
                    );
                  },
                ),

                Text(
                    report.likesCount.toString()),

                IconButton(
                  icon:
                      const Icon(Icons.comment),
                  onPressed: onOpenComments,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
