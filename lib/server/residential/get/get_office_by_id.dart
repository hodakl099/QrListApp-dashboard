import 'dart:convert';
import 'package:admin/models/residential_model/ResidentialProperty.dart';
import 'package:http/http.dart' as http;
import '../../../models/office_model/CommercialProperty.dart';



Future<ResidentialPropertyApi> fetchResidentialById(String id) async {
  final response = await http.get(Uri.parse('http://localhost:8080/properties/residential/property/$id'));


  if (response.statusCode == 200) {
    return ResidentialPropertyApi.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load property');
  }
}
