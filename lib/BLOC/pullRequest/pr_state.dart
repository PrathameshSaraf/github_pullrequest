import 'package:equatable/equatable.dart';

import '../../Data/Model/PrModel.dart';

abstract class PullRequestState extends Equatable {
  const PullRequestState();

  @override
  List<Object?> get props => [];
}

class PullRequestInitial extends PullRequestState {}

class PullRequestLoading extends PullRequestState {}

class PullRequestLoaded extends PullRequestState {
  final List<PullRequest> pullRequests;
  final String currentState;
  final String currentSort;
  final String currentDirection;
  final String? currentHead;
  final String? currentBase;

  const PullRequestLoaded(
      this.pullRequests, {
        this.currentState = 'open',
        this.currentSort = 'created',
        this.currentDirection = 'desc',
        this.currentHead,
        this.currentBase,
      });

  @override
  List<Object?> get props => [
    pullRequests,
    currentState,
    currentSort,
    currentDirection,
    currentHead,
    currentBase,
  ];

  PullRequestLoaded copyWith({
    List<PullRequest>? pullRequests,
    String? currentState,
    String? currentSort,
    String? currentDirection,
    String? currentHead,
    String? currentBase,
  }) {
    return PullRequestLoaded(
      pullRequests ?? this.pullRequests,
      currentState: currentState ?? this.currentState,
      currentSort: currentSort ?? this.currentSort,
      currentDirection: currentDirection ?? this.currentDirection,
      currentHead: currentHead ?? this.currentHead,
      currentBase: currentBase ?? this.currentBase,
    );
  }
}

class PullRequestError extends PullRequestState {
  final String message;

  const PullRequestError(this.message);

  @override
  List<Object> get props => [message];
}