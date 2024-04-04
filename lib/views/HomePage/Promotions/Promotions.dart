// Importing necessary packages and files
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trashtocash/constants/Colors.dart';
import 'package:trashtocash/views/HomePage/Promotions/ARedeemables/Aredeemables.dart';

// Defining a StatefulWidget for the Promotions
class Promotions extends StatefulWidget {
  const Promotions({super.key});

  @override
  State<Promotions> createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  final myitems = [
    Image.asset('assets/images/promo.png'), // Sample promo image
    Image.asset('assets/images/promo.png'), // Sample promo image
    Image.asset('assets/images/promo.png'), // Sample promo image
    Image.asset('assets/images/promo.png'), // Sample promo image
  ];

  int myCurrentIndex = 0; // Index for tracking current carousel item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Navigate back to homepage
                Navigator.pushReplacementNamed(context, '/homepage'); 
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
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                // Navigate to notifications
                Navigator.pushReplacementNamed(context, '/notifications'); 
              },
              child: Icon(
                Icons.notifications_none,
                color: AppColors.iconColor, 
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title for latest offers section
              Text(
                'Latest offers',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: AppColors.textColor,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Carousel slider for displaying promo images
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        height: 200,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayInterval: const Duration(seconds: 2),
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            myCurrentIndex = index; // Update current index on page change
                          });
                        },
                      ),
                      items: myitems,
                    ),
                    // Smooth page indicator for carousel
                    AnimatedSmoothIndicator(
                      activeIndex: myCurrentIndex,
                      count: myitems.length,
                      effect: WormEffect(
                        dotHeight: 9,
                        dotWidth: 9,
                        spacing: 9,
                        dotColor: Color.fromARGB(61, 32, 80, 114),
                        activeDotColor: Color.fromARGB(255, 32, 80, 114),
                        paintStyle: PaintingStyle.fill,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),

              // Section title for all offers
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'All Offers',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  // Search button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.iconColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () {
                     
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              // Placeholder for redeemable offers
              const ARedeemables(),
              const ARedeemables(),
              const ARedeemables(),
              const ARedeemables(),
              const ARedeemables(),
              const ARedeemables(),

            
            ],
          ),
        ),
      ),
    );
  }
}
