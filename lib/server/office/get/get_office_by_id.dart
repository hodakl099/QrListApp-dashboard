import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/office_model/CommercialProperty.dart';



Future<OfficePropertyApi> fetchOfficeById(String id) async {
  final response = await http.get(Uri.parse('http://localhost:8080/properties/office/property/$id'));


  if (response.statusCode == 200) {
    return OfficePropertyApi.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load property');
  }
}
