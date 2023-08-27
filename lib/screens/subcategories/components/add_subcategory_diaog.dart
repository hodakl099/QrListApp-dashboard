import 'dart:io';
import 'dart:convert';
import 'package:admin/components/applocal.dart';
import 'package:admin/models/sub_category/SubCategoryModel.dart';
import 'package:admin/server/sub_categories/post/api_calls_mobile.dart';
import 'package:admin/server/sub_categories/post/api_calls_web.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constants.dart';
import '../../../server/sub_categories/get/get_subcategries_by_id.dart';
import '../../../util/file_uploader.dart';
import '../../../util/file_uploader_mobile.dart';
import '../../../util/file_uploader_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class AddSubCategoryDialog extends StatefulWidget {
  final ValueNotifier<int> refreshCategoriesNotifier;
  final String selectedCategory;

  AddSubCategoryDialog({required this.refreshCategoriesNotifier, required this.selectedCategory});

  @override
  _AddSubCategoryDialogState createState() => _AddSubCategoryDialogState();
}

class _AddSubCategoryDialogState extends State<AddSubCategoryDialog> {
  late Future<List<SubCategory>> _subCategories;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  dynamic _image;

  final FileUploader fileUploader =
      kIsWeb ? FileUploaderWeb() : FileUploaderMobile();

  @override
  void initState() {
    super.initState();
    _subCategories = getSubCategoriesById(widget.selectedCategory);
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
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "${getLang(context, 'price')}",suffix: Text('LYD')),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${getLang(context, 'Please enter a Category price')}';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
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
                style: ButtonStyle(
                  backgroundColor: materialStateColor,
                ),
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
                        final subCategory = SubCategory(name: _nameController.text, image: _image, price : _priceController.text);
                        response =
                            await uploadSubCategoryWeb(subCategory,widget.selectedCategory);
                      } else {
                        // Mobile-specific logic
                        final subCategory = SubCategory(name:_nameController.text, image: _image, price : _priceController.text);
                        response =
                            await uploadSubCategoryMobile(subCategory,widget.selectedCategory);
                      }
                      if (response.statusCode == 201) {
                        isSuccess = true;
                        message = '${getLang(context, 'successMessage')}';
                        setState(() {
                          _subCategories = getSubCategoriesById(widget.selectedCategory);
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

                    Fluttertoast.showToast(msg: message,toastLength:Toast.LENGTH_LONG);
                    if (isSuccess) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text("${getLang(context, 'Submit')}"),
                style: ButtonStyle(
                  backgroundColor: materialStateColor,
                ),
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
