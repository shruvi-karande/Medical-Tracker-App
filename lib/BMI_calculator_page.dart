import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BMIScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {

  final heightController = TextEditingController();
  final weightController = TextEditingController();

  String result = "";
  String category = "";

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;

    double heightInMeters = height / 100;

    double bmi = weight / (heightInMeters * heightInMeters);

    String bmiCategory;

    if (bmi < 18) {
      bmiCategory = "Underweight";
    } else if (bmi < 25) {
      bmiCategory = "Healthy";
    } else if (bmi < 30) {
      bmiCategory = "Overweight";
    } else {
      bmiCategory = "Obese";
    }

    setState(() {
      result = "BMI: ${bmi.toStringAsFixed(2)}";
      category = bmiCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7C7E7), 

      appBar: AppBar(
        title: const Text("BMI Calculator"),
        backgroundColor: const Color(0xFF458CCC), 
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter your height and weight to check your BMI score",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Height (cm)",
                  filled: true,
                  fillColor: Color(0xFFFAFAFA), 
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Weight (kg)",
                  filled: true,
                  fillColor: Color(0xFFFAFAFA), 
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF458CCC), 
                  foregroundColor: Colors.white,
                ),
                child: const Text("Calculate BMI"),
              ),

              const SizedBox(height: 20),

              Text(
                result,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}