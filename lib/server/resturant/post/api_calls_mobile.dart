import 'package:http/http.dart' as http;
import '../../../models/restaurant_model/Restaurant.dart';

Future<http.StreamedResponse> uploadRestaurantMobile(RestaurantApi restaurantApi,int id) async {
  var uri = Uri.parse("http://localhost:8080/QrList/restaurant/add/{$id}");
  var request = http.MultipartRequest("POST", uri)
    ..fields['id'] = restaurantApi.id.toString()
    ..fields['name'] = restaurantApi.name
    ..fields['email'] = restaurantApi.email;


  var response = await request.send();

  return response;
}

