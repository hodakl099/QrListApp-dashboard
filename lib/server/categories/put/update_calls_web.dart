import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../models/category_model/Category.dart';

Future<http.StreamedResponse> updateCategoryWeb(String id, CategoryApi category) async {
  var uri = Uri.parse("http://localhost:8080/QrList/category/updateCategory/$id");
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
  print('Response status: ${response.statusCode}');
  if (response.statusCode == 200) {
    print('Response successful');
  } else {
    var responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
  }
  return response;
}
