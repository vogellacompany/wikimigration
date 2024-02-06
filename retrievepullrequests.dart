import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  const String user = 'vogella';
  const String repo = 'eclipse-platform/eclipse.platform.ui';
  const String apiUrl = 'https://api.github.com/repos/$repo/pulls?state=closed';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    List<dynamic> pullRequests = json.decode(response.body);
    var closedPullRequestsByUser = pullRequests
        .where((pr) => pr['user']['login'].toLowerCase() == user.toLowerCase());

    if (closedPullRequestsByUser.isNotEmpty) {
      print('Closed pull requests by $user in $repo:');
      for (var pr in closedPullRequestsByUser) {
        // Extracting the pull request URL
        String prUrl = pr['html_url'];
        print('${pr['title']} (#${pr['number']}) - $prUrl');
      }
    } else {
      print('No closed pull requests found for user $user in $repo.');
    }
  } else {
    print('Failed to load pull requests. Status code: ${response.statusCode}');
  }
}
