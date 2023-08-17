import 'dart:convert';
import 'package:admin/models/commercial_model/CommercialProperty.dart';
import 'package:http/http.dart' as http;



Future<List<CommercialPropertyApi>> fetchCommercials() async {
  final response = await http.get(Uri.parse('http://localhost:8080/properties/commercial/properties'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((property) => CommercialPropertyApi.fromJson(property)).toList();
  } else {
    throw Exception('Failed to load properties');
  }
}