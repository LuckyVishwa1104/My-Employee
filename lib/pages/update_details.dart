import 'dart:convert';
import 'package:application/components/button_components/my_button.dart';
import 'package:application/components/navigation/push.dart';
import 'package:application/pages/employee_details.dart';
import 'package:http/http.dart' as http;
import 'package:application/components/text_components/input_text.dart';
import 'package:application/components/text_components/numeric_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateDetails extends StatefulWidget {
  final String uId;
  const UpdateDetails({super.key, required this.uId});

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController employeeEmailController = TextEditingController();
  TextEditingController employeeNumberController = TextEditingController();
  TextEditingController employeeAddressController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  bool isLoading = false;
  late Map<String, dynamic> employeeData;
  late final String _uId = widget.uId;
  late SharedPreferences prefs;
  bool isLoading_ = false;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
    employeeDetail();
  }

  void employeeDetail() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee/$_uId'),
    );

    final data = jsonDecode(response.body);

    setState(() {
      employeeData = data;
      isLoading = false;
    });
  }

  void updateEmployee() async {
    setState(() {
      isLoading_ = true;
    });

    // Create an empty request body
    var reqBody = {};

    // Check if each field is not empty, and only add it to the request body if it has been updated.
    if (employeeNameController.text.isNotEmpty) {
      reqBody['name'] = employeeNameController.text;
    }
    if (employeeEmailController.text.isNotEmpty) {
      reqBody['emailId'] = employeeEmailController.text;
    }
    if (employeeNumberController.text.isNotEmpty) {
      reqBody['mobile'] = employeeNumberController.text;
    }
    if (employeeAddressController.text.isNotEmpty) {
      reqBody['country'] = employeeAddressController.text;
    }
    if (employeeIdController.text.isNotEmpty) {
      reqBody['state'] = employeeIdController.text;
    }
    if (districtController.text.isNotEmpty) {
      reqBody['district'] = districtController.text;
    }

    // Make sure the request body is not empty
    if (reqBody.isEmpty) {
      setState(() {
        isLoading_ = false;
      });
      // You can show a message to the user indicating that no changes were made
      return;
    }

    // Send the PUT request with the updated fields
    final response = await http.put(
      Uri.parse(
          'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee/$_uId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    final data = jsonDecode(response.body);

    if (data.isNotEmpty) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      push(context,
          EmployeeDetails(token: prefs.getString('token')!, uId: _uId));
    }

    setState(() {
      isLoading_ = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Employee'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        InputTextField(
                          hintText: employeeData['name'],
                          existance: false,
                          controller: employeeNameController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          hintText: employeeData['emailId'],
                          existance: false,
                          controller: employeeEmailController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        NumericText(
                          hintText: employeeData['mobile'],
                          existance: false,
                          controller: employeeNumberController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          hintText: employeeData['country'],
                          existance: false,
                          controller: employeeAddressController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          hintText: employeeData['state'],
                          existance: false,
                          controller: employeeIdController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          hintText: employeeData['district'],
                          existance: false,
                          controller: districtController,
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        MyButton(
                          buttonText: 'Update details',
                          onPressed: updateEmployee,
                          isLoading: isLoading_,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
