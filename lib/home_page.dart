import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<HomeProvider>().fetchAll();
    });
  }

  Future<void> refreshHome() async {
    await context.read<HomeProvider>().fetchAll();
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFA7C7E7), 

      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color(0xFF458CCC), 
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: refreshHome,
            icon: provider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFFA7C7E7),
        child: ListView(
          children: [
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Menu",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // better contrast
                ),
              ),
            ),

            ListTile(
              title: const Text("Profile Page"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),

            ListTile(
              title: const Text("Medications"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/medications');
              },
            ),

            ListTile(
              title: const Text("Appointments"),
              onTap: () {
                Navigator.pushNamed(context, '/appointments');
              },
            ),

            ListTile(
              title: const Text("Vital Signs"),
              onTap: () {
                Navigator.pushNamed(context, '/vitals');
              },
            ),

            ListTile(
              title: const Text("BMI Calculator"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/bmi');
              },
            ),

            ListTile(
              title: const Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pop(context);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/signup',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            Card(
               color: const Color.fromARGB(255, 161, 161, 213),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Upcoming Medications",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    provider.upcomingMeds.isEmpty
                        ? const Text("No pending medications")
                        : Column(
                            children: provider.upcomingMeds.map((med) {
                              return ListTile(
                                title: Text(med["name"]),
                                subtitle: Text(med["time"]),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
               color: const Color.fromARGB(255, 161, 161, 213),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Last Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(provider.lastSummary),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: const Color.fromARGB(255, 161, 161, 213), 
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Vital Signs (Quick View)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    provider.vitals.isEmpty
                        ? const Text("No vitals available")
                        : Column(
                            children: provider.vitals.entries.map((entry) {
                              return ListTile(
                                title: Text(entry.key),
                                trailing: Text(entry.value),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}