import 'dart:io';
import 'dart:async';

Future<List<String>> extractFAQLinks(String filePath) async {
  // Define the list to hold the matches
  List<String> faqLinks = [];

  // Define a regular expression to match the desired pattern
  // This regex looks for strings that start with /FAQ and end before a space
  RegExp exp = RegExp(r'/Menu_Contributions[^ ]*');

  try {
    // Read the file line by line
    await File(filePath).readAsLines().then((lines) {
      for (var line in lines) {
        // Find all matches in the current line
        var matches = exp.allMatches(line);
        for (var match in matches) {
          // Add the matched string to the list
          faqLinks.add(match.group(0)!);
        }
      }
    });
  } catch (e) {
    print('An error occurred while reading the file: $e');
  }

  return faqLinks;
}

void printAsDartList(List<String> items) {
  // Manually building the string representation of a Dart list
  String listRepresentation = '';
  for (int i = 0; i < items.length; i++) {
    // Append the item with quotes
    listRepresentation += '\'https://wiki.eclipse.org/${items[i]}\'' + (', \n');
  }
  listRepresentation += '';

  // Print the manually formatted string
  print(listRepresentation);
}

void main() async {
  String filePath = './input/Menu_Contributions.md';
  List<String> faqLinks = await extractFAQLinks(filePath);
  printAsDartList(faqLinks);
}
