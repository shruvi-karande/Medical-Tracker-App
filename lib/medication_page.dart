import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> medications = [];

  final nameController = TextEditingController();
  final dosageController = TextEditingController();

  TimeOfDay? selectedTime;
  DateTime? startDate;
  int duration = 1;

  bool isMorning = false;
  bool isAfternoon = false;
  bool isNight = false;

  @override
  void initState() {
    super.initState();
    loadMedications();
  }

  Color getCardColor(String group) {
    switch (group) {
      case "Morning":
        return const Color(0xFFFFE0B2);
      case "Afternoon":
        return const Color(0xFFBBDEFB);
      case "Night":
        return const Color(0xFFD1C4E9);
      default:
        return const Color(0xFFFAFAFA);
    }
  }

  Future<void> addMedication() async {
    if (nameController.text.isEmpty || selectedTime == null) return;

    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      List<String> selectedGroups = [];

      if (isMorning) selectedGroups.add("Morning");
      if (isAfternoon) selectedGroups.add("Afternoon");
      if (isNight) selectedGroups.add("Night");

      if (selectedGroups.isEmpty) return;

      for (String group in selectedGroups) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("medications")
            .add({
          "name": nameController.text,
          "dosage": dosageController.text,
          "time": "${selectedTime!.hour}:${selectedTime!.minute}",
          "group": group,
          "taken": false,
          "startDate": startDate?.toString(),
          "duration": duration,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      await loadMedications();

      Navigator.pop(context);

   
      nameController.clear();
      dosageController.clear();
      selectedTime = null;
      isMorning = false;
      isAfternoon = false;
      isNight = false;
    } catch (e) {
      print("Error: $e");
    }
  }

  
  Future<void> loadMedications() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("medications")
          .get();

      List<Map<String, dynamic>> loaded = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        List<String> parts = data["time"].split(":");

        loaded.add({
          "id": doc.id,
          "name": data["name"],
          "dosage": data["dosage"],
          "time": TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          ),
          "group": data["group"],
          "taken": data["taken"],
        });
      }

      setState(() {
        medications = loaded;
      });
    } catch (e) {
      print("Load error: $e");
    }
  }


  void showAddDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFAFAFA),
            title: const Text("Add Medication"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Medicine Name",
                      filled: true,
                    ),
                  ),
                  TextField(
                    controller: dosageController,
                    decoration: const InputDecoration(
                      labelText: "Dosage",
                      filled: true,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF458CCC),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setStateDialog(() {
                          selectedTime = time;
                        });
                      }
                    },
                    child: Text(
                      selectedTime == null
                          ? "Select Time"
                          : selectedTime!.format(context),
                    ),
                  ),

                  const SizedBox(height: 10),

                  CheckboxListTile(
                    title: const Text("Morning"),
                    value: isMorning,
                    onChanged: (val) {
                      setStateDialog(() {
                        isMorning = val!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Afternoon"),
                    value: isAfternoon,
                    onChanged: (val) {
                      setStateDialog(() {
                        isAfternoon = val!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Night"),
                    value: isNight,
                    onChanged: (val) {
                      setStateDialog(() {
                        isNight = val!;
                      });
                    },
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
                        setStateDialog(() {
                          startDate = date;
                        });
                      }
                    },
                    child: Text(
                      startDate == null
                          ? "Select Start Date"
                          : startDate.toString().split(" ")[0],
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Duration (days)",
                      filled: true,
                    ),
                    onChanged: (val) {
                      duration = int.tryParse(val) ?? 1;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: addMedication,
                child: const Text(
                  "Add",
                  style: TextStyle(color: Color(0xFF458CCC)),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

  Widget buildSection(String title) {
    final items = medications.where((m) => m["group"] == title).toList();

    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...items.map((med) {
          return Card(
            color: getCardColor(med["group"]),
            elevation: 4,
            child: ListTile(
              title: Text("${med["name"]} (${med["dosage"]}) mg"),
              subtitle: Text(
                "${med["group"]} • ${med["time"].format(context)}",
              ),
              trailing: Checkbox(
                activeColor: const Color(0xFF458CCC),
                value: med["taken"] ?? false,
                onChanged: (value) async {
                  setState(() {
                    med["taken"] = value;
                  });

                  String uid = FirebaseAuth.instance.currentUser!.uid;

                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .collection("medications")
                      .doc(med["id"])
                      .update({"taken": value});

                  await loadMedications();
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7C7E7),
      appBar: AppBar(
        title: const Text("Medication Tracker"),
        backgroundColor: const Color(0xFF458CCC),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF458CCC),
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: medications.isEmpty
            ? const Center(
                child: Text("No medications added yet 💊"),
              )
            : ListView(
                children: [
                  buildSection("Morning"),
                  buildSection("Afternoon"),
                  buildSection("Night"),
                ],
              ),
      ),
    );
  }
}