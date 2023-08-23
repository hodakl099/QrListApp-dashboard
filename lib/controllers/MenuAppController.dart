import 'package:flutter/material.dart';

class MenuAppController extends ChangeNotifier {



  String username = "";
  String email = "";
  String    restaurantId = "";

  setUserName(String name) {
    username = name;
    notifyListeners();
  }
  setRestaurantId(String id) {
    restaurantId = id;
    notifyListeners();
  }

  setRestaurantEmail(String emailUser) {
    email = emailUser;
    notifyListeners();
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
