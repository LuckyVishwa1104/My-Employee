import 'dart:convert';
import 'package:application/components/button_components/custom_button.dart';
import 'package:application/components/navigation/push_replacement.dart';
import 'package:application/components/profile_image.dart';
import 'package:application/components/square_tile_icon.dart';
import 'package:application/components/static_components/or_continue_with.dart';
import 'package:application/components/text_components/bold_thin.dart';
import 'package:application/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:application/config.dart';
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
    try {
      final reqBody = {"_id": _uId};
      var response = await http.post(
        Uri.parse(singleEmployee),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        setState(() {
          employeeData = jsonResponse['success'];
          isLoading = false;
        });
      } else {
        print("Failed to load employee data");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching employee details: $e");
    }
  }

  void deleteEmployee_(id) async {
    var reqBody = {"_id": id};

    var response = await http.post(Uri.parse(deleteEmployee),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
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
              child: CircularProgressIndicator(),
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
                      imageUrl:
                          employeeData["objectUrl"],
                      selectedImage: null,
                      radius: 80,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      employeeData['employeeName'],
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
                        height: 160,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BoldThin(
                                primaryText: 'Emp Id. - ',
                                secondaryText: employeeData["employeeId"]),
                            BoldThin(
                                primaryText: 'Email - ',
                                secondaryText: employeeData["employeeEmail"]),
                            BoldThin(
                                primaryText: 'Contact - ',
                                secondaryText: employeeData["employeeNumber"]),
                            BoldThin(
                                primaryText: 'Address - ',
                                secondaryText: employeeData["employeeAddress"]),
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
                                    deleteEmployee_(
                                      employeeData["_id"],
                                    ),
                                  },
                              bgColor: Colors.red.shade400),
                          CustomButton(
                            buttonText: 'Update details',
                            onPressed: () => {},
                            bgColor: Colors.green,
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
