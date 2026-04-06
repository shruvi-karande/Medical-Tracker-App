import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:frontend/signup_page.dart';
import 'package:frontend/profile_page.dart';
import 'package:frontend/home_page.dart';
import 'package:frontend/appointment_page.dart';
import 'package:frontend/vital_signs_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/medication_page.dart';
import 'package:frontend/profile_display.dart';
import 'package:frontend/BMI_calculator_page.dart';
import 'package:frontend/profile_provider.dart'; 
import 'package:provider/provider.dart';
import 'package:frontend/home_provider.dart';
import 'package:frontend/appointment_provider.dart';
import 'package:frontend/vital_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ChangeNotifierProvider(create: (_) => VitalProvider()),
    ],
    child: const MyApp(),
  ),
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      routes: {
        '/medications': (context) => MedicationPage(),
        '/appointments': (context) => AppointmentPage(),
        '/vitals': (context) => VitalSignsPage(),
        '/profile': (context) => ProfileDisplayPage(),
        '/bmi': (context) => BMIScreen(),
        '/signup': (context) => const SignUpPage(),
      },
      theme: ThemeData(
        fontFamily: 'Cera Pro',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      home: const SignUpPage(),
    );
  }
}