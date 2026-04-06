import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool isLoading = false;

  Future<void> saveProfile({
    required String name,
    required String dob,
    required String gender,
    required String age,
    required String phone,
    required String height,
    required String weight,
    required String condition,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      String uid = FirebaseAuth.instance.currentUser!.uid;

      final data = {
        "name": name,
        "dob": dob,
        "gender": gender,
        "age": age,
        "phone": phone,
        "height": height,
        "weight": weight,
        "condition": condition,
        "createdAt": FieldValue.serverTimestamp(),
      };

      await _firestore.collection("users").doc(uid).set(data);

      userData = data;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }


  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      notifyListeners();

      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot doc =
          await _firestore.collection("users").doc(uid).get();

      if (doc.exists) {
        userData = doc.data() as Map<String, dynamic>;
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }
}