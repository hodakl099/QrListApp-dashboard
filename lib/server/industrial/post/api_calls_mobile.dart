import 'dart:io';
import 'package:admin/models/industrial_model/CommercialProperty.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';




Future<http.StreamedResponse> uploadIndustrialPropertyMobile(IndustrialPropertyApi property) async {
  var uri = Uri.parse("http://localhost:8080/properties/industrial/Add");
  var request = http.MultipartRequest("POST", uri)
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
