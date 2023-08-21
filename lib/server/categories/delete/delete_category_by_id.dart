import 'package:http/http.dart' as http;

Future<bool> deleteCategoryById(String id) async {
  var url = 'http://localhost:8080/QrList/category/deleteCategory/$id';

  try {
    var response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Property deleted successfully.');
      return true;
    } else {
      print('Failed to delete property. Response code: ${response.body}');
      return false;
    }
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}
