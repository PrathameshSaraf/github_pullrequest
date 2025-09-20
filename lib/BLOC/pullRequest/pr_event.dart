import 'package:equatable/equatable.dart';

abstract class PullRequestEvent extends Equatable {
  const PullRequestEvent();

  @override
  List<Object?> get props => [];
}

class FetchPullRequests extends PullRequestEvent {
  final String state;
  final String sort;
  final String direction;
  final String? head;
  final String? base;

  const FetchPullRequests({
    this.state = 'open',
    this.sort = 'created',
    this.direction = 'desc',
    this.head,
    this.base,
  });

  @override
  List<Object?> get props => [state, sort, direction, head, base];
}

class RefreshPullRequests extends PullRequestEvent {
  final String state;
  final String sort;
  final String direction;
  final String? head;
  final String? base;

  const RefreshPullRequests({
    this.state = 'open',
    this.sort = 'created',
    this.direction = 'desc',
    this.head,
    this.base,
  });

  @override
  List<Object?> get props => [state, sort, direction, head, base];
}

class ApplyFilters extends PullRequestEvent {
  final String state;
  final String sort;
  final String direction;
  final String? head;
  final String? base;

  const ApplyFilters({
    required this.state,
    required this.sort,
    required this.direction,
    this.head,
    this.base,
  });

  @override
  List<Object?> get props => [state, sort, direction, head, base];
}