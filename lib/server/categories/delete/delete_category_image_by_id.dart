import 'package:http/http.dart' as http;

Future<bool> deleteCateogryImageById(String propertyId, String imageId) async {
  var url = 'http://localhost:8080/properties/agricultural/removeImage/$propertyId/$imageId';

  try {
    var response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Image deleted successfully.');
      return true;
    } else {
      print('Failed to delete Image. Response code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}
