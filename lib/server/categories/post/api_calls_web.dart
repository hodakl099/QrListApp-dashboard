import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_interop';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../models/category_model/Category.dart';


Future<http.StreamedResponse> uploadCategoryPropertyWeb(CategoryApi category) async {
  var uri = Uri.parse("http://localhost:8080/QrList/category/AddCategory/1");
  var request = http.MultipartRequest("POST", uri)
    ..fields['name'] = category.name;

  if (category.image != null) {
    var imageFile = category.image;
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
