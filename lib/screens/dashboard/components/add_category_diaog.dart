import 'dart:io';
import 'dart:convert';
import 'package:admin/server/categories/get/get_all_agricaltural.dart';
import 'package:flutter/material.dart';
import '../../../models/agricultural_model/AgriculturalProperty.dart';
import '../../../util/file_uploader.dart';
import '../../../util/file_uploader_mobile.dart';
import '../../../util/file_uploader_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {

  late Future<List<CategoryApi>> _propertiesFuture;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _agentContactController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _propertyTypeController = TextEditingController();
  TextEditingController _acresController = TextEditingController();
  TextEditingController _buildingsController = TextEditingController();
  TextEditingController _cropsController = TextEditingController();
  TextEditingController _waterSourcesController = TextEditingController();
  TextEditingController _soilTypeController = TextEditingController();
  TextEditingController _equipmentController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  List<dynamic> _images = [];

  List<dynamic> _videos = [];

  final FileUploader fileUploader =
      kIsWeb ? FileUploaderWeb() : FileUploaderMobile();

  @override
  void initState() {
    super.initState();
    _propertiesFuture = fetchAllCategories();
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
                controller: _propertyTypeController,
                decoration: InputDecoration(labelText: "Property Type"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Property type';
                  }
                  if (value.length > 256) {
                    return 'Crops description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _agentContactController,
                decoration: InputDecoration(labelText: "Agent Contact"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Agent Contact';
                  }
                  if (value.length > 256) {
                    return 'Crops description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Price"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  final int? price = int.tryParse(value);
                  if (price == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _acresController,
                decoration: InputDecoration(labelText: "Acres"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of acres';
                  }
                  final int? acres = int.tryParse(value);
                  if (acres == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _buildingsController,
                decoration: InputDecoration(labelText: "Buildings"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid Buildings';
                  }
                  if (value.length > 256) {
                    return 'Crops description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _cropsController,
                decoration: InputDecoration(labelText: "Crops"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Crops.';
                  }
                  if (value.length > 256) {
                    return 'Crops description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _waterSourcesController,
                decoration: InputDecoration(labelText: "Water Sources"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Water Sources.';
                  }
                  if (value.length > 256) {
                    return 'Crops description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _soilTypeController,
                decoration: InputDecoration(labelText: "Soil Type"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Soil Type.';
                  }
                  if (value.length > 256) {
                    return 'Crops description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _equipmentController,
                decoration: InputDecoration(labelText: "Equipment"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid equipment.';
                  }
                  if (value.length > 256) {
                    return 'Crops description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),  TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: "Location"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid location.';
                  }
                  if (value.length > 256) {
                    return 'Crops description must be less than 256 characters';
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
                      _images.addAll(files);
                    });
                  }
                },
                child: Text("Select Images"),
              ),
              Wrap(
                spacing: 8,
                children: _images.map((file) {
                  return Chip(
                    label: Text(file is File ? file.path.split('/').last : file.name),
                    onDeleted: () {
                      setState(() {
                        _images.remove(file);
                      });
                    },
                    deleteIcon: Icon(Icons.close),
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final files = await fileUploader.pickVideos();
                  if (files.isNotEmpty) {
                    setState(() {
                      _videos.addAll(files);
                    });
                  }
                },
                child: Text("Select Videos"),
              ),
              Wrap(
                spacing: 8,
                children: _videos.map((file) {
                  return Chip(
                    label: Text(file is File ? file.path.split('/').last : file.name),
                    onDeleted: () {
                      setState(() {
                        _videos.remove(file);
                      });
                    },
                    deleteIcon: Icon(Icons.close),
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _showLoadingDialog(context);
                    // Check if all fields are not empty
                    if (_propertyTypeController.text.isEmpty ||
                        _agentContactController.text.isEmpty ||
                        _priceController.text.isEmpty ||
                        _acresController.text.isEmpty ||
                        _buildingsController.text.isEmpty ||
                        _cropsController.text.isEmpty ||
                        _waterSourcesController.text.isEmpty ||
                        _soilTypeController.text.isEmpty ||
                        _equipmentController.text.isEmpty ||
                        _locationController.text.isEmpty ||
                        _images.isEmpty ||
                        _videos.isEmpty) {
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
                        // response = await uploadAgriculturalPropertyWeb(property);
                      } else {
                        // Mobile-specific logic
                        final property = CategoryApi(name: 'Majito', image: '');
                        // response =
                        //     await uploadAgriculturalPropertyMobile(property);
                      }
                      if (response.statusCode == 200) {
                        isSuccess = true;
                        message = 'Upload successful!';
                        setState(() {
                          _propertiesFuture = fetchAllCategories();
                        });
                      } else {
                        var responseBody = await response.stream.bytesToString();
                        var decodedResponse = jsonDecode(responseBody);
                        message = decodedResponse['message'] ?? 'Something went wrong. Please try again later.';
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
