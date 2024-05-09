import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _auth = FirebaseAuth.instance;
  late User signInUser;
  late String userId;
  late String email;

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        userId = user.uid;
        email = user.email!;
        final doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();
        return doc.data();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color.fromARGB(255, 0, 74, 173);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        title: const Text('Account'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        // Removed SafeArea
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == null) {
              return const Center(child: Text("No user data available"));
            } else {
              final userData = snapshot.data!;
              final firstName = userData['Fname'] ?? 'N/A';
              final lastName = userData['Lname'] ?? 'N/A';
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    SizedBox(height: 20),
                    Text(
                      'Email: $email',
                      style: TextStyle(
=======
                    const SizedBox(height: 20),
                    Text(
                      'Email: $email',
                      style: const TextStyle(
>>>>>>> 8179d31e3a942c8b14e3c497cd7f96bf200bcbe8
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Name: $firstName $lastName',
<<<<<<< HEAD
                      style: TextStyle(
=======
                      style: const TextStyle(
>>>>>>> 8179d31e3a942c8b14e3c497cd7f96bf200bcbe8
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}