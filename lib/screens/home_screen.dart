import 'dart:async';

import 'package:app1/services/add_report.dart';
import 'package:app1/utlis/colors.dart';
import 'package:app1/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';
import 'package:torch_light/torch_light.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinePosition();

    setState(() {});
    Timer.periodic(const Duration(seconds: 10), (timer) {
      Geolocator.getCurrentPosition().then((position) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'lat': position.latitude,
          'lng': position.longitude,
        });
      }).catchError((error) {
        print('Error getting location: $error');
      });
    });

    ShakeDetector.autoStart(onPhoneShake: () async {
      final Iterable<Duration> pauses = [
        for (int i = 0; i < 50; i++) const Duration(milliseconds: 500),
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 500),
      ];
// vibrate - sleep 0.5s - vibrate - sleep 1s - vibrate - sleep 0.5s - vibrate
      Vibrate.vibrateWithPauses(pauses);

      await TorchLight.enableTorch();
      // Do stuff on phone shake
    });

    addReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: TextWidget(
          text: 'HOME',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Icon(
          Icons.home,
          size: 75,
        ),
      ),
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
