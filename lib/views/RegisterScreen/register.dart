// Importing necessary packages and files
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/controllers/SignUpController.dart';
import 'package:trashtocash/endpoints/points.dart';
import 'package:trashtocash/widgets/custom_button.dart';
import 'package:trashtocash/widgets/custom_button2.dart';
import 'package:trashtocash/widgets/custom_textFiled.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:trashtocash/widgets/custom_textFiled3.dart';
import 'package:mobx/mobx.dart';
import 'package:trashtocash/views/OTPScreen/OTPScreen.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:email_validator/email_validator.dart';

// Defining a StatefulWidget for the RegisterPage
class R extends StatefulWidget {
  const R({super.key});

  @override
  State<R> createState() => _RState();
}


class _RState extends State<R> {
  // Initializing controllers and variables
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final signUpController = Get.put(SignUpController());
  bool isChecked = false;
  late ImagePicker _imagePicker;
  XFile? _image;
  // ignore: unused_field
  late String _imageUrl;
  

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageValid = await validateImageFile(pickedFile);
      if(imageValid==true){
        setState((){
          _image = pickedFile;
        });
      }else{
        dialogOpen(context, "Image Error", imageValid);
      }
    }else{
      setState((){
        _image = pickedFile;
      });
    }
  }

  Future validateImageFile(XFile imageFile) async {
    // Check file size
    final fileSize = await imageFile.length();
    if (fileSize > 5000000) { //5MB
      return ("File is too large.");
    }

    // Check file format using MIME type
    final mimeType = lookupMimeType(imageFile.path);
    final allowedFormats = ["image/jpg", "image/jpeg", "image/png"];
    if (mimeType == null || !allowedFormats.contains(mimeType)) {
      return ("File format not allowed.");
    }

    // Check if it's an actual image (decode)
    try {
      final file = File(imageFile.path);
      final image = await decodeImageFromList(file.readAsBytesSync());
      if (image == null) {
        return ("File is not an image.");
      }
    } catch (e) {
      print("Error decoding image: $e");
      return ("Error Uploading Image, Try A Different Image");
    }

    // If all checks passed
    return true;
  }

  Future<XFile?> renameImageFile(XFile? originalImageFile, String newFileName) async {
    if (originalImageFile == null) {
      print("No image to rename.");
      return null;
    }

    // Get the directory of the original file
    String dir = path.dirname(originalImageFile.path);

    // Build the new file path with the new name but keep the original extension
    String newPath = path.join(dir, "$newFileName${path.extension(originalImageFile.path)}");

    // Create a copy of the file with the new name
    File newFile = await File(originalImageFile.path).copy(newPath);

    // Optionally, delete the original file if you don't need it anymore
    await File(originalImageFile.path).delete();

    // Create a new XFile from the new file path
    XFile newImageFile = XFile(newFile.path);
    return newImageFile;
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

  //method to format the mobile number
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

  bool isValidEmail(String email) {
    if (!EmailValidator.validate(email)) {
      return false;
    }
    final disposableEmailRegex = RegExp(
        r'^(?:\.|^)(temp|yop|trash|guerrilla|10minute|jetable|throwawy|spam4me|trashmail)(?:\.)*@',
        caseSensitive: false);
    // final disposableTlds = ['.xyz', '.gq', '.ml', '.tk'];
    // final domainParts = email.split('@');
    if (disposableEmailRegex.hasMatch(email)) {  //|| disposableTlds.contains(domainParts.last)
      return false;
    }
    return true;
  }

  // Method to submit form data
  _submitForm(f,l, e, t, c) async {
    String fname = f;
    String lname = l;
    String email = e;
    String telephone = t;
    if(fname.length<3){
      dialogOpen(context, "Invalid Name", "First Name Is Too Short");
    }else if(lname.length<3){
      dialogOpen(context, "Invalid Name", "Last Name Is Too Short");
    }else if(!isValidMobileNumber(telephone)){
      dialogOpen(context,"Invalid Number","The Mobile Number You Entered Was Invalid");
    }else if(!isValidEmail(email)){
      dialogOpen(context,"Invalid Email","The Email Address You Entered Was Invalid");
    }else{
      telephone = formatMobileNumber(t);

      var Urlapi = Points().apiUrl;
      var SendOtp = Points().otpSend;
      var CheckUser = Points().userCheck;

      if(isChecked){
        try {
          final response = await http.get(Uri.parse('$Urlapi/$CheckUser/$email/$telephone'));
          if (response.statusCode == 200) {
            // If the response body is 'true', it means the user exists
            final XFile? formattedpickedFile = await renameImageFile(_image,otpController.text);
            if(response.body.toLowerCase() == 'false'){
              final Map<String, dynamic> data = {
                'telephone': telephone,
              };
              String jsonBody = json.encode(data);
              setState(() {
                _image = formattedpickedFile;
              });
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
                      builder: (_) => OTPScreen(
                        u_name:"$fname $lname",
                        u_email:email,
                        u_phone:telephone,
                        u_img_link:_image,
                      ),
                    ),
                  );
                  // Navigator.pushNamed(
                  //   context, 
                  //   '/homepage', 
                  //   arguments: {
                  //     'u_name':name,
                  //     'u_email':email,
                  //     'u_phone':telephone,
                  //     'u_img_link':_image,
                  // });
                } else {
                  print('Error during API request. Status code: ${response.statusCode}');
                  dialogOpen(context, "Error", "Error Sending OTP, Please Try Again");
                }
              } catch (error) {
                dialogOpen(context, "Error", "Error Sending OTP, Please Try Again");
                print('Error: $error');
              }
            }else{
              dialogOpen(context, "User Exists", "A User With The Same Email Or Mobile Already Exists");
            }
          } else {
            // Handle other status codes if needed
            print('Failed to load user data, status code: ${response.body}');
            dialogOpen(context, "Registering Error", "An Error Occured, Please try Again");
          }
        } catch (e) {
          // Handle network errors
          print('Error: $e');
          dialogOpen(context, "Registering Error", "An Network Error Occured, Please try Again");
        }
      }else{
        dialogOpen(context, 'Agree To Terms & Conditions', 'Please Check The Box If You Agree To Our Terms And Conditions, Only Then Will You Be Able To Proceed.');
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
          ],
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<SignUpController>(builder: (controller) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 35),
            width: screenWidth,
            height: screenHeight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - AppBar().preferredSize.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color.fromARGB(255, 205, 203, 203),
                        ),
                        child: Center(
                          child: _image == null
                              ? Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    File(_image!.path),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          color: AppColors.iconColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Upload your photo',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: AppColors.textGaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Please enter your credentials to proceed',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: AppColors.textGaryColor,
                      ),
                    ),
                    SizedBox(height: 15),
                    // Text Fields for Name, Email, and OTP
                    CustomTextField(
                      controller: fnameController,
                      labelText: "ENTER FIRST NAME *",
                    ),
                    CustomTextField(
                      controller: lnameController,
                      labelText: "ENTER LAST NAME *",
                    ),
                    CustomTextField(
                      controller: emailController,
                      labelText: "ENTER EMAIL *",
                    ),
                    TextField(
                            controller: otpController,
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
                              suffixIcon: otpController.text.length == 9
                                  ? SizedBox(
                                      width: 50,
                                      child: Image.asset(
                                        'assets/images/ph.png',
                                        scale: 1.0,
                                      ),
                                    )
                                  : SizedBox(),
                              labelText: "ENTER YOUR MOBILE NUMBER TO RECEIVE AN OTP",
                              labelStyle: GoogleFonts.montserrat(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 159, 159, 159),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                            ),
                          ),
                    // Checkbox for Terms and Conditions
                    CheckboxListTile(
                      title: RichText(
                        text: TextSpan(
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: AppColors.textColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'I accept ',
                            ),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // showTC(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Terms & Conditions'),
                                        content: SingleChildScrollView(
                                          child: Text(
                                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt.'
                                            )
                                          ),
                                        actions: <Widget>[
                                            Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isChecked = true;
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: CustomButton(
                                                      text: "AGREE", 
                                                      height: 55,
                                                      width: (screenWidth / 3) - 20,
                                                      backgroundColor: AppColors.accentColor, 
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isChecked = false;
                                                        Navigator.pop(context);
                                                      });

                                                    },
                                                    child: CustomButton2(
                                                      text: "DISAGREE", 
                                                      height: 55,
                                                      width: (screenWidth / 3) - 20,
                                                      backgroundColor: const Color.fromARGB(255, 229, 248, 255), 
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        ],
                                      );
                                    },
                                  );
                                },
                            ),
                            TextSpan(
                              text: ' of use',
                            ),
                          ],
                        ),
                      ),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                      activeColor: AppColors.accentColor,
                      checkColor: Colors.white,
                      tileColor: Colors.transparent,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    // Sign Up Button
                    GestureDetector(
                      onTap: () {
                        // if (nameController.text == '' ||
                        //     emailController.text == '' ||
                        //     otpController.text == '') {
                        //   // Show warning dialog if fields are empty
                        //   showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         title: Text('WARNING !'),
                        //         content: Text('Fields cannot be empty.'),
                        //         actions: <Widget>[
                        //           TextButton(
                        //             onPressed: () {
                        //               // Close the dialog
                        //               Navigator.of(context).pop();
                        //             },
                        //             child: Text('OK'),
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   );
                        // } else {
                        //   // Submit form data
                          _submitForm(fnameController.text.trim(),lnameController.text.trim(), emailController.text.trim(),
                              otpController.text.trim(),isChecked);

                          // Show success dialog
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //       title: Text('USER SAVED'),
                          //       content: Text(
                          //           'Your details have been saved successfully.'),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           onPressed: () {
                          //             // Close the dialog
                          //             Navigator.of(context).pop();
                          //           },
                          //           child: Text('OK'),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );

                          // Navigate to OTP Screen
                        // }
                      },
                      child: CustomButton(
                        text: "SIGN UP",
                        height: 41,
                        width: screenWidth,
                        backgroundColor: AppColors.accentColor,
                      ),
                    ),
                    SizedBox(height: 40),
                    // Log In Text and Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: AppColors.textGaryColor,
                          ),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/loginScreen');
                          },
                          child: Text(
                            'Log in',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 100),
                    Image.asset(
                      'assets/images/ttcLogoTransparent.png',
                      width: 200,
                      height: 50,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'By Chakra Suthra',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: const Color.fromARGB(255, 15, 108, 133),
                      ),
                    ),
                    Platform.isIOS ? SizedBox(height: 30) : SizedBox(height: 0),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
