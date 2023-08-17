import 'package:admin/components/applocal.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  final String username;

  MainScreen({required this.username});


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(username: '${getLang(context, username)}'),
            ),
          ],
        ),
      ),
    );
  }
}
