
import 'dart:html';
import 'package:admin/components/applocal.dart';
import 'package:admin/server/categories/put/update_calls_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import '../../../models/category_model/Category.dart';
import '../../../server/categories/put/update_calls_mobile.dart';
import '../../../util/file_uploader.dart';
import '../../../util/file_uploader_mobile.dart';
import '../../../util/file_uploader_web.dart';
import 'dart:io' as io;
import 'dart:html' as html;


class EditSubCategoryForm extends StatefulWidget {
  final CategoryApi property;
  final ValueNotifier<int> refreshPropertiesNotifier;

  EditSubCategoryForm({
    required this.property,
    required this.refreshPropertiesNotifier,
  });

  @override
  _EditSubCategoryFormState createState() => _EditSubCategoryFormState();
}

class _EditSubCategoryFormState extends State<EditSubCategoryForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();

  dynamic _image;

  final FileUploader fileUploader =
  kIsWeb ? FileUploaderWeb() : FileUploaderMobile();

  @override
  void initState() {
    super.initState();


    widget.refreshPropertiesNotifier.addListener(_refreshListener);
  }

  @override
  void dispose() {
    widget.refreshPropertiesNotifier.removeListener(_refreshListener);
    super.dispose();
  }

  void _refreshListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Container(
            width: 300,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "${getLang(context, 'name')}"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Category name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final files = await fileUploader.pickImages();
                      if (files.isNotEmpty) {
                        setState(() {
                          _image = files[0];
                        });
                      }
                    },
                    child: Text("${getLang(context, 'Select Image')}"),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (_image != null)
                        Chip(
                          label: Text(
                              _image is io.File ? (_image as io.File).path.split('/').last : _image.name
                          ),
                          onDeleted: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          deleteIcon: Icon(Icons.close),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _showLoadingDialog(context);
                        if (_nameController.text.isEmpty) {
                          Navigator.of(context, rootNavigator: true).pop();

                          final snackBar = SnackBar(
                            content: Text(
                                '${getLang(context, 'image')}'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }

                        bool isSuccess = false;
                        String message =
                            'Something went wrong. Please try again later.';
                        try {
                          var response;
                          if (kIsWeb) {
                            // Web-specific logic
                            final category = CategoryApi(name: _nameController.text, image: _image);
                            response =
                            await updateCategoryWeb(widget.property.id!.toString(),category);
                          } else {
                            // Mobile-specific logic
                            final category = CategoryApi(name: _nameController.text, image: _image);
                            response =
                            await updateCategoryMobile(widget.property.id!.toString(),category);
                          }

                          if (response.statusCode == 200) {
                            isSuccess = true;
                              message = '${getLang(context, 'successMessage')}';

                            widget.refreshPropertiesNotifier.value++;
                          } else {
                            var responseBody =
                            await response.stream.bytesToString();
                            var decodedResponse = jsonDecode(responseBody);
                            message = decodedResponse['message'] ??
                                'Something went wrong. Please try again later.';
                          }
                        } catch (e) {
                          print("Error updating: $e");
                        } finally {
                          Navigator.of(context, rootNavigator: true).pop();
                        }

                        Fluttertoast.showToast(msg: message,toastLength:Toast.LENGTH_LONG);
                        if (isSuccess) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: Text("${getLang(context, 'Submit')}"),
                  ),
                ],
              ),
            ),
          ),
        );
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
              Text("${getLang(context, 'uploading')}"),
            ],
          ),
        );
      },
    );
  }
}
