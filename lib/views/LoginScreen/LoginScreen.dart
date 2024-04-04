// Importing necessary packages and files
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/controllers/LoginController.dart';
import 'package:trashtocash/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:trashtocash/endpoints/points.dart';
import 'package:trashtocash/views/OTPScreen/L_OTPScreen.dart';

// Defining a StatefulWidget for the LoginScreen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Initializing controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Initializing GetX controller for managing state
  final codeController = Get.put(LoginController());

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

  String formatMobileNumber(String mobileInput) {
    // Remove all non-numeric characters from the input
    String formattedMobileNumber = mobileInput.replaceAll(RegExp(r'[^0-9]'), '');

    // Check if the number starts with "0" and replace it with "94"
    if (formattedMobileNumber.startsWith('0')) {
      formattedMobileNumber = '94' + formattedMobileNumber.substring(1);
    }

    // Check if the number starts with "+94" and remove the "+"
    if (formattedMobileNumber.startsWith('+94')) {
      formattedMobileNumber = '94' + formattedMobileNumber.substring(3);
    }

    // Check if the number starts with "94" and remove any spaces
    if (formattedMobileNumber.startsWith('94')) {
      formattedMobileNumber = formattedMobileNumber.replaceAll(' ', '');
    }

    return formattedMobileNumber;
  }

  bool isValidMobileNumber(String number) {
    final RegExp regExp = RegExp(r'^(?:\+94|94|0)?\d{10}$');
    return regExp.hasMatch(number);
  }

  // Method to make HTTP request to get OTP
  Future<void> _getOTP() async {
    String telephone = phoneController.text;

    if(!isValidMobileNumber(telephone)){
      dialogOpen(context,"Invalid Number","The Mobile Number You Entered Was Invalid");
    }else{
      telephone = formatMobileNumber(telephone);

      var Urlapi = Points().apiUrl;
      var SendOtp = Points().otpSend;
      var CheckOtp = Points().otpCheck;

      try {
        final response = await http.get(Uri.parse('$Urlapi/$CheckOtp/$telephone'));
        if (response.statusCode == 200) {
          // If the response body is 'true', it means the user exists
          if(response.body.toLowerCase() == 'true'){
            final Map<String, dynamic> data = {
              'telephone': telephone,
            };
            String jsonBody = json.encode(data);
            try {
              final http.Response response = await http.post(
                Uri.parse('$Urlapi/$SendOtp/$telephone'),
                headers: {
                  'Content-Type': 'application/json',
                },
                body: jsonBody,
              );
              if (response.statusCode == 200) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LOTPScreen(
                        u_phone:telephone
                      ),
                    ),
                  );
              } else {
                print('Error during API request. Status code: ${response.statusCode}');
                dialogOpen(context, "Error", "Error Sending OTP, Please Try Again");
              }
            } catch (error) {
              dialogOpen(context, "Error", "Error Sending OTP, Please Try Again");
              print('Error: $error');
            }
          }else{
            dialogOpen(context, "User Dosen't Exists", "Please Sign Up Before You Log In");
          }
        } else {
          // Handle other status codes if needed
          print('Failed to load user data, status code: ${response.statusCode}');
          dialogOpen(context, "Login Error (${response.statusCode})", "An Error Occured, Please try Again");
        }
      } catch (e) {
        // Handle network errors
        print('Error: $e');
        dialogOpen(context, "Login Error ", "An Network Error Occured, Please try Again");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Getting screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/homeScreen');
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.iconColor,
              ),
            ),
            Spacer(),
            SizedBox(
              width: 150,
              child: Image.asset('assets/images/ttcLogoTransparent.png'),
            ),
          ],
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 35),
        width: screenWidth,
        height: screenHeight,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: screenHeight - AppBar().preferredSize.height - 30),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Login',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Enter your login details to access your account',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: AppColors.textGaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Image.asset(
                    'assets/images/login.png',
                    width: 400,
                    height: 400,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    height: 41,
                    child: GetBuilder<LoginController>(builder: (controller) {
                      return TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 15, 108, 133),
                              width: 0.5,
                            ),
                          ),
                          prefixIcon: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5.0),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: Text(
                              '+94', // Country code for Sri Lanka
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          suffixIcon: phoneController.text.length == 9
                              ? SizedBox(
                                  width: 50,
                                  child: Image.asset(
                                    'assets/images/ph.png',
                                    scale: 1.0,
                                  ),
                                )
                              : SizedBox(),
                          labelText: "Phone Number",
                          labelStyle: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 159, 159, 159),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (phoneController.text == '') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('WARNING'),
                              content: Text(
                                  'The user authentication number cannot be empty.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // Close the dialog
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        // Navigator.pushReplacementNamed(context, '/loginScreen');
                      } else {
                        _getOTP();
                      }
                    },
                    child: CustomButton(
                        text: "GET OTP",
                        height: 41,
                        width: screenWidth,
                        backgroundColor: AppColors.accentColor),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: AppColors.textGaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Platform.isIOS
                      ? SizedBox(
                          height: 30,
                        )
                      : SizedBox(
                          height: 0,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
