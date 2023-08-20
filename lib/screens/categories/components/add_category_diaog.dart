import 'dart:io';
import 'dart:convert';
import 'package:admin/components/applocal.dart';
import 'package:admin/server/categories/get/get_all_categories.dart';
import 'package:admin/server/categories/post/api_calls_mobile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../models/category_model/Category.dart';
import '../../../server/categories/post/api_calls_web.dart';
import '../../../util/file_uploader.dart';
import '../../../util/file_uploader_mobile.dart';
import '../../../util/file_uploader_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddCategoryDialog extends StatefulWidget {
  final ValueNotifier<int> refreshCategoriesNotifier;

  AddCategoryDialog({required this.refreshCategoriesNotifier});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late Future<List<CategoryApi>> categoriesFuture;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  dynamic _image;

  final FileUploader fileUploader =
      kIsWeb ? FileUploaderWeb() : FileUploaderMobile();

  @override
  void initState() {
    super.initState();
    categoriesFuture = fetchAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "${getLang(context, 'name')}"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${getLang(context, 'Please enter a Category name')}';
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
                child: Text("${getLang(context,'Select Image')}"),
              ),
              Wrap(
                spacing: 8,
                children: [
                  if (_image != null)
                    Chip(
                      label: Text(_image is File
                          ? _image.path.split('/').last
                          : _image.name),
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
                  if (_formKey.currentState!.validate()) {
                    _showLoadingDialog(context);
                    if (_nameController.text.isEmpty || _image == null) {
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
                        final property = CategoryApi(name: _nameController.text, image: _image);
                        response =
                            await uploadCategoryPropertyWeb(property);
                      } else {
                        // Mobile-specific logic
                        final category = CategoryApi(name: _nameController.text, image: _image);
                        response =
                            await uploadCategoryMobile(category);
                      }
                      if (response.statusCode == 200) {
                        isSuccess = true;
                        message = '${getLang(context, 'successMessage')}';
                        setState(() {
                          categoriesFuture = fetchAllCategories();
                        });
                        Navigator.of(context).pop();
                        widget.refreshCategoriesNotifier.value++;
                      } else {
                        var responseBody =
                            await response.stream.bytesToString();
                        var decodedResponse = jsonDecode(responseBody);
                        message = decodedResponse['message'] ??
                            'Something went wrong. Please try again later.';
                      }
                    } catch (e) {
                      print("Error uploading: $e");
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
