// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trashtocash/constants/Colors.dart';

// Defining a StatefulWidget for the Location
class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late GoogleMapController mapController; // Controller for Google Map
  static const LatLng _center = LatLng(7.0, 80.0); // Initial center coordinate
  Map<String, Marker> _markers = {}; // Map to store markers

  // Function called when map is created
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    addMarker("test", _center); 
    addMarker("test2", const LatLng(7.123, 80.123));
    addMarker("test3", const LatLng(7.325, 80.0));
    addMarker("test4", const LatLng(7.425, 80.110));
  }

  // Function to add marker to the map
  addMarker(String id, LatLng location) async {
    // Load marker icon from assets

    // var markerIcon = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(), 'assets/images/ElephantH.png');

    // Create marker object
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(
        title: "Title of place",
        snippet: "Hiiiiiiiiiiiiii",
      ),
      // icon: markerIcon, 
    );
    _markers[id] = marker; // Add marker to the map
    setState(() {}); // Update UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                //Navigate back to homepage
                Navigator.pushReplacementNamed(context, '/homepage'); 
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.iconColor, 
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center, 
          zoom: 10.0, 
        ),
        markers: _markers.values.toSet(), 
      ),
    );
  }
}
