import 'dart:html';
import 'package:admin/models/commercial_model/CommercialProperty.dart';
import 'package:admin/server/commercial/put/update_calls_mobile.dart';
import 'package:admin/server/commercial/put/update_calls_web.dart';
import 'package:admin/server/industrial/put/update_calls_mobile.dart';
import 'package:admin/server/industrial/put/update_calls_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../models/industrial_model/CommercialProperty.dart';
import '../../../util/file_uploader.dart';
import '../../../util/file_uploader_mobile.dart';
import '../../../util/file_uploader_web.dart';
import 'dart:io' as io;
import 'dart:html' as html;

class EditIndustrialForm extends StatefulWidget {
  final IndustrialPropertyApi property;
  final ValueNotifier<int> refreshPropertiesNotifier;

  EditIndustrialForm({
    required this.property,
    required this.refreshPropertiesNotifier,
  });

  @override
  _EditIndustrialFormState createState() => _EditIndustrialFormState();
}

class _EditIndustrialFormState extends State<EditIndustrialForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _agentContactController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _acresController = TextEditingController();
  TextEditingController _zoningInfoController = TextEditingController();
  TextEditingController _cellingHeightController = TextEditingController();
  TextEditingController _numberOfLoadingDocksController = TextEditingController();
  TextEditingController _powerCapabilitiesController = TextEditingController();
  TextEditingController _accessToTransportationController = TextEditingController();
  TextEditingController _environmentalReportsController = TextEditingController();

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
    _zoningInfoController.text = widget.property.zoningInfo;
    _cellingHeightController.text = widget.property.cellingHeight.toString();
    _numberOfLoadingDocksController.text = widget.property.numberOfLoadingDocks.toString();
    _powerCapabilitiesController.text = widget.property.powerCapabilities;
    _accessToTransportationController.text = widget.property.accessToTransportation;
    _environmentalReportsController.text = widget.property.environmentalReports;
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
                initialValue: 'Industrial',
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
                controller: _cellingHeightController,
                decoration: InputDecoration(labelText: "Celling Height"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Celling Height';
                  }
                  if (value.length > 256) {
                    return 'Celling Height size must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _zoningInfoController,
                decoration: InputDecoration(labelText: "Zoning information"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Zoning Information.';
                  }
                  if (value.length > 256) {
                    return 'Zoning information must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _numberOfLoadingDocksController,
                decoration: InputDecoration(labelText: "Loading docks"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Number of Loading docks.';
                  }
                  if (value.length > 256) {
                    return 'Loading Docks description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _powerCapabilitiesController,
                decoration: InputDecoration(labelText: "Power Capabilities"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Power Capabilities description.';
                  }
                  if (value.length > 256) {
                    return 'Power Capabilities description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _accessToTransportationController,
                decoration: InputDecoration(labelText: "Transportation"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Access to Transportation description.';
                  }
                  if (value.length > 256) {
                    return 'Power Capabilities description must be less than 256 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: _environmentalReportsController,
                decoration: InputDecoration(labelText: "Environmental Reports."),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Environmental Reports description.';
                  }
                  if (value.length > 256) {
                    return 'Environmental Reports description must be less than 256 characters';
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

                    if (_agentContactController.text.isEmpty ||
                        _priceController.text.isEmpty ||
                        _locationController.text.isEmpty ||
                        _acresController.text.isEmpty ||
                        _zoningInfoController.text.isEmpty ||
                        _cellingHeightController.text.isEmpty ||
                        _numberOfLoadingDocksController.text.isEmpty ||
                        _powerCapabilitiesController.text.isEmpty ||
                        _accessToTransportationController.text.isEmpty ||
                        _environmentalReportsController.text.isEmpty
                    ){
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
                        final property = IndustrialPropertyApi(
                          id: widget.property.id!,
                          propertyType: 'Industrial',
                          location: _locationController.text,
                          agentContact: _agentContactController.text,
                          price: int.tryParse(_priceController.text) ?? 0,
                          acres: int.tryParse(_acresController.text) ?? 0,
                          zoningInfo: _zoningInfoController.text,
                          cellingHeight:int.tryParse(_cellingHeightController.text) ?? 0,
                          images: _newImages,
                          videos: _newVideos,
                          numberOfLoadingDocks: int.tryParse(_numberOfLoadingDocksController.text) ?? 0,
                          powerCapabilities: _powerCapabilitiesController.text,
                          accessToTransportation: _accessToTransportationController.text,
                          environmentalReports: _environmentalReportsController.text,
                        );

                        response = await updateIndustrialPropertyWeb(
                          property.id!,
                          property,
                        );
                      } else {
                        // Mobile-specific logic
                        final property = IndustrialPropertyApi(
                          id: widget.property.id!,
                          propertyType: 'Industrial',
                          location: _locationController.text,
                          agentContact: _agentContactController.text,
                          price: int.tryParse(_priceController.text) ?? 0,
                          acres: int.tryParse(_acresController.text) ?? 0,
                          zoningInfo: _zoningInfoController.text,
                          cellingHeight:int.tryParse(_cellingHeightController.text) ?? 0,
                          images: _newImages,
                          videos: _newVideos,
                          numberOfLoadingDocks: int.tryParse(_numberOfLoadingDocksController.text) ?? 0,
                          powerCapabilities: _powerCapabilitiesController.text,
                          accessToTransportation: _accessToTransportationController.text,
                          environmentalReports: _environmentalReportsController.text,
                        );
                        response = await updateIndustrialPropertyMobile(
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
