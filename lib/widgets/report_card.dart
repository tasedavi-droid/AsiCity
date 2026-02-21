import 'package:flutter/material.dart';

import '../models/report_model.dart';
import '../services/report_service.dart';
import '../services/auth_service.dart';

class ReportCard extends StatelessWidget {

  final ReportModel report;
  final VoidCallback onOpenComments;

  const ReportCard({
    super.key,
    required this.report,
    required this.onOpenComments,
  });

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    final isOwner = user != null && user.uid == report.userId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// USERNAME
            Text(
              report.userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 6),

            /// CATEGORIA
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4),
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                report.category,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Divider(height: 20),

            /// DESCRIÇÃO
            Text(
              report.description,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 10),

          /// AÇÕES
            Row(
              children: [

                /// LIKE ÚNICO
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: user == null
                      ? null
                      : () {
                          ReportService().addInteraction(
                            reportId: report.id,
                            userId: user.uid,
                            type: "like",
                          );
                        },
                ),

                Text("${report.likesCount}"),

                const SizedBox(width: 10),

                /// COMMENTS
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: onOpenComments,
                ),

                Text("${report.commentsCount}"),

                const Spacer(),

                /// EDITAR / DELETAR
                if (isOwner)
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == "delete") {
                        await ReportService()
                            .deleteReport(report.id);
                      }

                      if (value == "edit") {
                        final controller =
                            TextEditingController(
                                text: report.description);

                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title:
                                const Text("Editar Report"),
                            content: TextField(
                              controller: controller,
                            ),
                            actions: [
                              TextButton(
                                child:
                                    const Text("Salvar"),
                                onPressed: () async {
                                  await ReportService()
                                      .editReport(
                                    report.id,
                                    controller.text,
                                    report.category,
                                  );
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: "edit",
                        child: Text("Editar"),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Text("Deletar"),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

