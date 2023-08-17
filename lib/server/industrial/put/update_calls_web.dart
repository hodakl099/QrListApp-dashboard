import 'dart:html' as html;
import 'package:admin/models/industrial_model/CommercialProperty.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<http.StreamedResponse> updateIndustrialPropertyWeb(String id, IndustrialPropertyApi property) async {
  var uri = Uri.parse("http://localhost:8080/properties/industrial/updateProperty/$id");
  var request = http.MultipartRequest("PUT", uri)
    ..fields['agentContact'] = property.agentContact
    ..fields['price'] = property.price.toString()
    ..fields['location'] = property.location
    ..fields['propertyType'] = property.propertyType
    ..fields['acres'] = property.acres.toString()
    ..fields['zoningInfo'] = property.zoningInfo
    ..fields['cellingHeight'] = property.cellingHeight.toString()
    ..fields['numberOfLoadingDocks'] = property.numberOfLoadingDocks.toString()
    ..fields['powerCapabilities'] = property.powerCapabilities
    ..fields['accessToTransportation'] = property.accessToTransportation
    ..fields['environmentalReports'] = property.environmentalReports;
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
