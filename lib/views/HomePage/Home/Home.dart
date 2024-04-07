// Importing necessary packages and files
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/views/HomePage/Promotions/LRedeemables/LRedeemables.dart';
import 'package:trashtocash/widgets/custom_button.dart';
import 'package:trashtocash/endpoints/points.dart';
import 'package:http/http.dart' as http;
import 'package:trashtocash/views/RegisterScreen/register.dart';
import 'package:path_provider/path_provider.dart';

// Defining a StatefulWidget for the Home
class Home extends StatefulWidget {
  const Home({super.key});
  
  // hello();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? user_id;
  String? name;
  String? email;
  String? mobile;
  String? pfp_link;
  String? isLogged;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
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
      for (var item in decodedData) {
        print(item['id']);
        setState(() {
          user_id = item["user_id"];
          name = item["name"];
          email = item["email"];
          mobile = item["mobile"];
          pfp_link = item["pfp_link"];
          isLogged = item["isLogged"];
        });
      }
    } catch (e) {
      print("Error reading data: $e");
    }
  }

  // Data for the pie chart
  Map<String, double> dataMap = {
    "T2C Home Points": 20,
    "T2C Machine Points": 60,
    "T2C Drop Off Points": 30,
  };

  // Colors for the pie chart segments
  List<Color> colorList = [
    Color.fromARGB(255, 98, 187, 71),
    Color.fromARGB(255, 255, 122, 0),
    Color.fromARGB(255, 15, 108, 133),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 440,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      left: 0,
                      top: 0,
                      child: Container(
                        height: 265,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 203, 224, 227),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 60,
                      left: 60,
                      top: 15,
                      child: Container(
                        height: 85,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 80,
                      top: 30,
                      child: Container(
                        width: 60,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 203, 224, 227),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.network(
                            '${Points().phpImageUrl}/$pfp_link',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Observer(
                      builder: (_) => Positioned(
                        left: 85,
                        top: 33,
                        child: Text(
                          name!,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color.fromARGB(255, 15, 108, 133),
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   left: 85,
                    //   top: 33,
                    //   child: Text(
                    //     registerData.username,
                    //     style: GoogleFonts.poppins(
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 16,
                    //       color: Color.fromARGB(255, 15, 108, 133),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      left: 85,
                      top: 55,
                      child: Text(
                        '+${mobile?.substring(0, 2)} ${mobile?.substring(2, 4)} ${mobile?.substring(4, 7)} ${mobile?.substring(7)}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color.fromARGB(255, 15, 108, 133),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 60,
                      left: 60,
                      top: 130,
                      bottom: 45,
                      child: Container(
                        height: 85,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    // Pie chart showing points distribution
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: PieChart(
                        dataMap: dataMap,
                        colorList: colorList,
                        chartRadius: 190,
                        initialAngleInDegree: 270,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 14,
                        animationDuration: Duration(seconds: 2),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValues: false,
                        ),
                        legendOptions: LegendOptions(
                          showLegends: true,
                          legendTextStyle: TextStyle(fontSize: 8),
                          legendPosition: LegendPosition.bottom,
                          showLegendsInRow: true,
                        ),
                      ),
                    ),
                    // Icon indicating currency exchange
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 205,
                      child: Icon(
                        Icons.currency_exchange,
                        color: const Color.fromARGB(255, 15, 108, 133),
                        size: 30,
                      ),
                    ),
                    // Displaying total points
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 140,
                      child: Column(
                        children: [
                          Text(
                            '540',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 26,
                              color: Color.fromARGB(255, 15, 108, 133),
                            ),
                          ),
                          Text(
                            'T2C Points',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color.fromARGB(188, 15, 108, 133),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Buttons for credit and redeem history
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/historyCR');
                    },
                    child: CustomButton(
                      text: "credit history".toUpperCase(),
                      height: 56,
                      width: 150,
                      backgroundColor: AppColors.accentColor,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/historyCR');
                    },
                    child: CustomButton(
                      text: "redeem history".toUpperCase(),
                      height: 56,
                      width: 150,
                      backgroundColor: AppColors.accentColor,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Section title for offers
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Offers for you',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.textColor,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/promotions');
                      },
                      child: Text(
                        'View all offers >',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // List of redeemable offers
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    LRedeemables(),
                    LRedeemables(),
                    LRedeemables(),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
