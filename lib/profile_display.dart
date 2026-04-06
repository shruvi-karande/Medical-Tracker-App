import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_provider.dart';

class ProfileDisplayPage extends StatefulWidget {
  const ProfileDisplayPage({super.key});

  @override
  State<ProfileDisplayPage> createState() => _ProfileDisplayPageState();
}

class _ProfileDisplayPageState extends State<ProfileDisplayPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProfileProvider>().fetchProfile();
    });
  }


  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<ProfileProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFA7C7E7),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final userData = provider.userData;

    return Scaffold(
      backgroundColor: const Color(0xFFA7C7E7), 

      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF458CCC),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            buildRow("Name", userData?["name"] ?? ""),
            buildRow("DOB", userData?["dob"] ?? ""),
            buildRow("Gender", userData?["gender"] ?? ""),
            buildRow("Age", userData?["age"] ?? ""),
            buildRow("Phone", userData?["phone"] ?? ""),
            buildRow("Height", userData?["height"] ?? ""),
            buildRow("Weight", userData?["weight"] ?? ""),
            buildRow("Condition", userData?["condition"] ?? ""),

          ],
        ),
      ),
    );
  }
}