// Importing necessary packages and files
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/endpoints/points.dart';
import 'package:trashtocash/widgets/custom_button.dart';
import 'package:trashtocash/controllers/LoginController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

// Defining a StatefulWidget for the OTPScreen
class OTPScreen extends StatefulWidget {
  final String u_name;
  final String u_email;
  final String u_phone;
  final XFile? u_img_link;
  const OTPScreen({required this.u_name, required this.u_email, required this.u_phone, required this.u_img_link});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // Initializing controllers
  final TextEditingController pinController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  
  final codeController = Get.put(LoginController());
  int _remainingSeconds =
      60; // Variable to store remaining seconds for OTP resend
  Timer? _countdownTimer; // Timer for countdown
  String? generatedOTP; // Variable to store generated OTP

  @override
  void initState() {
    super.initState();
    startCountdown();
    setState(() {
      phoneController.text = widget.u_phone.substring(2, 4) + " " + widget.u_phone.substring(4, 7) + " " + widget.u_phone.substring(7);;
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

  // Starting the countdown timer
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

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<http.Response> _uploadImage(XFile? _imageFile) async {
    String ImageUrlPhp = Points().phpImageUrl;
    String upldImage = Points().imageUpload;

    var uri = Uri.parse('$ImageUrlPhp/$upldImage');
    var request = http.MultipartRequest('POST', uri);

    if (_imageFile != null) {
      var imageFile = File(_imageFile.path);
      request.files.add(http.MultipartFile(
        'file',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split('/').last,
      ));
    } else {
      // Add a placeholder or handle the case of no file being uploaded
      // For example, you could add a default image path to the request
      request.fields['defaultImage'] = 'true';
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    return http.Response(responseData, response.statusCode);
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

  // Method to verify the entered OTP
  Future<void> _verifyOTP() async {
    
    String otp = pinController.text;

    var Urlapi = Points().apiUrl;
    var VerifyOtp = Points().signupOtpVerify;

    try {
      var response = await _uploadImage(widget.u_img_link);
      var respObj = jsonDecode(response.body);
      if(respObj['status']==true){

        final Map<String, dynamic> otpdata = {
          'name': widget.u_name,
          'email': widget.u_email,
          'mobile': widget.u_phone,
          'pfp_link': respObj["fileLocation"],
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
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
                  arguments: {'head': obj["header"], 'bod': obj["message"]});
              }else{
                dialogOpen(context,obj["header"],obj["message"]);
                setState(() {
                  pinController.setText("");
                });
              }
          } else {
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
      }else{
        dialogOpen(context, "Error", "Image Error Occured, Please Change Image and Try Again");
        Navigator.pushReplacementNamed(context, '/signup');
      }
    } catch (e) {
      print('Error uploading image: $e');
      dialogOpen(context, "Error", "Image Error Occured, Please Change Image and Try Again");
      Navigator.pushReplacementNamed(context, '/signup');
    }
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
                  Navigator.pushReplacementNamed(context, '/signup');
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
                'Sign Up',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              //testing the parsed name val
              Text(widget.u_name),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
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
                        text: 'We have sent you an ',
                      ),
                      TextSpan(
                        text: 'One Time Password(OTP)',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 49, 54, 70),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' to this mobile number.',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 41,
                child: Row(
                  children: [
                    Expanded(
                      child: GetBuilder<LoginController>(
                        builder: (controller) {
                          return TextField(
                            readOnly: true,
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
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     if (phoneController.text == '') {
                    //       showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) {
                    //           return AlertDialog(
                    //             title: Text('WARNING !'),
                    //             content: Text(
                    //                 'The phone number field cannot be empty.'),
                    //             actions: <Widget>[
                    //               GestureDetector(
                    //                 onTap: () {
                    //                   // Close the dialog
                    //                   Navigator.of(context).pop();
                    //                 },
                    //                 child: Text('OK'),
                    //               ),
                    //             ],
                    //           );
                    //         },
                    //       );
                    //     } else {
                    //       _checkNumber();
                    //       // startCountdown();
                    //     }
                    //   },
                    //   child: Text("Verify".toUpperCase()),
                    // ),
                  ],
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 20),
              //   height: 41,
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: GetBuilder<LoginController>(
              //           builder: (controller) {
              //             return TextField(
              //               controller: phoneController,
              //               keyboardType: TextInputType.number,
              //               decoration: InputDecoration(
              //                 border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(9.0),
              //                 ),
              //                 enabledBorder: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(9.0),
              //                   borderSide: const BorderSide(
              //                     color: Color.fromARGB(255, 15, 108, 133),
              //                     width: 0.5,
              //                   ),
              //                 ),
              //                 prefixIcon: Container(
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: 8.0, vertical: 5.0),
              //                   margin: const EdgeInsets.symmetric(
              //                       horizontal: 8.0, vertical: 5),
              //                   decoration: const BoxDecoration(
              //                     color: Colors.transparent,
              //                     borderRadius: BorderRadius.all(
              //                       Radius.circular(5.0),
              //                     ),
              //                   ),
              //                   child: Text(
              //                     '+94',
              //                     style: const TextStyle(
              //                       fontWeight: FontWeight.w600,
              //                       color: Color.fromARGB(255, 0, 0, 0),
              //                     ),
              //                   ),
              //                 ),
              //                 suffixIcon: phoneController.text.length == 9
              //                     ? SizedBox(
              //                         width: 50,
              //                         child: Image.asset(
              //                           'assets/images/ph.png',
              //                           scale: 1.0,
              //                         ),
              //                       )
              //                     : SizedBox(),
              //                 labelText: "Phone Number",
              //                 labelStyle: GoogleFonts.montserrat(
              //                   fontSize: 10,
              //                   fontWeight: FontWeight.w500,
              //                   color: const Color.fromARGB(255, 159, 159, 159),
              //                 ),
              //                 contentPadding: const EdgeInsets.symmetric(
              //                     vertical: 5, horizontal: 10),
              //               ),
              //             );
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 60,
              ),

              // Pinput widget for OTP input
              pinput,
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
                  if (pinController.text.trim().length!=4) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('WARNING !'),
                          content: Text('Invalid OTP !'),
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
                  } else {
                    _verifyOTP(); // Verify OTP
                  }
                },
                child: CustomButton(
                    text: "CONTINUE",
                    height: 55,
                    width: screenWidth - 60,
                    backgroundColor: AppColors.accentColor),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 70,
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
