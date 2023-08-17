import 'dart:io';
import 'package:admin/models/office_model/CommercialProperty.dart';
import 'package:admin/models/residential_model/ResidentialProperty.dart';
import 'package:admin/models/touristic_model/TouristicProperty.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<http.StreamedResponse> updateTouristicPropertyMobile(String id, TouristicPropertyApi property) async {
  var uri = Uri.parse("http://localhost:8080/properties/touristic/updateProperty/$id");
  var request = http.MultipartRequest("PUT", uri)
    ..fields['agentContact'] = property.agentContact
    ..fields['propertyType'] = property.propertyType
    ..fields['price'] = property.price.toString()
    ..fields['location'] = property.location
    ..fields['acres'] = property.acres.toString()
    ..fields['rooms'] = property.rooms.toString()
    ..fields['units'] = property.units.toString()
    ..fields['amenities'] = property.amenities
    ..fields['proximityToAttractions'] = property.proximityToAttractions
    ..fields['occupancyRate'] = property.occupancyRate;


  for (var imageFile in property.images) {
    if (imageFile is! File) continue;

    final stream = imageFile.openRead();
    final length = await imageFile.length();
    final fileName = imageFile.path.split('/').last;

    request.files.add(http.MultipartFile(
      'image',
      stream,
      length,
      filename: fileName,
      contentType: MediaType('image', 'jpeg'),
    ));
  }

  for (var videoFile in property.videos) {
    if (videoFile is! File) continue;

    final stream = videoFile.openRead();
    final length = await videoFile.length();
    final fileName = videoFile.path.split('/').last;

    request.files.add(http.MultipartFile(
      'video',
      stream,
      length,
      filename: fileName,
      contentType: MediaType('video', 'mp4'),
    ));
  }

  var response = await request.send();

  return response;
}
