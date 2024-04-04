import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/widgets/custom_button.dart';

class BookClothes extends StatefulWidget {
  const BookClothes({super.key});

  @override
  State<BookClothes> createState() => _BookClothesState();
}

class _BookClothesState extends State<BookClothes> {
  double _weightLoad = 0.0; // State variable to hold slider value
  RangeValues values = RangeValues(10, 70);
  RangeValues valuesBottom = RangeValues(0, 2);
  bool _isTextFieldFocused = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/homepage');
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.iconColor,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Choose your load size',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: AppColors.textColor,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Text(
                      'Input your weight load',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      'Please input approximate count',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Column(
                            children: [
                              Image.asset('assets/images/books.png'),
                              // Text(
                              //   'Reusable Books',
                              //   style: GoogleFonts.montserrat(
                              //     fontWeight: FontWeight.w400,
                              //     fontSize: 14,
                              //     color: AppColors.textColor,
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(width: 50),
                          Expanded(
                            child: Container(
                              width: 5,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textColor,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 14, 133, 60),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 255, 122, 0),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isTextFieldFocused = true;
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                    _isTextFieldFocused = false;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Column(
                            children: [
                              Image.asset('assets/images/clothes.png'),
                              // Text(
                              //   'Reusable Clothes',
                              //   style: GoogleFonts.montserrat(
                              //     fontWeight: FontWeight.w400,
                              //     fontSize: 14,
                              //     color: AppColors.textColor,
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(width: 50),
                          Expanded(
                            child: Container(
                              width: 5,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textColor,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 14, 133, 60),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 255, 122, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Visibility(
                      visible: _isTextFieldFocused,
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.textColor,
                              inactiveTrackColor:
                                  const Color.fromARGB(92, 41, 87, 120),
                              thumbColor: AppColors.textColor,
                              overlayColor:
                                  const Color.fromARGB(92, 41, 87, 120)
                                      .withAlpha(32),
                            ),
                            child: Slider(
                              value: _weightLoad,
                              min: 0,
                              max: 10,
                              divisions: 10,
                              label: '$_weightLoad',
                              onChanged: (newValue) {
                                setState(() {
                                  _weightLoad = newValue;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              children: [
                                Text(
                                  '|',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '|',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '|',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '0 -5',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                '5 - 10',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '10 - above',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 90,
                    ),
                    // buildSliderTopLable(),
                    GestureDetector(
                      onTap: () {
                        // _sendSupport();
                        Navigator.pushReplacementNamed(context, '/papers');
                      },
                      child: CustomButton(
                        text: "Next",
                        height: 50,
                        width: screenWidth,
                        backgroundColor: AppColors.accentColor,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                      width: screenWidth * 0.5,
                      child:
                          Image.asset('assets/images/ttcLogoTransparent.png'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
