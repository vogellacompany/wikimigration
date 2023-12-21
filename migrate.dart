import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;
import 'package:html2md/html2md.dart' as html2md;
import 'dart:io';

void main(List<String> arguments) async {
  var filename = "JFaceSnippets";
  if (arguments.isNotEmpty) {
    filename = arguments[0];
  }
  var wikiPageUrl = 'https://wiki.eclipse.org/${filename}';
  final imagePageUrl = 'https://wiki.eclipse.org';

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

      RegExp imagePattern = RegExp(
          r'\[\!\[(.*?)\]\((/images/.*?/)([^/]+\.(png|gif|jpeg|jpg))\)\]');

      String imagesLinksAdjusted = headerReplaced.replaceAllMapped(
        imagePattern,
        (match) {
          String altText = match.group(1)!; // Alt text inside the first ![...]
          String fileName = match.group(3)!; // Filename with the extension .png

          // Create the modified substring
          String modifiedSubstring = '[![$altText](/images/$fileName)]';

          return modifiedSubstring;
        },
      );
      String folderPath = 'output/';

      // Create a Directory object
      Directory outputDirectory = Directory(folderPath);

      if (!outputDirectory.existsSync()) {
        // Create the folder
        outputDirectory.createSync(recursive: true);
      }

      // Delete the content of the "output" folder
      clearOutputFolder(folderPath);

      Directory imageOutputPath = Directory(folderPath + "/images");

      if (!imageOutputPath.existsSync()) {
        // Create the folder
        imageOutputPath.createSync(recursive: true);
      }

      String result = deleteUpToLine(imagesLinksAdjusted, '* [History]');

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

void download(String URL) {
  HttpClient client = new HttpClient();
  List<int> _downloadData = [];
  var filename = URL.split("/").last;

  var fileSave = new File('./output/images/${filename}');
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

  // Check if the "output" folder exists
  if (outputDirectory.existsSync()) {
    // Get a list of all items (files and subdirectories) in the folder
    List<FileSystemEntity> content = outputDirectory.listSync();

    // Delete each item in the "output" folder
    for (var item in content) {
      item.deleteSync(recursive: true);
    }
  }
}

String deleteUpToLine(String input, String lineStart) {
  // Find the index of the line that starts with the specified text
  int startIndex = input.indexOf(lineStart);

  // If the line is found, delete everything up to and including that line
  if (startIndex != -1) {
    return input.substring(startIndex + lineStart.length);
  }

  // If the line is not found, return the original string
  return input;
}
