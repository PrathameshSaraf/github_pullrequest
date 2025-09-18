

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

  const PullRequestLoaded(this.pullRequests);

  @override
  List<Object?> get props => [pullRequests];
}

class PullRequestError extends PullRequestState {
  final String message;

  const PullRequestError(this.message);

  @override
  List<Object?> get props => [message];
}
