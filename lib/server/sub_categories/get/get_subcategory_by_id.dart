import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/category_model/Category.dart';



Future<CategoryApi> fetchCategoryById(String id) async {
  final response = await http.get(Uri.parse('http://localhost:8080/QrList/subcategory/getSubCategory/$id'));


  if (response.statusCode == 200) {
    return CategoryApi.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load property');
  }
}
