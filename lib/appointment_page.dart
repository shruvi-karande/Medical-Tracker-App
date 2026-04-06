import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appointment_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {

  Color getCardColor(String type) {
    return type == "Doctor"
        ? const Color(0xFFC8E6C9) 
        : const Color(0xFFFFE0B2);
  }


  IconData getIcon(String type) {
    return type == "Doctor"
        ? Icons.local_hospital
        : Icons.science;
  }

  void showAddDialog() {
    final provider = context.read<AppointmentProvider>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFAFAFA),
          title: const Text("Add Appointment"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: provider.appointmentType,
                  items: const [
                    DropdownMenuItem(value: "Doctor", child: Text("Doctor")),
                    DropdownMenuItem(value: "Lab Test", child: Text("Lab Test")),
                  ],
                  onChanged: (value) {
                    provider.setType(value!);
                  },
                  decoration: const InputDecoration(
                    labelText: "Type of Appointment",
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF458CCC),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      provider.setDate(date);
                    }
                  },
                  child: Text(provider.selectedDate == null
                      ? "Select Date"
                      : provider.selectedDate.toString().split(" ")[0]),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: provider.summaryController,
                  decoration: const InputDecoration(
                    labelText: "Doctor Summary",
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => provider.addAppointment(context),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF458CCC),
                foregroundColor: Colors.white,
              ),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget buildList() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("appointments")
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(
            child: Text(
              "No appointments added yet 📅\nClick + to add",
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView(
          children: docs.map((doc) {
            final appt = doc.data();

         return Card(
  color: getCardColor(appt["type"]),
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: ListTile(
    leading: Icon(
      getIcon(appt["type"]),
      color: const Color(0xFF458CCC),
    ),
    title: Text("${appt["type"]} Appointment"),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Date: ${appt["date"].toDate().toString().split(" ")[0]}"),
        Text("Medication Changed: ${appt["changed"] ? "Yes" : "No"}"),
        if (appt["summary"].isNotEmpty)
          Text("Summary: ${appt["summary"]}"),
      ],
    ),

   
    trailing: IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        String uid = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("appointments")
            .doc(doc.id) 
            .delete();
      },
    ),
  ),
);
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFA7C7E7),

      appBar: AppBar(
        title: const Text(
          "Appointments",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF458CCC),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF458CCC),
        onPressed: showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Container(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: buildList(),
        ),
      ),
    );
  }
}