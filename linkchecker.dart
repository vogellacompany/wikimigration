import 'dart:math';

import 'package:http/http.dart' as http;

import 'dart:io';

// ANSI escape code for red text
const red = '\x1B[31m';
// ANSI escape code for green text
const green = '\x1B[32m';
// ANSI escape code to reset color
const reset = '\x1B[0m';

// ANSI escape code for bold
const bold = '\x1B[1m';

// ANSI escape code for blue text
const blue = '\x1B[34m';
// ANSI escape code to reset formatting

void main(List<String> args) {
  List<String> rawUrls = [
    "https://raw.githubusercontent.com/eclipse-equinox/p2/master/docs/Customizing_Metadata",
    "https://raw.githubusercontent.com/eclipse-equinox/p2/master/docs/Concepts",
    "https://raw.githubusercontent.com/eclipse-equinox/p2/master/docs/Engine",
    "https://raw.githubusercontent.com/eclipse-equinox/p2/master/docs/Query_Language_for_p2",
    "https://raw.githubusercontent.com/eclipse-equinox/p2/master/docs/Installable_Units",
  ];

  int maxUrlLength = 10;
  // Determine the maximum length for the first column

  for (var url in rawUrls) {
    maxUrlLength = max(maxUrlLength, url.length);
  }

  for (var url in rawUrls) {
    checkLinks(url, maxUrlLength);
  }
}

Future<void> checkLinks(String url, int maxUrlLength) async {
  String internalLinkStart = extractLeadingUrl(url);

  List<String> failedLinks = [];
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // links
      var links = extractLinks(response.body);
      var linksInternal = extractMarkdownLinks(response.body);

      for (var element in linksInternal) {
        if (element.startsWith("./")) {
          element = element.substring(2, element.length);
        }
        links.add(internalLinkStart + element);
        // print("   " + internalLinkStart + element);
      }
      // links.addAll(linksInternal);

      for (var linkUrl in links) {
        final linkResponse = await http.get(Uri.parse(linkUrl));
        if (linkResponse.statusCode != 200) {
          failedLinks.add("$linkUrl returns " + " ${linkResponse.statusCode}");
        }
      }
    } else {
      print(
          'Error: Unable to fetch the $url webpage. Status code: ${response.statusCode}');
    }
  } catch (e) {
    failedLinks.add('$red Error: $e \u2718 Failure$reset');
    // print('$red Error: $e \u2718 Failure$reset');
  }
  if (failedLinks.isEmpty) {
    // print("${url.padRight(maxUrlLength)} $green\u2714 Success$reset");
  } else {
    print("${url.padRight(maxUrlLength)} $red\u2718 Failure$reset");
  }
  for (var failedLink in failedLinks) {
    print("$red$failedLink \u2718 $reset");
  }
}

List<String> extractLinks(String text) {
  // This regex pattern is designed to match http and https URLs.
  // It's a simplified pattern and may not cover all valid URLs intricacies.
  RegExp linkPattern = RegExp(
      r'(http|https):\/\/[a-zA-Z0-9\-.]+\.[a-zA-Z]{2,}\/?\S*',
      caseSensitive: false);

  // Use the RegExp to find matches in the input text.
  Iterable<RegExpMatch> matches = linkPattern.allMatches(text);

  // Map the matches to their string values.
  List<String> links = matches.map((match) => match.group(0)!).toList();

  // Map the matches to their string values, trimming a trailing ')' if present.
  links = matches.map((match) {
    String url = match.group(0)!;
    // Check if the URL ends with a ')' and trim it if so.
    if (url.endsWith(')')) {
      url = url.substring(0, url.length - 1);
    }

    if (url.endsWith(').') || url.endsWith('),')) {
      url = url.substring(0, url.length - 2);
    }
    return url;
  }).toList();

  return links;
}

List<String> extractMarkdownLinks(String text) {
  RegExp linkPattern = RegExp(r'\]\(((?!http).*?\.md)', multiLine: true);

  Iterable<Match> matches = linkPattern.allMatches(text);
  List<String> links = matches.map((match) => match.group(1)!).toList();

  return links;
}

String extractLeadingUrl(String url) {
  var uri = Uri.parse(url);
  var segments = uri.pathSegments;

  if (segments.isNotEmpty) {
    var lastSegment = segments.last;
    String result = url.substring(0, (url.length - lastSegment.length));

    return result;
  }

  return ''; // Return an empty string if the URL does not have path segments
}

void printSuccess() {
  // Unicode character for a heavy check mark
  print('\u2714 Success');
}

void printFailure() {
  // Unicode character for a heavy ballot x
  print('\u2718 Failure');
}
