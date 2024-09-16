import 'package:application/pages/forgot_password.dart';
import 'package:application/pages/home_page.dart';
import 'package:application/pages/sign_in.dart';
import 'package:application/pages/sign_up.dart';
import 'package:application/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs;
  String? token;

  try {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  } catch (e) {
    print('Error retrieving token: $e');
  }

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({
    required this.token,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(token: token),
      routes: {
        '/signUp' : (context) => const SignUp(),
        '/signIn' : (context) => const SignIn(),
        '/forgotPassword' : (context) => const ForgotPassword(),
        '/homePage' : (context) => HomePage(token: token!,),
      },
    );
  }
}

