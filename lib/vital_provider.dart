import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VitalProvider extends ChangeNotifier {
  String bp = "--/--";
  String heartRate = "--";
  String oxygen = "--";

  DateTime? bpDate;
  DateTime? hrDate;
  DateTime? oxDate;

  Future<void> saveVital({
    required String title,
    required String value,
  }) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("vitals")
        .add({
      "type": title,
      "value": value,
      "timestamp": DateTime.now(),
    });
  }

  Future<void> fetchValues() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("vitals")
        .orderBy("timestamp", descending: true)
        .get();

    for (var doc in snapshot.docs) {
      String type = doc["type"];
      String value = doc["value"];
      DateTime date = (doc["timestamp"] as Timestamp).toDate();

      if (type == "Blood Pressure") {
        bp = value;
        bpDate = date;
      } else if (type == "Heart Rate") {
        heartRate = value;
        hrDate = date;
      } else if (type == "Oxygen Saturation") {
        oxygen = value;
        oxDate = date;
      }
    }

    notifyListeners();
  }

  void updateBP(String val) {
    bp = val;
    bpDate = DateTime.now();
    notifyListeners();
  }

  void updateHeartRate(String val) {
    heartRate = val;
    hrDate = DateTime.now();
    notifyListeners();
  }

  void updateOxygen(String val) {
    oxygen = val;
    oxDate = DateTime.now();
    notifyListeners();
  }
}