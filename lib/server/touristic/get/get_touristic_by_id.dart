import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/touristic_model/TouristicProperty.dart';



Future<TouristicPropertyApi> fetchTouristicById(String id) async {
  final response = await http.get(Uri.parse('http://localhost:8080/properties/touristic/property/$id'));


  if (response.statusCode == 200) {
    return TouristicPropertyApi.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load property');
  }
}
