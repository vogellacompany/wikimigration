import 'package:http/http.dart' as http;

Future<void> checkHttpsAccess(String url) async {
  try {
    // Make a GET request to the URL
    final response = await http.get(Uri.parse(url));

    // Check if the status code is 200 (OK), indicating the content is accessible
    if (response.statusCode == 200) {
      print('The URL is accessible via HTTPS.');
    } else {
      // If the status code is not 200, the content might not be accessible or there's another issue
      print(
          'The URL might not be accessible via HTTPS. Status code: ${response.statusCode}');
    }
  } on Exception catch (e) {
    // Catch exceptions, like no internet connection, or invalid URL
    print('Failed to access the URL. Exception: $e');
  }
}

void main() {
  String url =
      'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/images/300px-Ui-context-hierarchy.png';
  checkHttpsAccess(url);
}
