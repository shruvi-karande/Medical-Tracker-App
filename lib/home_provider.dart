import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;

  List<Map<String, dynamic>> upcomingMeds = [];
  String lastSummary = "Loading...";
  Map<String, String> vitals = {};

  Future<void> fetchAll() async {
    isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchMedications(),
      fetchSummary(),
      fetchVitals(),
    ]);

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMedications() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("medications")
        .orderBy("createdAt", descending: true)
        .get();

    List<Map<String, dynamic>> temp = [];

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      if (data["taken"] == false) {
        temp.add({
          "name": data["name"],
          "time": data["time"],
        });
      }
    }

    upcomingMeds = temp;
    notifyListeners();
  }

  Future<void> fetchSummary() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("appointments")
        .orderBy("date", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      lastSummary = data["summary"] ?? "No summary available";
    } else {
      lastSummary = "No records available";
    }

    notifyListeners();
  }

  Future<void> fetchVitals() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("vitals")
        .get();

    Map<String, String> temp = {};

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      String type = data["type"].toString();
      String value = data["value"].toString();

      temp[type] = value;
    }

    vitals = temp;
    notifyListeners();
  }
}