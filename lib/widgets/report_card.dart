import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report_model.dart';

class ReportCard extends StatefulWidget {

  final ReportModel report;

  const ReportCard({
    super.key,
    required this.report,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {

  bool hovering = false;

  @override
  Widget build(BuildContext context) {

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: hovering
            ? (Matrix4.identity()..scale(1.02))
            : Matrix4.identity(),

        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 👤 USUÁRIO
                Row(
                  children: [

                    const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            widget.report.userEmail ?? "Usuário",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          Text(
                            _formatDate(widget.report.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// 🏷 CATEGORIA
                Text(
                  widget.report.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 8),

                /// 📝 DESCRIÇÃO
                Text(
                  widget.report.description,
                  style: const TextStyle(fontSize: 15),
                ),

                /// 🖼 IMAGEM (SE EXISTIR)
                if (widget.report.imageUrl != null &&
                    widget.report.imageUrl!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(widget.report.imageUrl!),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📅 FORMATADOR DATA SEGURO
  String _formatDate(Timestamp? timestamp) {

    if (timestamp == null) return "Agora";

    final date = timestamp.toDate();

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}