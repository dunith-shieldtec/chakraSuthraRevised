// Importing necessary packages and files
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/widgets/custom_button.dart';
import 'package:trashtocash/controllers/LoginController.dart';
import 'package:trashtocash/endpoints/points.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


// Defining a StatefulWidget for the LOTPScreen
class LOTPScreen extends StatefulWidget {
  final String u_phone;
  const LOTPScreen({required this.u_phone});

  @override
  State<LOTPScreen> createState() => _LOTPScreenState();
}

class _LOTPScreenState extends State<LOTPScreen> {
  late TextEditingController pinController;

  // Initializing controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  // final TextEditingController pinController = TextEditingController();
  final codeController = Get.put(LoginController());
  int _remainingSeconds =
      60; // Variable to store remaining seconds for OTP resend
  Timer? _countdownTimer; // Timer for countdown

  @override
  void initState() {
    super.initState();
    String? generatedOTP = Get.arguments;
    pinController = TextEditingController(text: generatedOTP);
    startCountdown();
    setState(() {
      phoneController.text = widget.u_phone.substring(2, 4) + " " + widget.u_phone.substring(4, 7) + " " + widget.u_phone.substring(7);
    });
  } 

  Future<void> saveData(object) async {
  if (object["user"] is List) {
    List<Map<String, dynamic>> dataList = [];
    var user = object["user"][0]; // Get the user object directly
    String user_id = user["user_id"].toString();
    String name = user["name"];
    String email = user["email"];
    String mobile = user["mobile"];
    String pfp_link = user["pfp_link"];
    String created_at = user["created_at"].toString();
    String updated_at = user["updated_at"].toString();
    String isLogged = "true";
    Map<String, dynamic> mappedItems = {
      "user_id": user_id,
      "name": name,
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

  // Method to send OTP for verification
  Future<void> _verifyOTP() async {
    String otp = pinController.text;

    var Urlapi = Points().apiUrl;
    var VerifyOtp = Points().loginOtpVerify;

    final Map<String, dynamic> otpdata = {
      'logged_at': DateTime.now().toIso8601String(),
    };
    String jsonBody = json.encode(otpdata);

    try {
      final http.Response response = await http.post(
        Uri.parse('$Urlapi/$VerifyOtp/${widget.u_phone}/$otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        var obj = jsonDecode(response.body);
          if (obj["status"]) {
            saveData(obj);
            Navigator.pushNamed(
            context, 
            '/homepage', 
            arguments: {'head': obj["header"], 'bod': obj["message"]}
          );
          }else{
            dialogOpen(context,obj["header"],obj["message"]);
            setState(() {
              pinController.setText("");
            });
          }
      } else {
        // Navigator.pushReplacementNamed(context, '/otpscreen');
        dialogOpen(context,"Verifying Error","There was an error verifying, please try again");
        setState(() {
          pinController.setText("");
        });
      }
    } catch (error) {
      dialogOpen(context,"Verifying Error","Error While Verifying User, Please Try again");
      setState(() {
        pinController.setText("");
      });
    }
  }

  // Method to start the countdown timer for OTP resend
  void startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _countdownTimer?.cancel();
        }
      });
    });
  }

  // Cancel the countdown timer when the widget is disposed
  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    // Getting screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Initialize pinController with generatedOTP
    // var pinController = TextEditingController(text: generatedOTP);
    var pinput = Pinput(
      controller: pinController,
      showCursor: true,
      defaultPinTheme: PinTheme(
        width: 63,
        height: 63,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: const Color.fromARGB(255, 35, 60, 135),
            width: 2.0,
          ),
        ),
        textStyle: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(255, 35, 60, 135),
        ),
      ),
      length: 4,
    );
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/loginScreen');
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
          surfaceTintColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'Login',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'OTP Verification',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                  color: const Color.fromARGB(255, 24, 32, 53),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: const Color.fromARGB(255, 96, 98, 104),
                    ),
                    children: [
                      TextSpan(
                        text: 'Enter the code from the sms we sent to ',
                      ),
                      TextSpan(
                        text: '+94 ${phoneController.text}',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 49, 54, 70),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              pinput,
              // Pinput(
              //   showCursor: true,
              //   defaultPinTheme: PinTheme(
              //     width: 63,
              //     height: 63,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(21),
              //       border: Border.all(
              //         color: const Color.fromARGB(255, 35, 60, 135),
              //         width: 2.0,
              //       ),
              //     ),
              //     textStyle: const TextStyle(
              //       fontSize: 26,
              //       fontWeight: FontWeight.w600,
              //       color: Color.fromARGB(255, 35, 60, 135),
              //     ),
              //   ),
              //   length: 4,
              // ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Spacer(),
                  const Text(
                    "I didn’t receive the code,",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 255, 122, 0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_remainingSeconds <= 0) {
                        // Resend OTP logic here
                        var Urlapi = Points().apiUrl;
                        var SendOtp = Points().otpSend;

                          try {
                            final http.Response response = await http.post(
                              Uri.parse('$Urlapi/$SendOtp/${widget.u_phone}'),
                              headers: {
                                'Content-Type': 'application/json',
                              },
                              body: json.encode({
                                'telephone': widget.u_phone,
                              }),
                            );

                            if (response.statusCode != 200) {

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('OTP Service Issue'),
                                    content: Text(
                                      'There Was An Issue Sending OTP, Please Try Again.'),
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

                            }
                          } catch (error) {
                            print('Error: $error');
                          }
                          setState(() {
                            pinController.text = '';
                          });
                        // Reset the countdown timer
                        _remainingSeconds = 60;
                        startCountdown();
                      }
                    },
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _remainingSeconds > 0
                            ? const Color.fromARGB(255, 150, 150, 150)
                            : const Color.fromARGB(255, 35, 60, 135),
                      ),
                    ),
                  ),
                  Text(
                    _remainingSeconds > 0 ? " in $_remainingSeconds sec" : "",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 32, 80, 114),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  _verifyOTP();
                  // Navigator.pushReplacementNamed(context, '/homepage');
                },
                child: CustomButton(
                    text: "CONTINUE",
                    height: 55,
                    width: screenWidth - 60,
                    backgroundColor: AppColors.accentColor),
              ),
              SizedBox(
                height: 95,
              ),
              Image.asset(
                'assets/images/ttcLogoTransparent.png',
                width: 200,
                height: 50,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'By Chakra Suthra',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: const Color.fromARGB(255, 15, 108, 133),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
