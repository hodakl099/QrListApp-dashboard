import 'package:http/http.dart' as http;

Future<bool> deleteOfficeVideoById(String propertyId, String videoId) async {
  var url = 'http://localhost:8080/properties/office/removeVideo/$propertyId/$videoId';

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
