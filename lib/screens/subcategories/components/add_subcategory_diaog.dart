import 'dart:io';
import 'dart:convert';
import 'package:admin/components/applocal.dart';
import 'package:admin/models/sub_category/SubCategoryModel.dart';
import 'package:admin/server/categories/get/get_category_by_id.dart';
import 'package:admin/server/sub_categories/post/api_calls_mobile.dart';
import 'package:admin/server/sub_categories/post/api_calls_web.dart';
import 'package:flutter/material.dart';
import '../../../models/category_model/Category.dart';
import '../../../server/categories/get/get_all_categories.dart';
import '../../../server/sub_categories/get/get_subcategries_by_id.dart';
import '../../../util/file_uploader.dart';
import '../../../util/file_uploader_mobile.dart';
import '../../../util/file_uploader_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddSubCategoryDialog extends StatefulWidget {
  final ValueNotifier<int> refreshCategoriesNotifier;

  AddSubCategoryDialog({required this.refreshCategoriesNotifier});

  @override
  _AddSubCategoryDialogState createState() => _AddSubCategoryDialogState();
}

class _AddSubCategoryDialogState extends State<AddSubCategoryDialog> {
  late Future<List<SubCategory>> _subCategories;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  dynamic _image;

  final FileUploader fileUploader =
      kIsWeb ? FileUploaderWeb() : FileUploaderMobile();

  @override
  void initState() {
    super.initState();
    _subCategories = getSubCategoriesById('2');
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
                child: Text("Select Image"), // Label changed to "Select Image"
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
                        final subCategory = SubCategory(name: _nameController.text, image: _image);
                        response =
                            await uploadSubCategoryWeb(subCategory,'2');
                      } else {
                        // Mobile-specific logic
                        final subCategory = SubCategory(name:_nameController.text, image: _image);
                        response =
                            await uploadSubCategoryMobile(subCategory,'2');
                      }
                      if (response.statusCode == 200) {
                        isSuccess = true;
                        message = 'Upload successful!';
                        setState(() {
                          _subCategories = getSubCategoriesById('2');
                        });
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

                    final snackBar = SnackBar(content: Text(message));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (isSuccess) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text("Submit"),
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
              Text("Uploading..."),
            ],
          ),
        );
      },
    );
  }
}
