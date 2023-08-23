import 'dart:io';
import 'package:admin/models/sub_category/SubCategoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


Future<http.StreamedResponse> updateSubCategoryMobile(String id, SubCategory subcategory) async {
  var uri = Uri.parse("http://localhost:8080/QrList/subcategory/updateSubCategory/$id");
  var request = http.MultipartRequest("PUT", uri)
    ..fields['name'] = subcategory.name;

  var imageFile = subcategory.image;

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
