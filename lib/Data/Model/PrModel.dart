class PullRequest {
  final int id;
  final String title;
  final String? body;
  final String author;
  final DateTime createdAt;

  PullRequest({
    required this.id,
    required this.title,
    this.body,
    required this.author,
    required this.createdAt,
  });

  factory PullRequest.fromJson(Map<String, dynamic> json) {
    return PullRequest(
      id: json['id'] as int,
      title: json['title'] ?? '',
      body: json['body'],
      author: json['user']?['login'] ?? 'Unknown',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
