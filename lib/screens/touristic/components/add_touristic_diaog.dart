import 'dart:io';
import 'dart:convert';
import 'package:admin/models/touristic_model/TouristicProperty.dart';
import 'package:admin/server/touristic/get/get_all_touristic.dart';
import 'package:admin/server/touristic/post/api_calls_mobile.dart';
import 'package:admin/server/touristic/post/api_calls_web.dart';
import 'package:flutter/material.dart';
import '../../../util/file_uploader.dart';
import '../../../util/file_uploader_mobile.dart';
import '../../../util/file_uploader_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddTouristicDialog extends StatefulWidget {
  final ValueNotifier<int> refreshPropertiesNotifier;

  AddTouristicDialog({required this.refreshPropertiesNotifier});

  @override
  _AddTouristicDialogState createState() => _AddTouristicDialogState();
}

class _AddTouristicDialogState extends State<AddTouristicDialog> {
  late Future<List<TouristicPropertyApi>> _propertiesFuture;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _agentContactController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _acresController = TextEditingController();
  TextEditingController _roomsController = TextEditingController();
  TextEditingController _unitsController = TextEditingController();
  TextEditingController _amenitiesController = TextEditingController();
  TextEditingController _proximityToAttractionsController = TextEditingController();
  TextEditingController _occupancyRateController = TextEditingController();

  List<dynamic> _images = [];
  List<dynamic> _videos = [];

  final FileUploader fileUploader =
      kIsWeb ? FileUploaderWeb() : FileUploaderMobile();

  @override
  void initState() {
    super.initState();
    _propertiesFuture = fetchAllTouristic();
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
                initialValue: 'Touristic',
                enabled: false,
                decoration: InputDecoration(labelText: "Property Type"),
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
                decoration:
                    InputDecoration(labelText: "Price", suffixText: 'LYD'),
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
                decoration:
                    InputDecoration(labelText: "Acres", suffixText: 'M²'),
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
                controller: _roomsController,
                decoration:
                InputDecoration(labelText: "Rooms"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of rooms';
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
                controller: _unitsController,
                decoration:
                InputDecoration(labelText: "units"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Number of bathrooms.';
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
                controller: _amenitiesController,
                decoration: InputDecoration(labelText: "Amenities"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Amenities description.';
                  }
                  if (value.length > 256) {
                    return 'Amenities description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _proximityToAttractionsController,
                decoration: InputDecoration(labelText: "Proximity to attractions"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter parking description.';
                  }
                  if (value.length > 256) {
                    return 'parking description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _occupancyRateController,
                decoration: InputDecoration(labelText: "Occupancy Rate"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Occupancy Rate.';
                  }
                  if (value.length > 256) {
                    return 'Occupancy Rate description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
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
                    label: Text(
                        file is File ? file.path.split('/').last : file.name),
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
                    label: Text(
                        file is File ? file.path.split('/').last : file.name),
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
                    if (
                        _agentContactController.text.isEmpty ||
                        _priceController.text.isEmpty ||
                        _locationController.text.isEmpty ||
                        _acresController.text.isEmpty ||
                        _roomsController.text.isEmpty ||
                        _unitsController.text.isEmpty ||
                        _amenitiesController.text.isEmpty ||
                        _proximityToAttractionsController.text.isEmpty ||
                            _occupancyRateController.text.isEmpty ||
                        _images.isEmpty ||
                        _videos.isEmpty)
                    {
                      Navigator.of(context, rootNavigator: true).pop();

                      final snackBar = SnackBar(
                        content: Text(
                            'Please fill in all fields and select at least 1 image and 1 video.'
                        ),
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
                        final property = TouristicPropertyApi(
                          propertyType: 'Touristic',
                          location: _locationController.text,
                          agentContact: _agentContactController.text,
                          price: int.tryParse(_priceController.text) ?? 0,
                          acres: int.tryParse(_acresController.text) ?? 0,
                          amenities: _amenitiesController.text,
                          proximityToAttractions: _proximityToAttractionsController.text,
                          occupancyRate: _occupancyRateController.text,
                          rooms:int.tryParse(_roomsController.text) ?? 0,
                          units:int.tryParse(_unitsController.text) ?? 0,
                          images: _images,
                          videos: _videos,
                        );
                        response =
                            await uploadTouristicPropertyWeb(property);
                      } else {
                        // Mobile-specific logic
                        final property = TouristicPropertyApi(
                          propertyType: 'Touristic',
                          location: _locationController.text,
                          agentContact: _agentContactController.text,
                          price: int.tryParse(_priceController.text) ?? 0,
                          acres: int.tryParse(_acresController.text) ?? 0,
                          amenities: _amenitiesController.text,
                          proximityToAttractions: _proximityToAttractionsController.text,
                          occupancyRate: _occupancyRateController.text,
                          rooms:int.tryParse(_roomsController.text) ?? 0,
                          units:int.tryParse(_unitsController.text) ?? 0,
                          images: _images,
                          videos: _videos,
                        );
                        response =
                            await uploadTouristicPropertyMobile(property);
                      }
                      if (response.statusCode == 200) {
                        isSuccess = true;
                        message = 'Upload successful!';
                        setState(() {
                          _propertiesFuture = fetchAllTouristic();
                        });
                        widget.refreshPropertiesNotifier.value++;
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
