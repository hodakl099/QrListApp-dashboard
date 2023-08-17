import 'package:admin/models/residential_model/ResidentialProperty.dart';
import 'package:admin/models/touristic_model/TouristicProperty.dart';
import 'package:admin/server/residential/put/update_calls_web.dart';
import 'package:admin/server/touristic/put/update_calls_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../server/residential/put/update_calls_mobile.dart';
import '../../../server/touristic/put/update_calls_web.dart';
import '../../../util/file_uploader.dart';
import '../../../util/file_uploader_mobile.dart';
import '../../../util/file_uploader_web.dart';
import 'dart:io' as io;
import 'dart:html' as html;

class EditTouristicForm extends StatefulWidget {
  final TouristicPropertyApi property;
  final ValueNotifier<int> refreshPropertiesNotifier;

  EditTouristicForm({
    required this.property,
    required this.refreshPropertiesNotifier,
  });

  @override
  _EditTouristicFormState createState() => _EditTouristicFormState();
}

class _EditTouristicFormState extends State<EditTouristicForm> {
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

  List<dynamic> _newImages = [];
  List<dynamic> _newVideos = [];

  final FileUploader fileUploader =
  kIsWeb ? FileUploaderWeb() : FileUploaderMobile();

  @override
  void initState() {
    super.initState();

    _agentContactController.text = widget.property.agentContact;
    _priceController.text = widget.property.price.toString();
    _acresController.text = widget.property.acres.toString();
    _roomsController.text = widget.property.rooms.toString();
    _unitsController.text = widget.property.units.toString();
    _amenitiesController.text = widget.property.amenities.toString();
    _proximityToAttractionsController.text = widget.property.proximityToAttractions;
    _occupancyRateController.text = widget.property.occupancyRate;
    _locationController.text = widget.property.location;


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
      appBar: AppBar(title: Text("Edit Property")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
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
                      _newImages.addAll(files);
                    });
                  }
                },
                child: Text("Select Images"),
              ),
              Wrap(
                spacing: 8,
                children: _newImages.map((file) {
                  return Chip(
                    label: Text(
                      file is io.File
                          ? file.path.split('/').last
                          : (file is html.File ? file.name : 'Unknown'),
                    ),
                    onDeleted: () {
                      setState(() {
                        _newImages.remove(file);
                        widget.refreshPropertiesNotifier.value++;
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
                      _newVideos.addAll(files);
                    });
                  }
                },
                child: Text("Select Videos"),
              ),
              Wrap(
                spacing: 8,
                children: _newVideos.map((file) {
                  return Chip(
                    label: Text(
                      file is io.File
                          ? file.path.split('/').last
                          : (file is html.File ? file.name : 'Unknown'),
                    ),
                    onDeleted: () {
                      setState(() {
                        _newVideos.remove(file);
                        widget.refreshPropertiesNotifier.value++;
                      });
                    },
                    deleteIcon: Icon(Icons.close),
                  );
                }).toList(),
              ),
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
                        _occupancyRateController.text.isEmpty )
                    {
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
                        final property = TouristicPropertyApi(
                          id: widget.property.id!,
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
                          images: _newImages,
                          videos: _newVideos,
                        );

                        response = await updateTouristicPropertyWeb(
                          property.id!,
                          property,
                        );
                      } else {
                        // Mobile-specific logic
                        final property = TouristicPropertyApi(
                          id: widget.property.id!,
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
                          images: _newImages,
                          videos: _newVideos,
                        );
                        response = await updateTouristicPropertyMobile(
                          property.id!,
                          property,
                        );
                      }

                      if (response.statusCode == 200) {
                        isSuccess = true;
                        message = 'Update successful!';

                        _newImages.clear();
                        _newVideos.clear();
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
