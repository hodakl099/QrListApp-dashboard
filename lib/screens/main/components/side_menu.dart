import 'package:admin/components/applocal.dart';
import 'package:admin/screens/login/login_screen.dart';
import 'package:admin/screens/subcategories/subcategories_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../main.dart';
import '../../categories/categories_screen.dart';


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
            child: SvgPicture.asset("assets/images/tajmedialogo.svg",color: Colors.white,),
          ),
          DrawerListTile(
            title: "${getLang(context, 'Category')}",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CategoriesScreen(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "${getLang(context, 'Product')}",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SubCategoriesScreen(),
                ),
              );
            },
          ),
          DrawerListTile(
            title:"${getLang(context, 'Logout')}",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              _showSignOutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${getLang(context, 'Logout')}'),
          content: Text('${getLang(context, 'logoutConfirmation')}'),
          actions: <Widget>[
            TextButton(
              child: Text('${getLang(context,'Cancel')}',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('${getLang(context, 'yes')}',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _signOut().then((value) {
                  Fluttertoast.showToast(
                    msg: '${getLang(context, 'loggedOut')}',
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
