import 'dart:convert';
import 'package:application/components/button_components/custom_button.dart';
import 'package:application/components/navigation/push.dart';
import 'package:application/components/navigation/push_replacement.dart';
import 'package:application/components/profile_image.dart';
import 'package:application/components/square_tile_icon.dart';
import 'package:application/components/static_components/or_continue_with.dart';
import 'package:application/components/text_components/bold_thin.dart';
import 'package:application/pages/home_page.dart';
import 'package:application/pages/update_details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeDetails extends StatefulWidget {
  final String token;
  final String uId;
  const EmployeeDetails({required this.token, required this.uId, super.key});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  late final String _uId = widget.uId;
  late String uId;
  late SharedPreferences prefs;
  late Map<String, dynamic> employeeData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    uId = jwtDecodedToken['_id'];
    employeeDetail();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void employeeDetail() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee/$_uId'));

    final data = jsonDecode(response.body);

    setState(() {
      employeeData = data;
      isLoading = false;
    });
  }

  void deleteEmployee_() async {
    var response = await http.delete(Uri.parse('https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee/$_uId'));

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse);

    if (jsonResponse.isNotEmpty) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      pushReplacement(context, HomePage(token: prefs.getString('token')!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Detail'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black,),
            )
          : Container(
              padding: const EdgeInsets.all(8),
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileImage(
                      type: true,
                      imageUrl: employeeData["avatar"],
                      selectedImage: null,
                      radius: 80,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      employeeData['name'],
                      style: const TextStyle(fontSize: 23),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SquareTileIcon(
                          icon: Icons.call,
                          onPressed: () => {},
                          labelText: 'Meeting',
                          clr: Colors.green,
                          bgColor: Colors.grey.shade300,
                        ),
                        SquareTileIcon(
                          icon: Icons.task,
                          onPressed: () => {},
                          labelText: 'Assign Task',
                          clr: Colors.orange,
                          bgColor: Colors.grey.shade300,
                        ),
                        SquareTileIcon(
                          icon: Icons.pie_chart,
                          onPressed: () => {},
                          labelText: 'Analysis',
                          clr: Colors.red.shade400,
                          bgColor: Colors.grey.shade300,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const OrContinueWith(msg: 'Personal info'),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        // height: 160,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BoldThin(
                                primaryText: 'Emp Id. - ',
                                secondaryText: employeeData["id"]),
                            BoldThin(
                                primaryText: 'Email - ',
                                secondaryText: employeeData["emailId"]),
                            BoldThin(
                                primaryText: 'Contact - ',
                                secondaryText: employeeData["mobile"]),
                            BoldThin(
                              primaryText: 'District - ',
                              secondaryText: employeeData["district"],
                            ),
                            BoldThin(
                              primaryText: 'State - ',
                              secondaryText: employeeData["state"],
                            ),
                            BoldThin(
                              primaryText: 'Country - ',
                              secondaryText: employeeData["country"],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                              buttonText: 'Delete employee',
                              onPressed: () => {
                                    deleteEmployee_(),
                                  },
                              bgColor: Colors.black),
                          CustomButton(
                            buttonText: 'Update details',
                            onPressed: () => {
                              push(context, UpdateDetails(uId: _uId),),
                            },
                            bgColor: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
