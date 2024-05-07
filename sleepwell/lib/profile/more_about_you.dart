import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MoreAboutYou extends StatefulWidget {
  static String RouteScreen = 'moreAboutYou';

  @override
  _MoreAboutYouState createState() => _MoreAboutYouState();
}

class _MoreAboutYouState extends State<MoreAboutYou> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final TextEditingController answerController = TextEditingController();
  List<String> answers = [];
  late User _currentUser; // Updated to use the Firebase User class
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        setState(() {
          _currentUser = user;
        });

        await retrieveAnswers();
      }
    } catch (e) {
      print('Error retrieving user: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> retrieveAnswers() async {
    try {
      DocumentSnapshot snapshot =
          await usersCollection.doc(_currentUser.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;

        answers = [
          data['answerQ1'] ?? '',
          data['answerQ2'] ?? '',
          data['answerQ3'] ?? '',
          data['answerQ4'] ?? '',
          data['answerQ5'] ?? '',
          data['answerQ6'] ?? '',
          data['answerQ7'] ?? '',
          data['answerQ8'] ?? '',
          data['answerQ9'] ?? '',
          data['answerQ10'] ?? '',
        ];

        setState(() {});
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error retrieving answers: $e');
    }
  }

  void updateAnswer(int index, String newAnswer) async {
    try {
      Map<String, dynamic> updatedData = {
        'answerQ${index + 1}': newAnswer,
      };

      await usersCollection.doc(_currentUser.uid).update(updatedData);

      answers[index] = newAnswer;

      setState(() {});
    } catch (e) {
      print('Error updating answer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('More About You'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF004AAD),
          title: const Text('More About You'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF004AAD), Color(0xFF040E3B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Q1: How consistent is your sleep schedule?',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Q2: Do you have a regular bedtime routine?',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    '''Q3:How often do you wake up tired in the morning?
Q4:How much sleep do you usually get at night?
Q5:How long does it take to fall asleep after you get into bed?
Q6: Do you use your smartphone within 30 minutes before bedtime?
Q7:Do you consume caffeine close to bedtime?
Q8:When do you typically stop consuming coffee, tea, smoking, and other substances before bedtime?
Q9:What activities do you typically engage in during the two hours leading up to your bedtime?
Q10:Do you frequently consume food or snacks during the night? 
                    ''',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  
              
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'Answer question ${index + 1}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          answers[index],
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Edit Answer'),
                                  content: TextField(
                                    controller: answerController,
                                    decoration: const InputDecoration(
                                      labelText: 'Answer',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Save'),
                                      onPressed: () {
                                        updateAnswer(
                                            index, answerController.text);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}