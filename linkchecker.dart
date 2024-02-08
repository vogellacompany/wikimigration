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
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Dropdown_Command.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Problems_View_Example.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Populating_a_dynamic_submenu.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Toggle_Mark_Occurrences.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Toggle_Button_Command.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Radio_Button_Command.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Update_checked_state.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Search_Menu.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/IFile_objectContribution.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/TextEditor_viewerContribution.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Widget_in_a_toolbar.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/RCP_removes_the_Project_menu.md',
    'https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Menu_Contributions/Workbench_wizard_contribution.md',
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Accessibility_Features.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Command_Core_Expressions.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Common_Navigator_Framework.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Eclipse4_RCP_Dependency_Injection.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Eclipse4_RCP_Contexts.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Eclipse4_RCP_EAS_List_of_All_Provided_Services.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Event_Model.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Event_Processing.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Eclipse4_RCP_FAQ.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/EclipsePluginDevelopmentFAQ.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Eclipse_Corner.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/JFace.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/JFaceDataBinding.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/JFaceSnippets.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/PlatformCommandFramework.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Platform_Expression_Framework.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Rich_Client_Platform.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Rich_Client_Platform/Rich_Client_Platform_FAQ.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Rich_Client_Platform/Rich_Client_Platform_How_to.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/Rich_Client_Platform/Rich_Client_Platform_Book.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform.ui/master/docs/CSS.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Evolving-Java-based-APIs.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/API_Central.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Coding_Conventions.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Eclipse_Doc_Style_Guide.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Javadoc.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/VersionNumbering.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Evolving-Java-based-APIs-2.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Evolving-Java-based-APIs-3.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/ApiRemovalProcess.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Eclipse_API_Central_Deprecation_Policy.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Progress_Reporting.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Status_Handling_Best_Practices.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Export-Package.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Provisional_API_Guidelines.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Naming_Conventions.md",
//    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Eclipse_Project_Update_Sites.md",
    "https://raw.githubusercontent.com/eclipse-platform/eclipse.platform/master/docs/Internationalization.md",
    "https://raw.githubusercontent.com/eclipse-pde/eclipse.pde/master/docs/API_Tools.md",
    "https://raw.githubusercontent.com/eclipse-equinox/equinox/master/docs/Adaptor_Hooks.md",
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
  List<String> failedLinks = [];
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // links
      var links = extractLinks(response.body);
      var linksInternal = extractMarkdownLinks(response.body);
      links.addAll(linksInternal);

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
    print('Error: $e');
  }
  if (failedLinks.isEmpty) {
    print("${url.padRight(maxUrlLength)} $green\u2714 Success$reset");
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
  RegExp linkPattern = RegExp(r'\]\((.*?\.md)\)', multiLine: true);

  Iterable<Match> matches = linkPattern.allMatches(text);
  List<String> links = matches.map((match) => match.group(1)!).toList();

  return links;
}

void printSuccess() {
  // Unicode character for a heavy check mark
  print('\u2714 Success');
}

void printFailure() {
  // Unicode character for a heavy ballot x
  print('\u2718 Failure');
}
