import 'dart:convert';
import 'package:application/components/button_components/my_button.dart';
import 'package:application/components/navigation/push_replacement.dart';
import 'package:application/pages/sign_in.dart';
import 'package:intl/intl.dart';
import 'package:application/components/button_components/custom_text_button.dart';
import 'package:application/components/profile_image.dart';
import 'package:application/components/static_components/or_continue_with.dart';
import 'package:application/components/text_components/bold_thin.dart';
import 'package:application/config.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  final String token;
  const MyProfile({required this.token, super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late SharedPreferences prefs;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  late String uId;
  bool isLoading = false;
  late Map<String, dynamic> userData;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    uId = jwtDecodedToken['_id'];
    getUserProfile();
    initSharedPref();
  }

  void logOutUser() {
    prefs.remove('token');
    Navigator.of(context).popUntil((route) => route.isFirst);
    pushReplacement(context, const SignIn());
  }

  void getUserProfile() async {
    setState(() {
      isLoading = true;
    });

    final reqBody = {"_id": uId};

    final response = await http.post(
      Uri.parse(getUserDetails),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    final jsonResponse = jsonDecode(response.body);

    userData = jsonResponse['success'];

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const ProfileImage(
                      type: false,
                      imageUrl: null,
                      radius: 80,
                      // selectedImage: null,
                    ),
                    CustomTextButton(
                        buttonText: 'Add Image',
                        onPressed: () => {},
                        fontSize: 14),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      userData['userName'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const OrContinueWith(msg: 'My info'),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: SizedBox(
                        width: double.infinity,
                        height: 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BoldThin(
                                primaryText: 'Email - ',
                                secondaryText: userData['email']),
                            const BoldThin(
                                primaryText: 'Position - ',
                                secondaryText: 'Manager'),
                            const BoldThin(
                                primaryText: 'No. of Employee - ',
                                secondaryText: '7'),
                            BoldThin(
                              primaryText: "Registerd on - ",
                              secondaryText: DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(userData['createdAt'])
                                      .toLocal()),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    MyButton(
                        buttonText: 'Logout',
                        onPressed: () => {logOutUser()},
                        isLoading: false),
                  ],
                ),
              ),
            ),
    );
  }
}
