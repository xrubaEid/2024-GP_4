import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sleepwell/screens/home_screen.dart';
import 'package:sleepwell/widget/regsterbutton.dart';

class SignUpScreen extends StatefulWidget {
  static String RouteScreen ='signup_screen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
final _auth=FirebaseAuth.instance;
bool  showSpinner = false;
// why late because i well not give  it a value new 
 late String name;
 late String Lname;
 late String email;
 late String password ;
 late String cpassword ;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white ,
      appBar: AppBar(
        backgroundColor:  Color.fromARGB(255, 0, 74, 173),
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
             padding: EdgeInsets.all(20),
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
                     suffixIcon: Icon(Icons.email),
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
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
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
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon:const  Icon(Icons.key),
                   hintText:'Confirm Password',  
                    border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                     ),),
                 ),
                   const SizedBox( height: 30,),
                   regsterbutton(
                      color:Color(0xffd5defe),
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
                         if (newUser != null) {
                         Navigator.pushNamed(context, MyHomePage.RouteScreen);
                         }
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
    
    );
  }
}