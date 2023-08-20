import 'dart:convert';
import 'package:admin/models/sub_category/SubCategoryModel.dart';
import 'package:http/http.dart' as http;
import '../../../models/category_model/Category.dart';



Future<List<SubCategory>> getSubCategoriesById(String categoryId) async {
  final response = await http.get(Uri.parse('http://localhost:8080/QrList/category/getSubCategories/$categoryId'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((subcategory) => SubCategory.fromJson(subcategory)).toList();
  } else {
    throw Exception('Failed to load properties');
  }
}