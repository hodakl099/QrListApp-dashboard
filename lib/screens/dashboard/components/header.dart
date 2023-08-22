import 'package:admin/components/applocal.dart';
import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Header extends StatelessWidget {

  final String username;

  const Header({
    Key? key, required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.watch<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            "${getLang(context, 'dashboard')}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        ProfileCard(username: username,)
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {

  final String username;

  const ProfileCard({
    Key? key, required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(username,style: TextStyle(fontSize: 20),),
            ),
          if (!Responsive.isDesktop(context))
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: defaultPadding / 3),
              child: Text(username,style: TextStyle(fontSize: 12),),
            ),
        ],
      ),
    );
  }
}
