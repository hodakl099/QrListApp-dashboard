import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../models/agricultural_model/AgriculturalProperty.dart';



Future<CategoryApi> fetchAgriculturalById(String id) async {
  final response = await http.get(Uri.parse('http://localhost:8080/properties/agricultural/property/$id'));


  if (response.statusCode == 200) {
    return CategoryApi.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load property');
  }
}
