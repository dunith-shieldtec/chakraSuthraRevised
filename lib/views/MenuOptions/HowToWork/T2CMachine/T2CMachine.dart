// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Defining a StatefulWidget for the T2CMachine
class T2CMachine extends StatefulWidget {
  const T2CMachine({super.key});

  @override
  State<T2CMachine> createState() => _T2CMachineState();
}

class _T2CMachineState extends State<T2CMachine> {
  Widget build(BuildContext context) {
    // Getting screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                'Step 1'.toUpperCase(),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: const Color.fromARGB(255, 15, 108, 133),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: const Color.fromARGB(255, 15, 108, 133),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Step 2'.toUpperCase(),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: const Color.fromARGB(255, 15, 108, 133),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: const Color.fromARGB(255, 15, 108, 133),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Step 3'.toUpperCase(),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: const Color.fromARGB(255, 15, 108, 133),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: const Color.fromARGB(255, 15, 108, 133),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Step 4'.toUpperCase(),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: const Color.fromARGB(255, 15, 108, 133),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a tincidunt massa. Cras pulvinar porta ligula a hendrerit. Vestibulum sit amet lorem dignissim, dignissim nisi vitae, eleifend augue.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: const Color.fromARGB(255, 15, 108, 133),
                ),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
