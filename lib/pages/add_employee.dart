import 'dart:convert';
import 'package:application/components/button_components/custom_icon_button.dart';
import 'package:application/components/navigation/push_replacement.dart';
import 'package:application/components/profile_image.dart';
import 'package:application/components/square_tile_icon.dart';
import 'package:application/components/static_components/or_continue_with.dart';
import 'package:application/components/text_components/input_text.dart';
import 'package:application/components/text_components/numeric_text.dart';
import 'package:application/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddEmployee extends StatefulWidget {
  final String token;
  const AddEmployee({required this.token, super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController employeeEmailController = TextEditingController();
  TextEditingController employeeNumberController = TextEditingController();
  TextEditingController employeeAddressController = TextEditingController();
  TextEditingController optionController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  bool _isNotValid6 = false;
  bool _isNotValid1 = false;
  bool _isNotValid2 = false;
  bool _isNotValid3 = false;
  bool _isNotValid4 = false;
  bool _isNotValid5 = false;
  bool isLoading = false;

  io.File? selectedImage;

  late String img64;
  String? base64String;
  late List<String> parts;
  late String type = "";
  late Uint8List imageData;

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      io.File imageFile = io.File(returnedImage.path);
      processImage(imageFile); // Reuse the common logic
    }
  }

  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage != null) {
      io.File imageFile = io.File(returnedImage.path);
      processImage(imageFile); // Reuse the common logic
    }
  }

  void processImage(io.File imageFile) async {
    setState(() {
      selectedImage = imageFile;
    });

    imageData = await readImageFile(imageFile.path);
    String selectedImg = imageFile.path;
    parts = selectedImg.split('.');
    String extension_ = parts[parts.length - 1];
    type = extension_.substring(0, 3);
  }

  Future<Uint8List> readImageFile(String filePath) async {
    io.File imageFile = io.File(filePath);
    return await imageFile.readAsBytes();
  }

  late String email;
  late String uId;
  late String signedUrl;
  late String photoKey;

  late SharedPreferences prefs;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    uId = jwtDecodedToken['_id'];
    initSharedPref();
  }

  // void uploadPhoto_() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var reqBody = {"email": email, "type": type};

  //   var response = await http.post(Uri.parse(uploadPhoto),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(reqBody));

  //   var jsonResponse = jsonDecode(response.body);

  //   signedUrl = jsonResponse["success"][0];
  //   photoKey = jsonResponse["success"][1];
  //   uploadS3_();
  //   addEmployee();
  // }

  // void uploadS3_() async {
  //   await http.put(Uri.parse(signedUrl),
  //       headers: {"Content-Type": "image/$type"}, body: imageData);
  // }

  void addEmployee() async {
    setState(() {
      _isNotValid1 = employeeIdController.text.isEmpty;
      _isNotValid2 = employeeNameController.text.isEmpty;
      _isNotValid3 = employeeEmailController.text.isEmpty;
      _isNotValid4 = employeeNumberController.text.isEmpty;
      _isNotValid5 = employeeAddressController.text.isEmpty;
      _isNotValid6 = districtController.text.isEmpty;
      isLoading = true;
    });

    if (employeeIdController.text.isNotEmpty &&
        employeeNameController.text.isNotEmpty &&
        employeeEmailController.text.isNotEmpty &&
        employeeNumberController.text.isNotEmpty &&
        employeeAddressController.text.isNotEmpty &&
        districtController.text.isNotEmpty) {
      var reqBody = {
        "name": employeeNameController.text,
        "avatar": imageData,
        "emailId": employeeEmailController.text,
        "mobile": employeeNumberController.text,
        "country": employeeAddressController.text,
        "state": employeeIdController.text,
        "district": districtController.text,
      };

      var response = await http.post(
          Uri.parse(
              'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      if (jsonResponse.isNotEmpty) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        pushReplacement(
            context,
            HomePage(
              token: prefs.getString('token')!,
            ));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Employee'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
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
                              ProfileImage(
                                selectedImage: selectedImage,
                                type: false,
                                imageUrl: null,
                                radius: 60,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconButton(
                                    icon: const Icon(
                                      Icons.image_search_rounded,
                                    ),
                                    onPressed: pickImageFromGallery,
                                    iconSize: 33.0,
                                    clr: const Color.fromARGB(255, 46, 45, 45),
                                  ),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  CustomIconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                    ),
                                    onPressed: pickImageFromCamera,
                                    iconSize: 33.0,
                                    clr: const Color.fromARGB(255, 46, 45, 45),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const OrContinueWith(
                                msg: 'Add employee details',
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InputTextField(
                                hintText: 'Name',
                                existance: _isNotValid2,
                                controller: employeeNameController,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InputTextField(
                                hintText: 'Email',
                                existance: _isNotValid3,
                                controller: employeeEmailController,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              NumericText(
                                hintText: 'Number',
                                existance: _isNotValid4,
                                controller: employeeNumberController,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InputTextField(
                                hintText: 'Country',
                                existance: _isNotValid5,
                                controller: employeeAddressController,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InputTextField(
                                hintText: 'State',
                                existance: _isNotValid1,
                                controller: employeeIdController,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InputTextField(
                                hintText: 'District',
                                existance: _isNotValid6,
                                controller: districtController,
                              ),
                              const SizedBox(
                                height: 75,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: 1,
              right: 15,
              child: SquareTileIcon(
                icon: Icons.add_circle,
                onPressed: addEmployee,
                labelText: '',
                clr: Colors.white,
                bgColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
