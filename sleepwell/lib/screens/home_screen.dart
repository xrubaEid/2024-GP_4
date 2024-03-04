import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
   static String RouteScreen ='home_screen';
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index =2;
  final pages =[
    const Center(child: Text('Hello  profile ')),
    const Center(child: Text('Hello  statistic  ')),
    const Center(child: Text('Hello Alarm ')),
    const Center(child: Text('Hello Dashboard')),
  ];
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (index) => setState(()=> this.index = index) ,
        backgroundColor: Color.fromARGB(255, 162, 165, 180),
        height: 70,
        destinations: const [
          NavigationDestination(
            icon:Icon( Icons.person_outlined ),
            selectedIcon:Icon( Icons.person ), 
            label:'profile',
            ),
             NavigationDestination(
            icon:Icon( Icons.align_vertical_bottom_outlined ),
            selectedIcon:Icon( Icons.align_vertical_bottom ), 
            label:'Statistic',
            ),
             NavigationDestination(
            icon:Icon( Icons.access_alarm_outlined ),
            selectedIcon:Icon( Icons.access_alarm ), 
            label:'Alarm',
            ),
             NavigationDestination(
            icon:Icon( Icons.dashboard_customize_outlined ),
            selectedIcon:Icon( Icons.dashboard_customize ), 
            label:'Dashboard',
            ),
        ],
      ),
     
     body:pages[index],
    
   
      );
  } 
}
