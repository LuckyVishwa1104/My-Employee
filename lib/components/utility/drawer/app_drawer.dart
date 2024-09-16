import 'package:application/components/navigation/push.dart';
import 'package:application/components/navigation/push_replacement.dart';
import 'package:application/components/utility/drawer/custom_list_tile.dart';
import 'package:application/pages/add_employee.dart';
import 'package:application/pages/home_page.dart';
import 'package:application/pages/my_profile.dart';
import 'package:application/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  int selectedIndex = 0;

  void logOutUser() {
    _onItemTapped(4);
    prefs.remove('token');
    Navigator.of(context).pop();
    Navigator.of(context).popUntil((route) => route.isFirst);
    pushReplacement(context, const SignIn());
  }

  void addEmployee() {
    _onItemTapped(2);
    Navigator.of(context).pop();
    push(context, AddEmployee(token: prefs.getString('token')!));
  }

  void myProfile() {
    _onItemTapped(1);
    Navigator.of(context).pop();
    push(context, MyProfile(token: prefs.getString('token')!));
  }

  void home() {
    _onItemTapped(0);
    Navigator.of(context).pop();
    Navigator.of(context).popUntil((route) => route.isFirst);
    pushReplacement(
        context,
        HomePage(
          token: prefs.getString('token')!,
        ));
  }

  void helpFunctin() {
    _onItemTapped(3);
    Navigator.of(context).pop();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[200],
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              "MyEmployee",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),
          CustomListTile(
              icon: Icons.home,
              msg: 'Home',
              onPressed: () => {home()},
              selectedIndex: selectedIndex == 0),
          CustomListTile(
              icon: Icons.person,
              msg: 'Profile',
              onPressed: () => {myProfile()},
              selectedIndex: selectedIndex == 1),
          CustomListTile(
              icon: Icons.add_circle,
              msg: 'Add employee',
              onPressed: () => {addEmployee()},
              selectedIndex: selectedIndex == 2),
          CustomListTile(
              icon: Icons.help,
              msg: "Help",
              onPressed: () => {helpFunctin()},
              selectedIndex: selectedIndex == 3),
          CustomListTile(
              icon: Icons.logout,
              msg: 'Logout',
              onPressed: () => {logOutUser()},
              selectedIndex: selectedIndex == 4),
        ],
      ),
    );
  }
}
