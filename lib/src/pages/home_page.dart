import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:location_tracker/src/helpers/klog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCurrentLocation() async {
    currentPosition = await Geolocator.getCurrentPosition(
      // desiredAccuracy: LocationAccuracy.high,
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    );
    klog('Current Position: $currentPosition');
  }

  void getLastKnownPosition() async {
    final position = await Geolocator.getLastKnownPosition();
    if (position != null) {
      klog(position);
    } else {
      klog(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {},
            child: Text('Scan QR'),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text('Scanned QR: '),
                ElevatedButton(
                  onPressed: () async {
                    await getCurrentLocation();
                  },
                  child: Text('Get Location'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LocationServiceDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(20),
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 60), // Space for the floating icon
              // Title
              const Text(
                "Turn on Location Service",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Content text
              const Text(
                "Explore the world without getting lost and keep track of your location.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Buttons
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Enable Location",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Later",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: -70, // Position the icon above the dialog
            left: 0,
            right: 0,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple[100],
              // child: Icon(
              //   Icons.location_on_rounded,
              //   size: 40,
              //   color: Colors.purple,
              // ),
              child: Lottie.asset(
                'assets/location.json',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
