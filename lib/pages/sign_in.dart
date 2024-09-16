import 'package:application/components/button_components/custom_text_button.dart';
import 'package:application/components/button_components/my_button.dart';
import 'package:application/components/navigation/push_replacement.dart';
import 'package:application/components/navigation/push_replacement_named.dart';
import 'package:application/components/registration/registration_footer.dart';
import 'package:application/components/registration/secondary_method.dart';
import 'package:application/components/static_components/or_continue_with.dart';
import 'package:application/components/text_components/input_text.dart';
import 'package:application/components/text_components/password_text_field.dart';
import 'package:application/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:application/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isNotValid2 = false;
  bool _isNotValid3 = false;
  bool isLoading = false;
  late SharedPreferences prefs;
  String? myToken;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    setState(() {
      _isNotValid2 = emailController.text.isEmpty;
      _isNotValid3 = passwordController.text.isEmpty;
    });

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        myToken = jsonResponse['token'];
        prefs.setString('token', myToken!);
        pushReplacement(context, HomePage(token: myToken!));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // content of the sign-in page
                // logo/icon
                Image.asset(
                  'assets/images/employeeAvatar.png',
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // greeting text
                Text(
                  'Welcome, hope you are doing well!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // text field for username
                InputTextField(
                  controller: emailController,
                  hintText: 'Username',
                  existance: _isNotValid2,
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // text field for password
                PasswordTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  existance: _isNotValid3,
                ),
                const SizedBox(
                  height: 5.0,
                ),

                // forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomTextButton(
                        buttonText: 'Forgot Password?',
                        onPressed: () => pushReplacementNamed(
                          context,
                          '/forgotPassword',
                        ),
                        fontSize: 15.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // sign-in button
                MyButton(
                  buttonText: 'Sign In',
                  onPressed: loginUser,
                  isLoading: isLoading,
                ),
                const SizedBox(
                  height: 25.0,
                ),

                // or continue with
                const OrContinueWith(
                  msg: 'Or continue with',
                ),

                const SizedBox(
                  height: 25.0,
                ),

                //google/apple login button
                const SecondaryMethod(),
                const SizedBox(
                  height: 20.0,
                ),

                // sign-up page link
                const RegistrationFooter(
                  greetMessage: 'Not a member?',
                  buttonText: 'Registre Now!',
                  pageDesignation: '/signUp',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
