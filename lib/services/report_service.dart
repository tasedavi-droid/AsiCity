import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class ReportService {
  final _db = FirebaseFirestore.instance;

  Future createReport(ReportModel report) async {
    await _db.collection("reports").add(report.toMap());
  }

  Stream<QuerySnapshot> getReports() {
    return _db.collection("reports").snapshots();
  }
}