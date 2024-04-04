// Importing necessary packages and files
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/views/HomePage/Home/Home.dart';
import 'package:trashtocash/views/HomePage/Machines/Locations.dart';
import 'package:trashtocash/views/HomePage/NavBar.dart';
import 'package:trashtocash/views/HomePage/Activity/PickUp.dart';
import 'package:trashtocash/views/HomePage/Pick_Up/GlassCans.dart';
import 'package:trashtocash/views/HomePage/Profile/Profile.dart';

// Defining a StatefulWidget for the HomePage
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0; // Index for bottom navigation bar
  String? user_id;
  String? name;
  String? email;
  String? mobile;
  String? pfp_link;
  String? isLogged;
  // List of screens for the bottom navigation bar
  final screens = [
    Home(),
    Machines(),
    GlassCans(),
    Activity(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      var args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      if (args['head'] != null && args['bod'] != null) {
        dialogOpen(context, args['head'], args['bod']);
      }
    });
  }

  dialogOpen(c,String h,String m){
    return showDialog(
      context: c,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(h),
          content: Text(m),
          actions: <Widget>[
            GestureDetector(
              onTap: (){
              // Close the dialog
              Navigator.of(dialogContext).pop();
            },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(), // Drawer for navigation
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu),
            color: AppColors.iconColor,
          );
        }),
        title: Row(
          children: [
            Spacer(),
            SizedBox(
              width: 150,
              child: Image.asset('assets/images/ttcLogoTransparent.png'),
            ),
            SizedBox(
              width: 10,
            ),
            
            GestureDetector(
              onTap: () {
                //Navigate to notifications
                Navigator.pushReplacementNamed(context, '/notifications');
              },
              child: Icon(
                Icons.notifications_none,
                color: AppColors.iconColor,
              ),
            ),
          ],
        ),
      ),
      body: screens[index], // Current screen based on index
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Color.fromARGB(255, 255, 255, 255),
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 15, 108, 133),
            ),
          ),
        ),
        child: NavigationBar(
          height: 75,
          backgroundColor: Color.fromARGB(255, 255, 254, 254),
          selectedIndex: index, // Selected index
          onDestinationSelected: (index) => setState(() =>
              this.index = index), // Callback when a destination is selected
          destinations: [
            NavigationDestination(
              // Home destination
              icon: Icon(
                Icons.home_outlined,
                size: 30,
                color: Color.fromARGB(255, 15, 108, 133),
              ),
              label: "Home",
            ),
            NavigationDestination(
              // Machines destination
              icon: Icon(
                Icons.location_on_outlined,
                size: 30,
                color: Color.fromARGB(255, 15, 108, 133),
              ),
              label: "Machines",
            ),
            NavigationDestination(
              // Pick ups destination
              icon: Icon(
                Icons.add_circle_sharp,
                size: 30,
                color: Color.fromARGB(255, 15, 108, 133),
              ),
              label: "Pick ups",
            ),
            NavigationDestination(
              // Activity destination
              icon: Icon(
                Icons.menu,
                size: 30,
                color: Color.fromARGB(255, 15, 108, 133),
              ),
              label: "Activity",
            ),
            NavigationDestination(
              // Profile destination
              icon: Icon(
                Icons.person_outline_rounded,
                size: 35,
                color: Color.fromARGB(255, 15, 108, 133),
              ),
              label: "Profile",
            )
          ],
        ),
      ),
    );
  }
}
