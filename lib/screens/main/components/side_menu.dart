import 'package:admin/screens/commercial/commercial_screen.dart';
import 'package:admin/screens/employee/employee_screen.dart';
import 'package:admin/screens/login/login_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/screens/residential/residential_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../main.dart';
import '../../agricultural/agricultural_screen.dart';
import '../../industrial/industrial_screen.dart';
import '../../office/office_screen.dart';
import '../../touristic/touristic_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MenuAppController menuAppController =
        Provider.of<MenuAppController>(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/tajakar.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Agricultural",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AgriculturalScreen(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Commercial",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CommercialScreen(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Industrial",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => IndustrialScreen(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Offices",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OfficeScreen(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Residential",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ResidentialScreen(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Touristic",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TouristicScreen(),
                ),
              );
            },
          ),
          if (menuAppController.role == "admin")
            DrawerListTile(
              title: "Employees",
              svgSrc: "assets/icons/menu_notification.svg",
              press: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EmployeeScreen()
                    )
                );
              },
            ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              _showSignOutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  /// Sign out.
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _signOut().then((value) {
                  Fluttertoast.showToast(
                    msg: 'You are logged out!',
                    toastLength: Toast.LENGTH_LONG,
                  );
                  navigatorKey.currentState!.pushReplacement(
                    MaterialPageRoute(builder: (context) => LogInPage()),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
