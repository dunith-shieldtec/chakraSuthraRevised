import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/widgets/custom_button.dart';

class Papers extends StatefulWidget {
  const Papers({super.key});

  @override
  State<Papers> createState() => _PapersState();
}

class _PapersState extends State<Papers> {
  double _weightLoad = 0.0; // State variable to hold slider value
  RangeValues values = RangeValues(10, 70);
  RangeValues valuesBottom = RangeValues(0, 2);
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
                Navigator.pushReplacementNamed(context, '/bookClothes');
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
                      height: 80,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Column(
                            children: [
                              Image.asset('assets/images/papers.png'),
                              // Text(
                              //   'Papers',
                              //   style: GoogleFonts.montserrat(
                              //     fontWeight: FontWeight.w400,
                              //     fontSize: 14,
                              //     color: AppColors.textColor,
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(
                              width:
                                  50), // Adds spacing between icon and text field
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
                      height: 70,
                    ),
                    Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.textColor,
                            inactiveTrackColor:
                                const Color.fromARGB(92, 41, 87, 120),
                            thumbColor: AppColors.textColor,
                            overlayColor: const Color.fromARGB(92, 41, 87, 120)
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
                    SizedBox(
                      height: 90,
                    ),
                    // buildSliderTopLable(),

                    GestureDetector(
                      onTap: () {
                        // _sendSupport();
                        Navigator.pushReplacementNamed(context, '/pickUp');
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
