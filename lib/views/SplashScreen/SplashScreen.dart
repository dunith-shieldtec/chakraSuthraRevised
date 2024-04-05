import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trashtocash/views/HomePage/HomePage.dart';
import 'package:trashtocash/views/HomeScreen/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      readData();
    });
  }

  Future<void> readData() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = '${directory.path}/data.json';
      File file = File(filepath);
      String data = await file.readAsString();
      List<dynamic> decodedData = json.decode(data);
      bool isLogged = false;
      for (var item in decodedData) {
        if (item["isLogged"] == "true") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      }
      
    } catch (e) {
      print("Error reading data: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
              ),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset('assets/images/chakraLogo.png'),
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
