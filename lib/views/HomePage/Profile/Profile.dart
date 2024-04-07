// Importing necessary packages and files
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trashtocash/endpoints/points.dart';
import 'package:http/http.dart' as http;

// Defining a StatefulWidget for the Profile
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Initializing controllers
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String? user_id;
  String? mobileHolder;
  String? pfp_link;
  String? created_at;
  String? updated_at;
  String? isLogged;
  
  Future<void> saveData(object) async {
  if (object["user"] is List) {
    List<Map<String, dynamic>> dataList = [];
    var user = object["user"][0]; // Get the user object directly
    String names = user["name"];
    String user_id = user["user_id"].toString();
    String fname = names.split(" ")[0];
    String lname = names.split(" ")[1];
    String email = user["email"];
    String mobile = user["mobile"];
    String pfp_link = user["pfp_link"];
    String created_at = user["created_at"].toString();
    String updated_at = user["updated_at"].toString();
    String isLogged = "true";
    Map<String, dynamic> mappedItems = {
      "user_id": user_id,
      "name": "$fname $lname",
      "email": email,
      "mobile": mobile,
      "pfp_link": pfp_link,
      "created_at": created_at,
      "updated_at": updated_at,
      "isLogged": isLogged,
    };
    dataList.add(mappedItems);
    final data2store = json.encode(dataList);
    Directory directory = await getApplicationDocumentsDirectory();
    String filepath = '${directory.path}/data.json';
    File file = File(filepath);
    await file.writeAsString(data2store);
  }
}

Future<void> readData() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = '${directory.path}/data.json';
      File file = File(filepath);
      String data = await file.readAsString();
      List<dynamic> decodedData = json.decode(data);
      for (var item in decodedData) {
        String names = item["name"];
        setState(() {
          user_id = item["user_id"];
          fnameController.text = names.split(" ")[0];
          lnameController.text = names.split(" ")[1];
          emailController.text = item["email"];
          numberController.text = '+${item["mobile"]?.substring(0, 2)} ${item["mobile"]?.substring(2, 4)} ${item["mobile"]?.substring(4, 7)} ${item["mobile"]?.substring(7)}';
          mobileHolder = item["mobile"];
          pfp_link = item["pfp_link"];
          created_at = item["created_at"];
          updated_at = item["updated_at"];
          isLogged = item["isLogged"];
        });
      }
    } catch (e) {
      print("Error reading data: $e");
    }
  }

  Future<void> LogOut() async {
    List<Map<String, dynamic>> dataList = [];
    Map<String, dynamic> mappedItems = {
      "user_id": user_id,
      "name": "${fnameController.text} ${lnameController.text}",
      "email": emailController.text,
      "mobile": mobileHolder,
      "pfp_link": pfp_link,
      "created_at": created_at,
      "updated_at": updated_at,
      "isLogged": "false",
    };
    dataList.add(mappedItems);
    final data2store = json.encode(dataList);
    Directory directory = await getApplicationDocumentsDirectory();
    String filepath = '${directory.path}/data.json';
    File file = File(filepath);
    await file.writeAsString(data2store);
  }

  @override
    void initState() {
      super.initState();
      readData();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Container(
                // width: screenWidth,
                height: 120,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      left: 0,
                      top: 0,
                      child: Container(
                        height: 85,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 203, 224, 227),
                          border: Border.all(
                            color: const Color.fromARGB(255, 203, 224, 227),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 15,
                      child: Container(
                        width: 60,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 203, 224, 227),
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 2.0,
                          ),
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
                    Positioned(
                      left: 110,
                      top: 22,
                      child: Column(
                        children: [
                          Text(
                            "${fnameController.text} ${lnameController.text}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Color.fromARGB(255, 15, 108, 133),
                            ),
                          ),
                          Text(
                            'Customer Status',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromARGB(255, 15, 108, 133),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 25,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/editProfile');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.iconColor,
                              width: 1.5,
                            ),
                            color: const Color.fromARGB(255, 217, 217, 217),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.edit,
                            color: AppColors.iconColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'First Name',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: const Color.fromARGB(255, 15, 108, 133),
                    ),
                  ),
                ],
              ),
              TextField(
                readOnly: true,
                controller: fnameController,
                style:
                    TextStyle(color: const Color.fromARGB(255, 15, 108, 133)),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(69, 15, 108, 133)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(69, 15, 108, 133)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Last Name',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: const Color.fromARGB(255, 15, 108, 133),
                    ),
                  ),
                ],
              ),
              TextField(
                readOnly: true,
                controller: lnameController,
                style:
                    TextStyle(color: const Color.fromARGB(255, 15, 108, 133)),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(69, 15, 108, 133)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(69, 15, 108, 133)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: const Color.fromARGB(255, 15, 108, 133),
                    ),
                  ),
                ],
              ),
              TextField(
                readOnly: true,
                controller: emailController,
                style:
                    TextStyle(color: const Color.fromARGB(255, 15, 108, 133)),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(69, 15, 108, 133)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(69, 15, 108, 133)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Phone Number',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: const Color.fromARGB(255, 15, 108, 133),
                    ),
                  ),
                ],
              ),
              TextField(
                readOnly: true,
                controller: numberController,
                style:
                    TextStyle(color: const Color.fromARGB(255, 15, 108, 133)),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(69, 15, 108, 133)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(69, 15, 108, 133)),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Temporary Account Deactivation',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: const Color.fromARGB(255, 15, 108, 133),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/deactivateProfile');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.iconColor,
                          width: 1.5,
                        ),
                        color: const Color.fromARGB(255, 217, 217, 217),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.iconColor,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 35,
              ),
              const Divider(
                height: 2,
                thickness: 1,
                color: const Color.fromARGB(69, 15, 108, 133),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  LogOut();
                  Navigator.pushReplacementNamed(context, '/splashScreen');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Log Out',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: const Color.fromARGB(255, 15, 108, 133),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.logout,
                      color: AppColors.iconColor,
                      size: 22,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              const Divider(
                height: 2,
                thickness: 1,
                color: const Color.fromARGB(69, 15, 108, 133),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
