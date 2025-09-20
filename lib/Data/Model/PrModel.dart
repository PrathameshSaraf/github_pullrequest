class PullRequest {
  final int id;
  final int number; // PR number (different from id)
  final String title;
  final String? body;
  final String author;
  final DateTime createdAt;
  final String state; // 'open', 'closed'
  final bool merged; // whether PR was merged
  final String? mergedAt; // when it was merged (if merged)

  PullRequest({
    required this.id,
    required this.number,
    required this.title,
    this.body,
    required this.author,
    required this.createdAt,
    required this.state,
    this.merged = false,
    this.mergedAt,
  });

  factory PullRequest.fromJson(Map<String, dynamic> json) {
    return PullRequest(
      id: json['id'] as int,
      number: json['number'] as int, // GitHub PR number
      title: json['title'] ?? '',
      body: json['body'],
      author: json['user']?['login'] ?? 'Unknown',
      createdAt: DateTime.parse(json['created_at']),
      state: json['state'] ?? 'open', // GitHub API provides 'open' or 'closed'
      merged: json['merged_at'] != null, // if merged_at exists, it's merged
      mergedAt: json['merged_at'], // timestamp when merged
    );
  }

  // Helper method to get display state
  String get displayState {
    if (merged) return 'merged';
    return state; // 'open' or 'closed'
  }
}