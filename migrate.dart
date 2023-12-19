import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;
import 'package:html2md/html2md.dart' as html2md;
import 'dart:io';

Future<void> main() async {
  var wikiPageUrl = 'https://wiki.eclipse.org/Evolving_Java-based_APIs_2';
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

      RegExp imagePattern =
          RegExp(r'\[\!\[(.*?)\]\((/images/.*?/)([^/]+\.png)\)\]');

      String imagesPngLinksAdjusted = headerReplaced.replaceAllMapped(
        imagePattern,
        (match) {
          String altText = match.group(1)!; // Alt text inside the first ![...]
          String fileName = match.group(3)!; // Filename with the extension .png

          // Create the modified substring
          String modifiedSubstring = '[![$altText](/images/$fileName)]';

          return modifiedSubstring;
        },
      );

      // // Fix image link

      imagePattern = RegExp(r'\[\!\[(.*?)\]\((/images/.*?/)([^/]+\.gif)\)\]');

      String imagesGifLinksAdjusted = headerReplaced.replaceAllMapped(
        imagesPngLinksAdjusted,
        (match) {
          String altText = match.group(1)!; // Alt text inside the first ![...]
          String fileName = match.group(3)!;

          // Create the modified substring
          String modifiedSubstring = '[![$altText](/images/$fileName)]';

          return modifiedSubstring;
        },
      );

      final filename = 'file.md';
      var file = await File(filename).writeAsString(imagesGifLinksAdjusted);
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

  var fileSave = new File('./images/${filename}');
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
