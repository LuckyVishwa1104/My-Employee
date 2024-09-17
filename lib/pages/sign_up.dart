import 'package:application/components/button_components/my_button.dart';
import 'package:application/components/navigation/push_replacement.dart';
import 'package:application/components/registration/registration_footer.dart';
import 'package:application/components/registration/secondary_method.dart';
import 'package:application/components/static_components/or_continue_with.dart';
import 'package:application/components/text_components/input_text.dart';
import 'package:application/components/text_components/password_text_field.dart';
import 'package:application/config.dart';
import 'package:application/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isNotValid1 = false; // for user name
  bool _isNotValid2 = false; // for email
  bool _isNotValid3 = false; // for password
  bool isLoading = false;

  void userRegistration() async {
    setState(() {
      _isNotValid1 = userNameController.text.isEmpty;
      _isNotValid2 = emailController.text.isEmpty;
      _isNotValid3 = passwordController.text.isEmpty;
    });

    if (userNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var regBody = {
        "userName": userNameController.text,
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        pushReplacement(context, const SignIn());
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
        decoration: BoxDecoration(color: Colors.grey.shade100),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/employeeAvatar.png',
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // Welcome message
                Text(
                  "Welcome, let's get started!",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // Text field for first/last name
                InputTextField(
                  controller: userNameController,
                  hintText: 'Your name',
                  existance: _isNotValid1,
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // Text field for email
                InputTextField(
                  controller: emailController,
                  hintText: 'Email',
                  existance: _isNotValid2,
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // Text field for password
                PasswordTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  existance: _isNotValid3,
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // Sign up button
                MyButton(
                  buttonText: 'Sign Up',
                  onPressed: userRegistration,
                  isLoading: isLoading,
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // --- or ---
                const OrContinueWith(
                  msg: 'Or continue with',
                ),
                const SizedBox(
                  height: 20.0,
                ),

                // Sign up using google/apple
                const SecondaryMethod(),
                const SizedBox(
                  height: 20.0,
                ),

                // Already have an account - sign In
                const RegistrationFooter(
                  greetMessage: 'Already have account?',
                  buttonText: 'Sign In!',
                  pageDesignation: '/signIn',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
