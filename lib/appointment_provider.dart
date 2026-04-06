import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final summaryController = TextEditingController();
  String appointmentType = "Doctor";
  DateTime? selectedDate;
  bool medicationChanged = false;

  Future<void> addAppointment(BuildContext context) async {
    if (selectedDate == null) return;

    String uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection("users")
        .doc(uid)
        .collection("appointments")
        .add({
      "type": appointmentType,
      "date": selectedDate,
      "changed": medicationChanged,
      "summary": summaryController.text,
      "timestamp": FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);

    summaryController.clear();
    selectedDate = null;
    medicationChanged = false;
    appointmentType = "Doctor";

    notifyListeners();
  }

  void setType(String value) {
    appointmentType = value;
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}