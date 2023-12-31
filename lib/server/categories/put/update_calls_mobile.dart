import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../models/category_model/Category.dart';

Future<http.StreamedResponse> updateCategoryMobile(String id, CategoryApi category) async {
  var uri = Uri.parse("http://localhost:8080/QrList/category/updateCategory/$id");
  var request = http.MultipartRequest("PUT", uri)
    ..fields['name'] = category.name
    ..fields['objectName'] = category.objectName;

  var imageFile = category.image;

    if (imageFile is! File) {

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
  var response = await request.send();

  return response;
}
