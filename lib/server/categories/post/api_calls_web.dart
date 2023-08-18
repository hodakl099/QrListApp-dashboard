import 'dart:convert';
import 'dart:html' as html;
import 'package:admin/models/agricultural_model/AgriculturalProperty.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


Future<http.StreamedResponse> uploadCategoryPropertyWeb(CategoryApi category) async {
  var uri = Uri.parse("http://localhost:8080/properties/agricultural/Add");
  var request = http.MultipartRequest("POST", uri)
    ..fields['name'] = category.name;

  var imageFile = category.image;

  if (imageFile is html.File) {
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

  var response = await request.send();

  return response;
}
