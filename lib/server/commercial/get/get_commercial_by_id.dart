import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../models/commercial_model/CommercialProperty.dart';



Future<CommercialPropertyApi> fetchCommercialById(String id) async {
  final response = await http.get(Uri.parse('http://localhost:8080/properties/commercial/property/$id'));


  if (response.statusCode == 200) {
    return CommercialPropertyApi.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load property');
  }
}
