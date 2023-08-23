import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../models/sub_category/SubCategoryModel.dart';


Future<http.StreamedResponse> uploadSubCategoryWeb(SubCategory category,String categoryId) async {
  var uri = Uri.parse("http://localhost:8080/QrList/subcategory/AddSubCategory/$categoryId");
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
