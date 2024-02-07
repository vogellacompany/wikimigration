import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;
import 'package:html2md/html2md.dart' as html2md;
import 'dart:io';

void main(List<String> arguments) async {
  const String imagePageUrl = 'https://wiki.eclipse.org/';

  List<String> wikiPageUrls = [
    "https://wiki.eclipse.org/Version_Numbering",
    "https://wiki.eclipse.org/Eclipse_Project_Update_Sites",
    "https://wiki.eclipse.org/Eclipse/API_Central",
  ];

  clearOutput();

  for (var wikiPageUrl in wikiPageUrls) {
    var filename = extractLastSegmentWithoutExtension(wikiPageUrl);
    await creatMDDoc(wikiPageUrl, imagePageUrl, filename);
  }
}

Future<void> creatMDDoc(
    String wikiPageUrl, String imagePageUrl, String filename) async {
  try {
    final response = await http.get(Uri.parse(wikiPageUrl));

    if (response.statusCode == 200) {
      final htmlDocument = htmlParser.parse(response.body);

      convertPreTo2CodeBlocks(htmlDocument.body);
      // extract and load images
      List<htmlDom.Element> images =
          htmlDocument.getElementsByClassName("image");

      for (var element in images) {
        var test = element.getElementsByTagName("img")[0].attributes['src'];
        // download image
        String imageUrl = imagePageUrl + test.toString();

        //  print(imageUrl);
        download(imageUrl);
      }
      // Use html2md to convert HTML to markdown
      final String markdownContent =
          html2md.convert(htmlDocument.body?.innerHtml ?? '');

      // replace the header understore with hythen
      RegExp pattern = RegExp(r'\(#(.*?)\)');

      String headerReplaced =
          markdownContent.replaceAllMapped(pattern, (match) {
        return match.group(0)!.replaceAll(RegExp(r'[_]'), '-');
      });

      // // Fix image link
      String imagesLinksAdjusted = convertFileLinks(headerReplaced);

      String folderPath = 'docs/';

      // Create a Directory object
      Directory outputDirectory = Directory(folderPath);

      if (!outputDirectory.existsSync()) {
        // Create the folder
        outputDirectory.createSync(recursive: true);
      }

      Directory imageOutputPath = Directory(folderPath + "/images");

      if (!imageOutputPath.existsSync()) {
        // Create the folder
        imageOutputPath.createSync(recursive: true);
      }
      String result = "";
      result = deleteUpToLine(
          imagesLinksAdjusted, '"Past revisions of this page [h]")');
      if (result.contains('[Categories]')) {
        result = deleteFromLine(result, '[Categories]');
      }
      if (result.contains('[Category]')) {
        result = deleteFromLine(result, '[Category]');
      }
      if (result.contains('Retrieved from "[')) {
        result = deleteFromLine(result, 'Retrieved from "[');
      }

      // String result = imagesLinksAdjusted;
      var file =
          await File(folderPath + filename + ".md").writeAsString(result);
      // Do something with the file.
      // The variable `markdownContent` now contains the markdown
      // representation of the Wiki page content
    } else {
      print(
          'Failed to load the Wiki page. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

String convertFileLinks(String input) {
  // Define the regular expression pattern
  RegExp pattern = RegExp(
      r'\[\!\[(.*?)\]\((/images/.+?/)([^/]+)\.(png|jpg|jpeg|gif)\)\]\(/File:(.*?)\.(png|jpg|jpeg|gif)\)');

  // Perform the replacement using replaceAllMapped
  return input.replaceAllMapped(
    pattern,
    (match) {
      String altText = match.group(1)!;
      String imagePath = match.group(2)!;
      String fileName = match.group(3)!;
      String extension = match.group(4)!;
      String originalFileName = match.group(5)!;
      String originalExtension = match.group(6)!;

      // Construct the new image URL
      String imageUrl =
          'https://raw.githubusercontent.com/eclipse-pde/eclipse.pde/master/docs/images/$fileName.$originalExtension';

      return '![$altText]($imageUrl)';
    },
  );
}

void download(String URL) {
  HttpClient client = new HttpClient();
  List<int> _downloadData = [];
  var filename = URL.split("/").last;

  var fileSave = new File('./docs/images/${filename}');
  client.getUrl(Uri.parse(URL)).then((HttpClientRequest request) {
    return request.close();
  }).then((HttpClientResponse response) {
    response.listen((d) => _downloadData.addAll(d), onDone: () {
      fileSave.writeAsBytes(_downloadData);
    });
  });
}

void convertPreToCodeBlocks(htmlDom.Element? element) {
  if (element == null) return;

  // Find all <pre> elements
  final preElements = element.querySelectorAll('pre');

  // Process each <pre> element
  for (final preElement in preElements) {
    // Create a new parent element, e.g., <div>
    final newParentElement = htmlDom.Element.tag('div');

    // Create a new <code> element
    final codeBlock = htmlDom.Element.tag('code')..text = preElement.text;

    // Add the <code> element within the new parent element
    newParentElement.children.add(codeBlock);

    // Replace the original <pre> element with the new structure
    preElement.replaceWith(newParentElement);
    print(preElement);
  }
}

void convertPreTo2CodeBlocks(htmlDom.Element? element) {
  if (element == null) return;

  // Find all <pre> elements
  final preElements = element.querySelectorAll('pre');

  // Process each <pre> element
  for (final preElement in preElements) {
    // Create a new <code> element
    final codeBlock = htmlDom.Element.tag('code')..text = preElement.text;

    // Add the <code> element within the original <pre> element
    preElement.children.add(codeBlock);
    // preElement.replaceWith(codeBlock);
    print(preElement);
  }
}

void clearOutputFolder(String folderPath) {
  // Create a Directory object for the "output" folder
  Directory outputDirectory = Directory(folderPath);

  // Check if the output folder exists
  if (outputDirectory.existsSync()) {
    // Get a list of all items (files and subdirectories) in the folder
    List<FileSystemEntity> content = outputDirectory.listSync();

    // Delete each item in the output folder
    for (var item in content) {
      item.deleteSync(recursive: true);
    }
  }
}

String deleteUpToLine(String input, String lineStart) {
  // Find the index of the line that starts with the specified text
  int startIndex = input.indexOf(lineStart);
  // If the line is not found, throw an exception
  if (startIndex == -1) {
    throw Exception('Line starting with "$lineStart" not found.');
  }

  // Return the substring starting from the index after the line
  return input.substring(startIndex + lineStart.length);
}

String deleteFromLine(String input, String lineStart) {
  print(input.length);

  // Find the index of the line that starts with the specified text
  int endIndex = input.indexOf(lineStart);
  // If the line is not found, throw an exception
  if (endIndex == -1) {
    throw Exception('Line starting with "$lineStart" not found.');
  }

  print(endIndex);
  // Return the substring starting from the index after the line
  return input.substring(0, endIndex);
}

String extractLastSegmentWithoutExtension(String url) {
  var uri = Uri.parse(url);
  var segments = uri.pathSegments;

  if (segments.isNotEmpty) {
    var lastSegment = segments.last;
    // Remove file extension if exists
    var indexOfDot = lastSegment.lastIndexOf('.');
    if (indexOfDot != -1) {
      return lastSegment.substring(0, indexOfDot);
    }
    return lastSegment;
  }

  return ''; // Return an empty string if the URL does not have path segments
}

void clearOutput() {
  String folderPath = 'docs/';
  // Delete the content of the "output" folder
  clearOutputFolder(folderPath);
}
