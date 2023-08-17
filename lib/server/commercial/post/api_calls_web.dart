import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../models/commercial_model/CommercialProperty.dart';


Future<http.StreamedResponse> uploadCommercialPropertyWeb(CommercialPropertyApi property) async {
  var uri = Uri.parse("http://localhost:8080/properties/commercial/Add");
  var request = http.MultipartRequest("POST", uri)
    ..fields['propertyType'] = property.propertyType
    ..fields['agentContact'] = property.agentContact
    ..fields['price'] = property.price.toString()
    ..fields['acres'] = property.acres.toString()
    ..fields['trafficCount'] = property.trafficCount
    ..fields['zoningInfo'] = property.zoningInfo
    ..fields['amenities'] = property.amenities
    ..fields['location'] = property.location;

  for (var imageFile in property.images) {
    if (imageFile is! html.File) continue;

    final reader = html.FileReader();
    reader.readAsArrayBuffer(imageFile);
    await reader.onLoad.first;

    final bytes = (reader.result as List<Object?>).cast<int>();
    final stream = Stream<List<int>>.fromIterable([bytes]);
    final length = imageFile.size;
    final fileName = imageFile.name;

    request.files.add(http.MultipartFile(
      'image',
      stream,
      length,
      filename: fileName,
      contentType: MediaType('image', 'jpeg'),
    ));
  }

  for (var videoFile in property.videos) {
    if (videoFile is! html.File) continue;

    final reader = html.FileReader();
    reader.readAsArrayBuffer(videoFile);
    await reader.onLoad.first;

    final bytes = (reader.result as List<Object?>).cast<int>();
    final stream = Stream<List<int>>.fromIterable([bytes]);
    final length = videoFile.size;
    final fileName = videoFile.name;

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
