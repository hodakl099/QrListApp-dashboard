import 'dart:html';
import 'package:admin/components/applocal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../models/category_model/Category.dart';
import '../../../util/file_uploader.dart';
import '../../../util/file_uploader_mobile.dart';
import '../../../util/file_uploader_web.dart';
import 'dart:io' as io;
import 'dart:html' as html;

class EditAgriculturalForm extends StatefulWidget {
  final CategoryApi property;
  final ValueNotifier<int> refreshPropertiesNotifier;

  EditAgriculturalForm({
    required this.property,
    required this.refreshPropertiesNotifier,
  });

  @override
  _EditAgriculturalFormState createState() => _EditAgriculturalFormState();
}

class _EditAgriculturalFormState extends State<EditAgriculturalForm> {
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
    return Scaffold(
      appBar: AppBar(title: Text("${getLang(context, 'Edit Category')}")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Category Name"),
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
                child: Text("Select Images"),
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

                    if (
                    _nameController.text.isEmpty ||
                    _image == null
                    ) {
                      Navigator.of(context, rootNavigator: true).pop();

                      final snackBar = SnackBar(
                        content: Text(
                            'Please fill in all fields and select at least 1 image and 1 video.'),
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
                        final property = CategoryApi(name: 'Majito', image: '');
                        // response = await updateAgriculturalPropertyWeb(
                        //   property.id!,
                        //   property,
                        // );
                      } else {
                        // Mobile-specific logic
                        final property = CategoryApi(name: 'Majito', image: '');

                        // response = await updateAgriculturalPropertyMobile(
                        //   property.id!,
                        //   property,
                        // );
                      }

                      if (response.statusCode == 200) {
                        isSuccess = true;
                        message = 'Update successful!';

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

                    final snackBar = SnackBar(content: Text(message));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (isSuccess) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text("Update Property"),
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
              Text("Updating..."),
            ],
          ),
        );
      },
    );
  }
}
