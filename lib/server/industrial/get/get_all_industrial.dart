import 'dart:convert';
import 'package:admin/models/industrial_model/CommercialProperty.dart';
import 'package:http/http.dart' as http;



Future<List<IndustrialPropertyApi>> fetchIndustrials() async {
  final response = await http.get(Uri.parse('http://localhost:8080/properties/industrial/properties'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((property) => IndustrialPropertyApi.fromJson(property)).toList();
  } else {
    throw Exception('Failed to load properties');
  }
}