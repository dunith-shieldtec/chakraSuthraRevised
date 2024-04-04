import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/widgets/custom_button.dart';

class TimeSlote extends StatefulWidget {
  const TimeSlote({super.key});

  @override
  State<TimeSlote> createState() => _TimeSloteState();
}

class _TimeSloteState extends State<TimeSlote> {
  void _sendSupport() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 200,
              width: 250,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your confirmation should be given to you with next 24 hours'
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: CustomButton(
                      text: "OK",
                      height: 40,
                      width: 80,
                      backgroundColor: AppColors.accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focuseDay) {
    setState(() {
      today = day;
    });
  }

  int selected = 0;

  Widget customRadio(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selected = index;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color.fromARGB(234, 225, 124, 0);
            }
            return Color.fromARGB(0, 150, 85, 85);
          },
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: (selected == index)
              ? const Color.fromARGB(234, 225, 124, 0)
              : Color.fromARGB(95, 1, 5, 4),
        ),
      ),
    );
  }

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
                Navigator.pushReplacementNamed(context, '/pickUp');
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
              'Select your Pick-up Time Slot',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              child: TableCalendar(
                locale: "en_us",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    formatButtonShowsNext: false),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: today,
                onDaySelected: _onDaySelected,
              ),
            ),
            SizedBox(height: 20),
            customRadio("07:30 PM - 09:30 AM", 1),
            SizedBox(
              height: 5,
            ),
            customRadio("09:30 AM - 10:30 AM", 2),
            SizedBox(
              height: 5,
            ),
            customRadio("11:30 AM - 12:30 PM", 3),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () {
                  _sendSupport();
                  // Navigator.pushReplacementNamed(context, '/timeSlote');
                },
                child: CustomButton(
                  text: "DONE",
                  height: 50,
                  width: screenWidth,
                  backgroundColor: AppColors.accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
