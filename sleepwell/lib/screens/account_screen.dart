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
  late String firstName;
  late String lastName;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
        signInUser = user;
        userId = user.uid;
        email = user.email!;
      });
      _fetchUserData();
      }
    } catch (e) {
      print(e);
    }
  }

  void _fetchUserData() async {
    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get();
    setState(() {
      firstName = userData['Fname'];
      lastName = userData['Lname'];
    });
  }

  @override
  Widget build(BuildContext context) {
     Color myColor = const Color.fromARGB(255, 0, 74, 173);
    return Scaffold(
       appBar: AppBar(
        backgroundColor: myColor,
        title:const Text('Account '),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(80.0, 60.0, 80.0, 40.0),
              child: Column(
                children: [
                   Text(
                        'Email: $email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ],
              ),
            ),),
      )
    );
  }
}
