import 'dart:convert';

import 'package:application/components/button_components/my_button.dart';
import 'package:application/components/text_components/drawer_text.dart';
import 'package:application/components/text_components/input_text.dart';
import 'package:application/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/navigation/push.dart';
import 'employee_details.dart';

class UpdateDetails extends StatefulWidget {
  final String uId;
  const UpdateDetails({super.key, required this.uId});

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController employeePositionController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController employeeEmailController = TextEditingController();
  TextEditingController employeeNumberController = TextEditingController();
  TextEditingController employeeAddressController = TextEditingController();

  bool isLoading = false;
  late Map<String, dynamic> employeeData;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmployeeDetails();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void getEmployeeDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      final reqBody = {"_id": widget.uId};
      final response = await http.post(
        Uri.parse(singleEmployee),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        setState(() {
          employeeData = jsonResponse['success'];

          // Prefill controllers
          employeeIdController.text = employeeData['employeeId'] ?? "";
          employeePositionController.text = employeeData['position'] ?? "";
          employeeNameController.text = employeeData['employeeName'] ?? "";
          employeeEmailController.text = employeeData['employeeEmail'] ?? "";
          employeeNumberController.text = employeeData['employeeNumber'] ?? "";
          employeeAddressController.text =
              employeeData['employeeAddress'] ?? "";
        });
      } else {
        debugPrint("Failed to load employee details");
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error while geting current employee deatils: $e");
    }
  }

  // update method for employee detaisl
  void updateEmployeeDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      var reqBody = {
        'employeeId': employeeIdController.text,
        'position': employeePositionController.text,
        'employeeName': employeeNameController.text,
        'employeeEmail': employeeEmailController.text,
        'employeeNumber': employeeNumberController.text,
        'employeeAddress': employeeAddressController.text,
      };

      final String apiUrl = '${updateEmployee}?id=${widget.uId}';

      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        push(context,
            EmployeeDetails(token: prefs.getString('token')!, uId: widget.uId));
      } else {
        debugPrint(
            "Failed to update Emplyee details - status code ${jsonResponse['statusCode']}");
      }
    } catch (e) {
      debugPrint("Error while updating employee deatils: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Details"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        InputTextField(
                          hintText: '',
                          existance: false,
                          controller: employeeIdController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DrawerText(
                          hintText: '',
                          options: const [
                            'Intern',
                            'Junior Developer',
                            'Senior Developer',
                          ],
                          controller: employeePositionController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          hintText: '',
                          existance: false,
                          controller: employeeNameController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          hintText: '',
                          existance: false,
                          controller: employeeEmailController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                            hintText: '',
                            existance: false,
                            controller: employeeNumberController),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          hintText: '',
                          existance: false,
                          controller: employeeAddressController,
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    left: 0,
                    child: MyButton(
                      buttonText: 'Update',
                      onPressed: updateEmployeeDetails,
                      isLoading: isLoading,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
