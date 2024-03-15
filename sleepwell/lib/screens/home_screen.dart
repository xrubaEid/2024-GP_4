import 'package:flutter/material.dart';
import 'package:sleepwell/screens/alarm_screen.dart';

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
    AlarmScreen(),
    const Center(child: Text('Hello Dashboard')),
  ];
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 162, 165, 180),
          title: Text(''),
        ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
       onDestinationSelected: (index) {
  if (index != 2) {
    setState(() => this.index = index);
  } else {
    Navigator.pushNamed(context, AlarmScreen.RouteScreen);
  }
},
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
    icon: Icon(Icons.access_alarm_outlined),
    selectedIcon: Icon(Icons.access_alarm),
    label: 'Alarm',
    key: Key('alarm'),
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