import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../models/agricultural_model/AgriculturalProperty.dart';

Future<http.StreamedResponse> updateAgriculturalPropertyMobile(String id, AgriculturalPropertyApi property) async {
  var uri = Uri.parse("http://localhost:8080/properties/agricultural/updateProperty/$id");
  var request = http.MultipartRequest("PUT", uri)
    ..fields['propertyType'] = property.propertyType
    ..fields['agentContact'] = property.agentContact
    ..fields['price'] = property.price.toString()
    ..fields['acres'] = property.acres.toString()
    ..fields['location'] = property.location
    ..fields['buildings'] = property.buildings
    ..fields['crops'] = property.crops
    ..fields['waterSources'] = property.waterSources
    ..fields['soilType'] = property.soilType
    ..fields['equipment'] = property.equipment;

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
