import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;
import 'package:html2md/html2md.dart' as html2md;
import 'dart:io';

void main(List<String> arguments) async {
  const String imagePageUrl = 'https://wiki.eclipse.org/';
  const String imageRepository = 'eclipse/gef-classic';
// https://raw.githubusercontent.com/vogellacompany/eclipse.platform/faq/docs/

  List<String> wikiPageUrls = [
    'https://wiki.eclipse.org/Equinox/p2/Customizing_Metadata',
    'https://wiki.eclipse.org/Equinox/p2/Concepts',
    'https://wiki.eclipse.org/Equinox/p2/Engine',
    "https://wiki.eclipse.org/Equinox/p2/Query_Language_for_p2",
    "https://wiki.eclipse.org/Installable_Units",
  ];

  String directoryPath = 'docs/';
  clearOutput(directoryPath);

  for (var wikiPageUrl in wikiPageUrls) {
    var filename = extractLastSegmentWithoutExtension(wikiPageUrl);
    await creatMDDoc(wikiPageUrl, imagePageUrl, filename, imageRepository);
  }

  cleanMarkdownFiles(directoryPath);
}

Future<void> creatMDDoc(String wikiPageUrl, String imagePageUrl,
    String filename, String imageRepository) async {
  try {
    final response = await http.get(Uri.parse(wikiPageUrl));

    if (response.statusCode == 200) {
      final htmlDocument = htmlParser.parse(response.body);

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

      String htmlDocumentString = htmlDocument.body?.innerHtml ?? '';
      String preTagsFixed = replacePreTags(htmlDocumentString);
      // Use html2md to convert HTML to markdown
      final String markdownContent = html2md.convert(preTagsFixed);

      // replace the header understore with hythen
      RegExp pattern = RegExp(r'\(#(.*?)\)');

      String headerReplaced =
          markdownContent.replaceAllMapped(pattern, (match) {
        return match.group(0)!.replaceAll(RegExp(r'[_]'), '-');
      });

      String result = convertFileLinks(headerReplaced, imageRepository);

      result = removeTrailingCharacters(result);

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

      result = deleteUpToLine(result, '"Past revisions of this page [h]")');
      if (result.contains('[Categories]')) {
        result = deleteFromLine(result, '[Categories]');
      }
      if (result.contains('[Category]')) {
        result = deleteFromLine(result, '[Category]');
      }
      if (result.contains('Retrieved from "[')) {
        result = deleteFromLine(result, 'Retrieved from "[');
      }
      // Removing the FAQ reference
      if (result.contains('* * *')) {
        result = deleteFromLine(result, '* * *');
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

String replacePreTags(String htmlContent) {
  // Replace opening <pre> with <pre><code>
  RegExp prePattern = RegExp(r'<pre .*?>');
  String updatedHtml = htmlContent.replaceAll(prePattern, '<pre><code>');

  // Replace closing </pre> with </code></pre>
  updatedHtml = updatedHtml.replaceAll('</pre>', '</code></pre>');

  return updatedHtml;
}

String convertFileLinks(String input, String imageRepository) {
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
          'https://raw.githubusercontent.com/$imageRepository/master/docs/images/$fileName.$originalExtension';

      return '![$altText]($imageUrl)';
    },
  );
}

String removeTrailingCharacters(String input) {
  // This regex matches strings that start with /FAQ and end before a space,
  // capturing the content to allow modification.
  RegExp regex = RegExp(r'(/FAQ\S+?)\s', multiLine: true);

  // This function will be used to process each match
  String replaceMatch(Match match) {
    String matchedText = match[1]!; // The captured string

    // Remove trailing underscores and URL encoded question marks
    String cleanedText = matchedText.replaceAll(RegExp(r'[_%3F]+$'), '');

    // Prepend '.' to '/FAQ' making it './FAQ' and append '.md'
    return '.${cleanedText}.md ';
  }

  // Replace all occurrences in the input string
  String result = input.replaceAllMapped(regex, replaceMatch);

  return result;
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
  // print(input.length);

  // Find the index of the line that starts with the specified text
  int endIndex = input.indexOf(lineStart);
  // If the line is not found, throw an exception
  if (endIndex == -1) {
    throw Exception('Line starting with "$lineStart" not found.');
  }

  // print(endIndex);
  // Return the substring starting from the index after the line
  return input.substring(0, endIndex);
}

String extractLastSegmentWithoutExtension(String url) {
  var uri = Uri.parse(url);
  var segments = uri.pathSegments;

  if (segments.isNotEmpty) {
    var lastSegment = segments.last;

    // Check and remove a trailing question mark before the file extension
    if (lastSegment.endsWith('?')) {
      lastSegment = lastSegment.substring(0, lastSegment.length - 1);
    }

    // Check and remove a trailing question mark before the file extension
    if (lastSegment.endsWith('_')) {
      lastSegment = lastSegment.substring(0, lastSegment.length - 1);
    }

    // Remove file extension if exists
    var indexOfDot = lastSegment.lastIndexOf('.');
    if (indexOfDot != -1) {
      return lastSegment.substring(0, indexOfDot);
    }

    return lastSegment;
  }

  return ''; // Return an empty string if the URL does not have path segments
}

void clearOutput(String directoryPath) {
  // Delete the content of the "output" folder
  clearOutputFolder(directoryPath);
}

Future<void> cleanMarkdownFiles(String directoryPath) async {
  final directory = Directory(directoryPath);

  // Check if the directory exists
  if (!await directory.exists()) {
    print('Directory does not exist');
    return;
  }

  // List all .md files
  await for (FileSystemEntity entity
      in directory.list(recursive: false, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.md')) {
      // Read the file
      String content = await entity.readAsString();

      // Replace or remove the specified characters
      String modifiedContent = content
          .replaceAll('&#147;', '')
          .replaceAll('&#148;', '')
          .replaceAll('&#153;', '')
          .replaceAll('&#146;', "'")
          .replaceAll('&#151;', "-")
          .replaceAll('http://www.eclipse.org/', "https://www.eclipse.org/")
          .replaceAll('http://help.eclipse.org/', "https://help.eclipse.org/");

      // Write the changes back to the file
      await entity.writeAsString(modifiedContent);
      print('Processed ${entity.path}');
    }
  }
}

// &#147; -> Remove
// &#148; -> Remove
// &#146; -> Replace with '
// manual check, search for \[
