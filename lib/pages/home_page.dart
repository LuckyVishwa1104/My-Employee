import 'package:application/components/utility/filter_chip_component.dart';
import 'package:application/components/utility/list_tile_component.dart';
import 'package:application/components/navigation/push.dart';
import 'package:application/components/square_tile_icon.dart';
import 'package:application/components/utility/drawer/app_drawer.dart';
import 'package:application/components/utility/search_bar.dart';
import 'package:application/pages/add_employee.dart';
import 'package:application/pages/employee_details.dart';
import 'package:application/pages/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({required this.token, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int cnt = 0;
  bool isLoading = true;
  late SharedPreferences prefs;
  late String email;
  late String uId;
  List<dynamic> employees = [];
  String searchQuery = "";
  String selectedPosition = "";

  @override
  void initState() {
    super.initState();
    initSharedPref();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    uId = jwtDecodedToken['_id'];
    getEmployeeDetails();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Future<void> getEmployeeDetails() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     List<dynamic> data = await fetchEmployeeDetails(uId,
  //         position: selectedPosition, filter: searchQuery);
  //     setState(() {
  //       employees = data;
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<List<dynamic>> fetchEmployeeDetails(String userId,
  //     {String? position, String? filter}) async {
  //   try {
  //     String url = '$bulkEmployeeDetails?userId=$userId';
  //     if (position != null && position.isNotEmpty) {
  //       url += '&filter=$position';
  //     }
  //     if (filter != null && filter.isNotEmpty) {
  //       url += '&filter=$filter';
  //     }

  //     final response = await http.get(Uri.parse(url));

  //     final jsonResponse = jsonDecode(response.body);

  //     if (jsonResponse['status']) {
  //       return jsonResponse['success'];
  //     } else {
  //       throw Exception('Failed to load employee details');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching data: $e');
  //   }
  // }

  Future<void> getEmployeeDetails() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
        Uri.parse(
            'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee'),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        });

    final data = jsonDecode(response.body);

    setState(() {
      employees = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('MyEmployee'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            SearchEmployee(
              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                getEmployeeDetails();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilterChipComponent(
                  label: 'Intern',
                  selected: selectedPosition == 'intern',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedPosition = selected ? 'intern' : '';
                      getEmployeeDetails();
                    });
                  },
                ),
                const SizedBox(width: 10),
                FilterChipComponent(
                  label: 'Junior',
                  selected: selectedPosition == 'Junior Developer',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedPosition = selected ? 'Junior Developer' : '';
                      getEmployeeDetails();
                    });
                  },
                ),
                const SizedBox(width: 10),
                FilterChipComponent(
                  label: 'Senior',
                  selected: selectedPosition == 'Senior Developer',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedPosition = selected ? 'Senior Developer' : '';
                      getEmployeeDetails();
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.black,
                    ))
                  : employees.isNotEmpty
                      ? EmployeeList(
                          employees: employees,
                          onEmployeeTap: (employee) {
                            push(
                              context,
                              EmployeeDetails(
                                token: prefs.getString('token')!,
                                uId: employee['id'],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'No employees found',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SquareTileIcon(
                                  icon: Icons.add_circle,
                                  onPressed: () => {
                                        push(
                                          context,
                                          AddEmployee(
                                            token: prefs.getString('token')!,
                                          ),
                                        ),
                                      },
                                  labelText: '',
                                  clr: Colors.blue,
                                  bgColor: Colors.grey.shade300)
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home_filled,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Add Employee',
            icon: Icon(
              Icons.add_circle,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Setting',
            icon: Icon(
              Icons.settings,
            ),
          ),
        ],
        currentIndex: cnt,
        onTap: (int index) {
          setState(() {
            cnt = index;
          });
          if (index == 1) {
            setState(() {
              cnt = 0;
            });
            push(
              context,
              AddEmployee(token: prefs.getString('token') ?? ''),
            );
          }
          if (index == 2) {
            setState(() {
              cnt = 0;
            });
            push(
              context,
              MyProfile(token: prefs.getString('token')!),
            );
          }
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
