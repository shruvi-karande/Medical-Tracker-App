import 'package:flutter/material.dart';
import 'package:frontend/profile_provider.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  String? selectedGender;
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final conditionController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dobController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {}); 
    }
  }

  Future<void> handleSave() async {
    if (nameController.text.isEmpty ||
        dobController.text.isEmpty ||
        selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill required fields")),
      );
      return;
    }

    try {
      await context.read<ProfileProvider>().saveProfile(
        name: nameController.text.trim(),
        dob: dobController.text.trim(),
        gender: selectedGender!,
        age: ageController.text.trim(),
        phone: phoneController.text.trim(),
        height: heightController.text.trim(),
        weight: weightController.text.trim(),
        condition: conditionController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Profile Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),

            const SizedBox(height: 10),

            TextField(
              controller: dobController,
              readOnly: true,
              decoration: const InputDecoration(labelText: "DOB"),
              onTap: _selectDate,
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedGender,
              items: const [
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(value: "Female", child: Text("Female")),
                DropdownMenuItem(value: "Other", child: Text("Other")),
              ],
              onChanged: (value) {
                selectedGender = value;
                setState(() {});
              },
              decoration: const InputDecoration(labelText: "Gender"),
            ),

            const SizedBox(height: 10),

            TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age")),

            const SizedBox(height: 10),

            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),

            const SizedBox(height: 10),

            TextField(controller: heightController, decoration: const InputDecoration(labelText: "Height")),

            const SizedBox(height: 10),

            TextField(controller: weightController, decoration: const InputDecoration(labelText: "Weight")),

            const SizedBox(height: 10),

            TextField(controller: conditionController, decoration: const InputDecoration(labelText: "Condition")),

            const SizedBox(height: 20),

            provider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: handleSave,
                    child: const Text("Save Profile"),
                  ),
          ],
        ),
      ),
    );
  }
}