import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/PrModel.dart';

class GitHubService {
  final String owner;
  final String repo;

  GitHubService({required this.owner, required this.repo});

  Future<List<PullRequest>> fetchPullRequests() async {
    final url = Uri.parse("https://api.github.com/repos/$owner/$repo/pulls");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => PullRequest.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch PRs: ${response.statusCode}");
    }
  }
}
