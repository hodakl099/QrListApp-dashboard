import 'dart:math';

import 'package:admin/components/applocal.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controllers/MenuAppController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;

  late String username;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();



  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '${getLang(context, 'enterAnEmail')}';
    }
    const emailRegex = r'^[^@]+@[^@]+\.[^@]+';
    if (!RegExp(emailRegex).hasMatch(value)) {
      return '${getLang(context, 'enterValidEmail')}';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '${getLang(context, 'enterValidPassword')}';
    }
    if (value.length < 6) {
      return '${getLang(context, 'characterLimits')}';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    controller1 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation1 = Tween<double>(begin: .1, end: .15).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });
    animation2 = Tween<double>(begin: .02, end: .04).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
      setState(() {});
    });

    controller2 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation3 = Tween<double>(begin: .41, end: .38).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });
    animation4 = Tween<double>(begin: 170, end: 190).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
      setState(() {});
    });

    Timer(Duration(milliseconds: 2500), () {
      controller1.forward();
    });

    controller2.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double scale = size.width < 600 ? 1 : size.width / 600;
    double verticalPadding = size.width < 600 ? 16 : size.width * 0.05;
    double horizontalPadding = size.width < 600 ? 16 : size.width * 0.15;
    final menuAppController = Provider.of<MenuAppController>(context);


    return Form(
      key: _formKey,
      child: Scaffold(
        key: menuAppController.scaffoldKey,
        backgroundColor: Colors.white,
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Container(
              height: max(size.height, 600),
              child: Stack(
                children: [
                  Positioned(
                    top: size.height * (animation2.value + .58),
                    left: size.width * .21,
                    child: CustomPaint(
                      painter: MyPainter(50),
                    ),
                  ),
                  Positioned(
                    top: size.height * .98,
                    left: size.width * .1,
                    child: CustomPaint(
                      painter: MyPainter(animation4.value - 30),
                    ),
                  ),
                  Positioned(
                    top: size.height * .5,
                    left: size.width * (animation2.value + .8),
                    child: CustomPaint(
                      painter: MyPainter(30),
                    ),
                  ),
                  Positioned(
                    top: size.height * animation3.value,
                    left: size.width * (animation1.value + .1),
                    child: CustomPaint(
                      painter: MyPainter(60),
                    ),
                  ),
                  Positioned(
                    top: size.height * .1,
                    left: size.width * .8,
                    child: CustomPaint(
                      painter: MyPainter(animation4.value),
                    ),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 1600),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: verticalPadding,
                            horizontal: horizontalPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min, // <-- This is the change
                          children: [
                            Text(
                              '${getLang(context, 'logIn')}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(.7),
                                fontSize: 16 * scale,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                wordSpacing: 4,
                              ),
                            ),
                            SizedBox(height: 10 * scale),
                            // inputTextField(Icons.account_circle_outlined,
                            //     'User name...', false, false, 1),
                            SizedBox(height: 10 * scale),
                            inputTextField(Icons.email_outlined, '${getLang(context, 'email')}', false, true, 1.0, _emailController, emailValidator),
                            SizedBox(height: 10 * scale),
                            inputTextField(Icons.lock_outline, '${getLang(context, 'password')}', true,
                                false, 1,_passwordController,passwordValidator),
                            SizedBox(height: 10 * scale),
                            Wrap(
                                children: [
                                  actionButton('${getLang(context, 'loginAction')}', 1, () async {
                                    HapticFeedback.lightImpact();
                                    // Fluttertoast.showToast(
                                    //     msg: 'Login button pressed');
                                    _showLoadingDialog(context);
                                 bool loginSuccess =  await _login();

                                 if(loginSuccess) {
                                 _passwordController.clear();
                                 _emailController.clear();
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(username: 'TAJ MEDIA')));
                                 }

                                 if(!loginSuccess) {
                                   _showErrorDialog(context);
                                 }
                                  }),
                                  SizedBox(width: 10 * scale),
                                ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail, double scale, TextEditingController controller, FormFieldValidator<String> validator) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 15,
          sigmaX: 15,
        ),
        child: Container(
          height: 60 * scale,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10 * scale),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            obscureText: isPassword,
            keyboardType:
            isEmail ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(.7),
              ),
              border: InputBorder.none,
              hintMaxLines: 1,
              hintText: hintText,
              hintStyle:
              TextStyle(fontSize: 12 * scale, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget actionButton(String string, double scale, VoidCallback voidCallback) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
        child: InkWell(
          highlightColor: Colors.grey,
          splashColor: Colors.grey,
          onTap: voidCallback,
          child: Container(
            height: 50 * scale,
            width: 200 * scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              string,
              style: TextStyle(color: Colors.white.withOpacity(.8)),
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> _login() async {
    final isValid = _formKey.currentState!.validate();

    MenuAppController menuAppController = Provider.of<MenuAppController>(context, listen: false);
    if (!isValid) {
      Navigator.of(context).pop();  // Dismiss loading dialog
      return false;
    }

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
       userCredential.user;

      Navigator.of(context).pop();


      // DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_emailController.text).get();
      //
      // String username = userDoc.get('username');
      //
      // String role = userDoc.get('role');
      //
      // List<String> permissions = List<String>.from(userDoc['permissions']);
      // menuAppController.userPermissions = permissions;
      // menuAppController.role = role;
      menuAppController.notifyListeners();

      // print(permissions);

      // this.username = username;

      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: 'Wrong password provided for that user.');
      }
      Navigator.of(context).pop();  // Dismiss loading dialog
      return false;
    }
  }
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Logging in..."),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${getLang(context, 'loginFailed')}', style: TextStyle(color: Colors.white),),
          content: Text('${getLang(context, 'incorrectPassOrEmail')}', style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            TextButton(
              child: Text('${getLang(context, 'Cancel')}',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class MyPainter extends CustomPainter {
  final double radius;

  MyPainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
          colors: [Colors.grey, Colors.blueGrey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)
          .createShader(Rect.fromCircle(
        center: Offset(0, 0),
        radius: radius,
      ));

    canvas.drawCircle(Offset.zero, radius, paint);
  }




  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }


}