import 'dart:convert';
import 'package:admin/models/office_model/CommercialProperty.dart';
import 'package:admin/models/residential_model/ResidentialProperty.dart';
import 'package:http/http.dart' as http;



Future<List<ResidentialPropertyApi>> fetchAllResidential() async {
  final response = await http.get(Uri.parse('http://localhost:8080/properties/residential/properties'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((property) => ResidentialPropertyApi.fromJson(property)).toList();
  } else {
    throw Exception('Failed to load properties');
  }
}