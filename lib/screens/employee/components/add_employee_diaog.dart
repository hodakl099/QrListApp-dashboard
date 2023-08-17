import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEmployeeDialog extends StatefulWidget {
  final ValueNotifier<int> refreshPropertiesNotifier;

  AddEmployeeDialog({required this.refreshPropertiesNotifier});
  @override
  _AddEmployeeDialogState createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  String _role = 'employee';
  List<String> _permissions = [];

  final _permissionsList = ["Add", "Edit", "Delete", "Update"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height *
                  0.5), // adjust the value as needed
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: "Username"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  validator: (value) {
                    String pattern =
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
                    RegExp regex = RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (!regex.hasMatch(value)) {
                      return 'min: 1 uppercase, 1 lowercase, \n1 number and 1 special character';
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: _permissionsList
                      .map((permission) => Padding(
                            padding: EdgeInsets.only(left: 2, right: 2),
                            child: ChoiceChip(
                              label: Text(permission),
                              selected: _permissions.contains(permission),
                              onSelected: (selected) {
                                setState(() {
                                  selected
                                      ? _permissions.add(permission)
                                      : _permissions.remove(permission);
                                });
                              },
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _permissions.isNotEmpty) {
                      _showCreatingDialog(context);
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        // add user details to Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(_emailController.text)
                            .set({
                          'username': _usernameController.text,
                          'role': _role,
                          'permissions': _permissions,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('User added successfully'),
                          backgroundColor: Colors.green,
                        ));
                        widget.refreshPropertiesNotifier.value++;
                        // Close 'Creating' dialog and 'Add Employee' dialog
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('An error occurred while adding user'),
                            backgroundColor: Colors.red,
                          ),
                        );

                        // Close 'Creating' dialog and 'Add Employee' dialog
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    } else if (_permissions.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Invalid permissions'),
                          content: Text('Adding at least one permission is required'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Dismiss'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showCreatingDialog(BuildContext context) {
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
            Text("Creating Employee..."),
          ],
        ),
      );
    },
  );
}

