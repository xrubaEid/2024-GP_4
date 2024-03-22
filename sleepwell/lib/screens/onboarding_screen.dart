
import 'package:flutter/material.dart';
import 'package:sleepwell/screens/onboarding_data.dart';
import 'package:sleepwell/screens/signin_screen.dart';

class OnboardingScreen extends StatefulWidget {
    static String RouteScreen = 'onboarding_screen';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = OnboardingData();
  final pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd5defe),
      body: Column(
        children: [
          body(),
          buildDots(),
          button(),
        ],
      ),
       appBar: AppBar(
       actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const SignInScreen()));
            },
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Colors.blue,
                
              ),
            ),
          ),
       ],
       ),
    );
  }

  //Body
  Widget body(){
    return Expanded(
      child: Center(
        child: PageView.builder(
            onPageChanged: (value){
              setState(() {
                currentIndex = value;
              });
            },
            itemCount: controller.items.length,
            itemBuilder: (context,index){
             return Padding(
               padding: const EdgeInsets.symmetric(horizontal: 15),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   //Images
                   Image.asset(controller.items[currentIndex].image),

                   const SizedBox(height: 15),
                   //Titles
                   Text(controller.items[currentIndex].title,
                     style: 
                     const TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 16, 95, 199),
                      fontWeight: FontWeight.bold),
                     textAlign: TextAlign.center,),

                   //Description
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 15),
                     child: Text(controller.items[currentIndex].description,
                       style: const TextStyle(color: Colors.blue,fontSize: 16),textAlign: TextAlign.center,),
                   ),

                 ],
               ),
             );
        }),
      ),
    );
  }

  //Dots
  Widget buildDots(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.items.length, (index) => AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration:   BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromARGB(255, 16, 95, 199),
          ),
          height: 3,
          width: currentIndex == index? 30 : 7,
          duration: const Duration(milliseconds: 700))),
    );
  }

  //Button
  Widget button(){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width *.9,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:const Color(0xFF040E3B)
      ),

      child: TextButton(
        onPressed: (){
          setState(() {
            currentIndex != controller.items.length -1? currentIndex++ : null;
          });
        },
        child: Text(currentIndex == controller.items.length -1? "Get started" : "Continue",
          style: const TextStyle(color: Colors.white),),
      ),
      
    );
  }
}