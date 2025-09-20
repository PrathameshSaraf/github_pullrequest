import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/PrModel.dart';

class GitHubService {
  // GitHub API base URL
  static const String _baseUrl = 'https://api.github.com';

  // Repository owner and name - Using Flutter's official repository (public)
  static const String _owner = 'flutter';
  static const String _repo = 'flutter';

  GitHubService();

  Future<List<PullRequest>> fetchPullRequests({
    String state = 'open', // 'open', 'closed', or 'all'
    int page = 1,
    int perPage = 30,
  }) async {
    try {
      // Correct GitHub API URL format
      final url = Uri.parse(
          '$_baseUrl/repos/$_owner/$_repo/pulls'
      ).replace(queryParameters: {
        'state': state,
        'page': page.toString(),
        'per_page': perPage.toString(),
      });

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'Flutter-App', // GitHub requires a User-Agent header
          // No authentication needed for public repositories
        },
      );
      print("Response is ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => PullRequest.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        throw Exception("Repository not found or private");
      } else if (response.statusCode == 403) {
        throw Exception("API rate limit exceeded or access forbidden");
      } else {
        throw Exception("Failed to fetch PRs: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      if (e is Exception) {
        print("Error is $e");
        rethrow;
      }
      throw Exception("Network error: $e");
    }
  }

  // Additional method to fetch a specific PR
  Future<PullRequest> fetchPullRequest(int prNumber) async {
    try {
      final url = Uri.parse('$_baseUrl/repos/$_owner/$_repo/pulls/$prNumber');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'Flutter-App',
        },
      );

      print("Response is ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return PullRequest.fromJson(data);
      } else {
        throw Exception("Failed to fetch PR #$prNumber: ${response.statusCode}");
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception("Network error: $e");
    }
  }

  // Method to fetch PRs with different filters
  Future<List<PullRequest>> fetchPullRequestsWithFilters({
    String state = 'open',
    String sort = 'created', // 'created', 'updated', 'popularity', 'long-running'
    String direction = 'desc', // 'asc' or 'desc'
    String? head, // Filter by head branch
    String? base, // Filter by base branch
  }) async {
    try {
      final queryParams = <String, String>{
        'state': state,
        'sort': sort,
        'direction': direction,
      };

      if (head != null) queryParams['head'] = head;
      if (base != null) queryParams['base'] = base;

      final url = Uri.parse('$_baseUrl/repos/$_owner/$_repo/pulls')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'Flutter-App',
          // No authentication needed for public repositories
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => PullRequest.fromJson(e)).toList();
      } else if (response.statusCode == 403) {
        throw Exception("API rate limit exceeded - consider adding authentication for higher limits");
      } else if (response.statusCode == 404) {
        throw Exception("Repository not found");
      } else {
        throw Exception("Failed to fetch PRs: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception("Network error: $e");
    }
  }
}