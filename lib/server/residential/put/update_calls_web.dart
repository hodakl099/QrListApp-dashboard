import 'dart:html' as html;
import 'package:admin/models/office_model/CommercialProperty.dart';
import 'package:admin/models/residential_model/ResidentialProperty.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<http.StreamedResponse> updateResidentialPropertyWeb(String id, ResidentialPropertyApi property) async {
  var uri = Uri.parse("http://localhost:8080/properties/residential/updateProperty/$id");
  var request = http.MultipartRequest("PUT", uri)
    ..fields['agentContact'] = property.agentContact
    ..fields['propertyType'] = property.propertyType
    ..fields['price'] = property.price.toString()
    ..fields['location'] = property.location
    ..fields['acres'] = property.acres.toString()
    ..fields['bedrooms'] = property.bedrooms.toString()
    ..fields['bathrooms'] = property.bathrooms.toString()
    ..fields['amenities'] = property.amenities
    ..fields['parking'] = property.parking;
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
  print('Response status: ${response.statusCode}');
  if (response.statusCode == 200) {
    print('Response successful');
  } else {
    var responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
  }
  return response;
}
