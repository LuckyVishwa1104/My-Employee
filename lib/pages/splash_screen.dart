import 'dart:async';
import 'package:application/components/navigation/push_replacement.dart';
import 'package:application/pages/home_page.dart';
import 'package:application/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreen extends StatefulWidget {
  final String? token;

  const SplashScreen({required this.token, super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (widget.token != null && !JwtDecoder.isExpired(widget.token!)) {
      pushReplacement(context, HomePage(token: widget.token!));
    } else {
      pushReplacement(context, const SignIn());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.clamp,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius as needed
                child: Image.asset(
                  'assets/images/appIcon.png',
                  width: 130,
                  height: 130,
                  fit: BoxFit
                      .cover, // Ensure the image fits within the rounded corners
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'MyEmployee',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}