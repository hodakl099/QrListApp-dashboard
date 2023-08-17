import 'dart:convert';
import 'package:admin/models/residential_model/ResidentialProperty.dart';
import 'package:admin/models/touristic_model/TouristicProperty.dart';
import 'package:http/http.dart' as http;



Future<List<TouristicPropertyApi>> fetchAllTouristic() async {
  final response = await http.get(Uri.parse('http://localhost:8080/properties/touristic/properties'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((property) => TouristicPropertyApi.fromJson(property)).toList();
  } else {
    throw Exception('Failed to load properties');
  }
}