import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'vital_provider.dart';

class VitalSignsPage extends StatefulWidget {
  const VitalSignsPage({super.key});

  @override
  State<VitalSignsPage> createState() => _VitalSignsPageState();
}

class _VitalSignsPageState extends State<VitalSignsPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<VitalProvider>().fetchValues();
    });
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Not updated";
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Widget buildCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required DateTime? lastUpdated,
    required VoidCallback onAdd,
    required VoidCallback onEdit,
  }) {
    return Card(
      color: color,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          unit,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  "Last edited: ${formatDate(lastUpdated)}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA), // off-white
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onAdd,
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Color(0xFF458CCC)),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: onEdit,
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Color(0xFF458CCC)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }

  void showInputDialog(String title, Function(String) onSave) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFAFAFA),
          title: Text("Enter $title"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFFAFAFA),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Color(0xFF458CCC)),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<VitalProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFA7C7E7), 
      appBar: AppBar(
        title: const Text("Vital Signs"),
        backgroundColor: const Color(0xFF458CCC),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            buildCard(
              title: "Blood Pressure",
              value: provider.bp,
              unit: "",
              color: const Color(0xFFFFE0B2), 
              lastUpdated: provider.bpDate,
              onAdd: () {
                showInputDialog("BP", (val) async {
                  provider.updateBP(val);
                  await provider.saveVital(title: "Blood Pressure", value: val);
                });
              },
              onEdit: () {
                showInputDialog("BP", (val) async {
                  provider.updateBP(val);
                  await provider.saveVital(title: "Blood Pressure", value: val);
                });
              },
            ),

            buildCard(
              title: "Heart Rate",
              value: provider.heartRate,
              unit: "bpm",
              color: const Color(0xFFBBDEFB), 
              lastUpdated: provider.hrDate,
              onAdd: () {
                showInputDialog("Heart Rate", (val) async {
                  provider.updateHeartRate(val);
                  await provider.saveVital(title: "Heart Rate", value: val);
                });
              },
              onEdit: () {
                showInputDialog("Heart Rate", (val) async {
                  provider.updateHeartRate(val);
                  await provider.saveVital(title: "Heart Rate", value: val);
                });
              },
            ),

            buildCard(
              title: "Oxygen Saturation",
              value: provider.oxygen,
              unit: "%",
              color: const Color(0xFFD1C4E9), 
              lastUpdated: provider.oxDate,
              onAdd: () {
                showInputDialog("SpO2", (val) async {
                  provider.updateOxygen(val);
                  await provider.saveVital(title: "Oxygen Saturation", value: val);
                });
              },
              onEdit: () {
                showInputDialog("SpO2", (val) async {
                  provider.updateOxygen(val);
                  await provider.saveVital(title: "Oxygen Saturation", value: val);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}