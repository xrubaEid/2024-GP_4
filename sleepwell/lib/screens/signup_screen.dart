import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sleepwell/widget/regsterbutton.dart';

class SignUpScreen extends StatefulWidget {
  static String RouteScreen = 'signup_screen';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
<<<<<<< HEAD
final _firestore=  FirebaseFirestore.instance ;
final _auth=FirebaseAuth.instance;
bool  showSpinner = false;
// why late because i well not give  it a value new 
 late String name;
 late String Lname;
 late String email;
 late String password ;
 late String cpassword ;
  
=======
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _submitForm() async {
  final form = _formKey.currentState;
  if (form != null && form.validate()) {
    form.save();

  
      // Sign-up successful, navigate to the desired screen
      Navigator.pushNamed(context, MyHomePage.RouteScreen);
    }
}

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

>>>>>>> 14db60dfe48377b3d80628dc1b225398df4e8cd3
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
<<<<<<< HEAD
        backgroundColor:  const Color.fromARGB(255, 0, 74, 173),
        title: const Text('') ,
        ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
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
             padding: const EdgeInsets.all(20),
             child: ListView(
              shrinkWrap: true,
              children: [ 
                 const SizedBox( height: 15,),
                 const Center(
                   child:  Text( 
                    'Let’s create  your account!',
                    style: TextStyle(
                     color: Colors.white,
                     fontSize: 20,
                     fontWeight: FontWeight.bold
                      ),),
                 ),
                  const SizedBox( height: 15,),
                 TextField(
                  keyboardType: TextInputType.name,
                  onChanged:(value) {
                    // here i save the  value of email from user 
                    name=value;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                     filled: true,
                     suffixIcon:const  Icon(Icons.person),
                     hintText:  ' First Name ',  
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),),
                 ),  
                 const SizedBox( height: 15,),
                 TextField(
                  keyboardType: TextInputType.name,
                  onChanged:(value) {
                    // here i save the  value of email from user 
                    Lname=value;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                     filled: true,
                     suffixIcon:const  Icon(Icons.person),
                     hintText:  ' Last Name ',  
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),),
                 ),  
                 const SizedBox( height: 15,),
                
                 TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged:(value) {
                    // here i save the  value of email from user 
                    email=value;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                     filled: true,
                     suffixIcon: const Icon(Icons.email),
                     hintText: 'Email Address' ,  
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),),
                 ),
                  const SizedBox( height: 15,),
                 TextField(
                  keyboardType: TextInputType.visiblePassword,
                  onChanged:(value) {
                    // here i save the  value of email from user 
                    password=value;
                  },
=======
        backgroundColor: Color.fromARGB(255, 0, 74, 173),
        title: const Text(''),
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
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 15,
                ),
                const Center(
                  child: Text(
                    'Let’s create  your account!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: const Icon(Icons.person),
                    hintText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.email),
                    hintText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: _validateEmail,
                  controller: _emailController,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
>>>>>>> 14db60dfe48377b3d80628dc1b225398df4e8cd3
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
<<<<<<< HEAD
                    suffixIcon:const  Icon(Icons.key),
                    hintText:'Password',  
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),),
                 ),
                 const SizedBox( height: 15,),
                 TextField(
                  keyboardType: TextInputType.visiblePassword,
                  onChanged:(value) {
                    // here i save the  value of email from user 
                    cpassword=value;
                  },
=======
                    suffixIcon: const Icon(Icons.key),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: _validatePassword,
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
>>>>>>> 14db60dfe48377b3d80628dc1b225398df4e8cd3
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
<<<<<<< HEAD
                    suffixIcon:const  Icon(Icons.key),
                   hintText:'Confirm Password',  
                    border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                     ),),
                 ),
                   const SizedBox( height: 30,),
                   regsterbutton(
                      color:const Color(0xffd5defe),
                      title:'Create Account',
                     onPressed: () async {
                     if (password.length >= 8 &&
                      password.contains(RegExp(r'\d')) &&
                       password == cpassword) {
                     try {
                        setState(() {
                        showSpinner = true;
                         });
                         final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                       final userId = newUser.user?.uid; // Access the UID of the newly created user
                       await _firestore.collection('Users').doc(userId).set({
                        'Email': email,
                        'Fname': name,
                        'Lname': Lname,
                        'Password': password,
                        });
                         
                       Navigator.pushNamed(context, SignUpScreen.RouteScreen);
                                                setState(() {
                          showSpinner = false;
                           });
                         } catch (e) {
                          setState(() {
                          showSpinner = false;
                           });
                           String errorMessage = '';
                           if (e is FirebaseAuthException) {
                            if (e.code == 'weak-password') {
                              errorMessage = 'Cause: Password is too weak.';
                               } else if (e.code == 'email-already-in-use') {
                                errorMessage = ' Email is already in use.';
                                 } else {
                                  errorMessage = ' An error occurred. Please try again later.';
                                  }
                                  } else {
                                      errorMessage = ' An error occurred. Please try again later.';
                                      }
                                      print('Sign-up error: $errorMessage');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                           content: Text(errorMessage),
                                           duration: const Duration(seconds: 3),
                                            ),
                                             );
                                             }
                                             } else {
                                               ScaffoldMessenger.of(context).showSnackBar(
                                                 const SnackBar(
                                                   content: Text(
                                                    'Please make sure the password is at least 8 characters long, contains a number, and matches the confirm password.',
                                                    ),
                                                       duration: Duration(seconds: 3),
                                                        ),
                                                         );
                                                          }
                                                          },
                                                          ),
                 ],
             ),
           ),
        ),
      ), 
    
=======
                    suffixIcon: const Icon(Icons.key),
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: _validateConfirmPassword,
                  controller: _confirmPasswordController,
                ),
              
                const SizedBox(
                  height: 30,
                ),
                regsterbutton(
                  color: Color(0xffd5defe),
                  title: 'Create Account',
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
>>>>>>> 14db60dfe48377b3d80628dc1b225398df4e8cd3
    );
  }
}