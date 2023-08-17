import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/commercial_model/CommercialProperty.dart';
import '../../../models/industrial_model/CommercialProperty.dart';



Future<IndustrialPropertyApi> fetchIndustrialById(String id) async {
  final response = await http.get(Uri.parse('http://localhost:8080/properties/industrial/property/$id'));


  if (response.statusCode == 200) {
    return IndustrialPropertyApi.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load property');
  }
}
