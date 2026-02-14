import 'package:flutter/material.dart';

import '../../models/report_model.dart';
import '../../services/auth_service.dart';
import '../../services/report_service.dart';
import '../../screens/comments_screen.dart';

class ReportCard extends StatelessWidget {

  final ReportModel report;

  const ReportCard({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {

    final user = AuthService().currentUser;
    final isOwner = user?.uid == report.userId;

    return Card(
      margin: const EdgeInsets.all(12),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 👤 USER
            Row(
              children: [

                const CircleAvatar(child: Icon(Icons.person)),

                const SizedBox(width: 10),

                Text(
                  report.userName ?? "Usuário",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                /// ✏️ EDITAR
                if (isOwner)
                  PopupMenuButton(
                    itemBuilder: (_) => [

                      const PopupMenuItem(
                        value: "edit",
                        child: Text("Editar"),
                      ),

                      const PopupMenuItem(
                        value: "delete",
                        child: Text("Excluir"),
                      ),
                    ],

                    onSelected: (value) {

                      if (value == "delete") {

                        ReportService().deleteReport(report.id);

                      } else {

                        _showEditDialog(context);
                      }
                    },
                  )
              ],
            ),

            const SizedBox(height: 10),

            Text(report.category,
                style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 6),

            Text(report.description),

            const SizedBox(height: 12),

            /// ❤️ AÇÕES
            Row(
              children: [

                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () =>
                      ReportService().toggleLike(report.id),
                ),

                Text(report.likesCount.toString()),

                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CommentsScreen(reportId: report.id),
                      ),
                    );
                  },
                ),

                Text(report.commentsCount.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// 🔥 EDIT DIALOG
  void _showEditDialog(BuildContext context) {

    final descController = TextEditingController(text: report.description);
    String category = report.category;

    showDialog(
      context: context,
      builder: (_) {

        return AlertDialog(
          title: const Text("Editar Report"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),

              DropdownButtonFormField(
                value: category,
                items: [
                  "Infraestrutura",
                  "Segurança",
                  "Iluminação",
                  "Limpeza",
                  "Outros"
                ]
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => category = v!,
              ),
            ],
          ),

          actions: [

            TextButton(
              child: const Text("Salvar"),
              onPressed: () {

                ReportService().updateReport(
                  reportId: report.id,
                  category: category,
                  description: descController.text,
                );

                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
