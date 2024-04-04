// Importing necessary packages and files
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/views/HomeScreen/HomeScreen.dart';
import 'package:path_provider/path_provider.dart';

// Defining a StatefulWidget for the SplashScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // Getting screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLogged;

    Future<void> readData() async {
      try {
        Directory directory = await getApplicationDocumentsDirectory();
        String filepath = '${directory.path}/data.json';
        File file = File(filepath);
        String data = await file.readAsString();
        List<dynamic> decodedData = json.decode(data);
        for (var item in decodedData) {
          if(item["isLogged"]=="true"){
            setState(() {
              isLogged = true;
            });
          }else{
            setState(() {
              isLogged = false;
            });
          }
        }
      } catch (e) {
        print("Error reading data: $e");
        setState(() {
          isLogged = false;
        });
      }
    }

    @override
    void initState() {
      super.initState();
      readData();
    }

    // Timer to navigate to HomeScreen after 2 seconds
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      ),
    );

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(), 
            Image.asset('assets/images/ttcLogo.png'), 
            Spacer(), 
            Text(
              'By', 
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 21,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset(
                  'assets/images/chakraLogo.png'), 
            ),
            SizedBox(
              height: 50,
            ), 
          ],
        ),
      ),
    );
  }
}
