import 'package:application/components/button_components/custom_text_button.dart';
import 'package:application/components/button_components/my_button.dart';
import 'package:application/components/navigation/push_replacement_named.dart';
import 'package:application/components/text_components/input_text.dart';
import 'package:application/components/text_components/otp_text_field.dart';
import 'package:application/components/text_components/password_text_field.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final bool _isNotValid2 = false;
  final bool _isNotValid3 = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void generateOTP() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // icon for simplicity
              const Icon(
                Icons.lock,
                size: 90,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Reset your Password to continue.",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // input field for email address
              InputTextField(
                controller: emailController,
                hintText: 'Email address',
                existance: _isNotValid2,
              ),
              const SizedBox(
                height: 20.0,
              ),

              // text field for new password
              PasswordTextField(
                controller: passwordController,
                hintText: 'New password',
                existance: _isNotValid3,
              ),
              const SizedBox(
                height: 20.0,
              ),

              // text field for confirming new password
              PasswordTextField(
                controller: passwordController,
                hintText: 'Confirm password',
                existance: _isNotValid3,
              ),
              const SizedBox(
                height: 25.0,
              ),

              // text to get OTP
              CustomTextButton(
                buttonText: 'Get OTP!',
                onPressed: () => generateOTP(),
                fontSize: 16.0,
              ),
              const SizedBox(
                height: 2.0,
              ),

              // input field for OTP
              OtpTextField(
                onCompleted: (otp) {
                },
              ),
              const SizedBox(
                height: 28.0,
              ),

              // button for restting the password
              MyButton(
                buttonText: 'Reset Password',
                onPressed: () => pushReplacementNamed(
                  context,
                  '/signIn',
                ),
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
