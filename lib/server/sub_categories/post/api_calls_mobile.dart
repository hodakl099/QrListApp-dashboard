import 'dart:io';
import 'package:admin/models/sub_category/SubCategoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


Future<http.StreamedResponse> uploadSubCategoryMobile(SubCategory subCategory,String categoryId) async {
  var uri = Uri.parse("http://localhost:8080/QrList/subcategory/AddSubCategory/{$categoryId}");
  var request = http.MultipartRequest("POST", uri)
    ..fields['name'] = subCategory.name
    ..fields['price'] = subCategory.price
    ..fields['objectName'] = subCategory.objectName!;

  if (subCategory.image != null) {
    var imageFile = subCategory.image;

    if (imageFile is File) {
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
  }

  var response = await request.send();

  return response;
}

