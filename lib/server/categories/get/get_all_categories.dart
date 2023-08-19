import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/category_model/Category.dart';



Future<List<CategoryApi>> fetchAllCategories() async {
  final response = await http.get(Uri.parse('http://localhost:8080/QrList/category/getAllCategories'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((property) => CategoryApi.fromJson(property)).toList();
  } else {
    throw Exception('Failed to load properties');
  }
}