// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Defining a StatefulWidget for the LRedeemables
class LRedeemables extends StatefulWidget {
  const LRedeemables({super.key});

  @override
  State<LRedeemables> createState() => _LRedeemablesState();
}

class _LRedeemablesState extends State<LRedeemables> {
  @override
  Widget build(BuildContext context) {
    // Getting screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth - 80,
      height: 110,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 15,
            child: Container(
              width: 60,
              height: 55,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                border: Border.all(
                  color: Color.fromARGB(255, 255, 255, 255),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Image.asset(
                'assets/images/ElephantH.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 85,
            top: 15,
            child: Text(
              'Elephant House',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color.fromARGB(144, 32, 80, 114),
              ),
            ),
          ),
          Positioned(
            left: 85,
            top: 33,
            child: Text(
              '25% Off',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Color.fromARGB(255, 32, 80, 114),
              ),
            ),
          ),
          Positioned(
            left: 85,
            top: 55,
            child: Text(
              'For 1000+ Bills',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color.fromARGB(255, 32, 80, 114),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 122, 0),
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                side: BorderSide(
                  color: const Color.fromARGB(255, 255, 122, 0),
                  width: 1.5,
                ),
              ),
              child: Text(
                'REDEEM',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 122, 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
