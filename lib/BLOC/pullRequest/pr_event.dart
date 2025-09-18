
import 'package:equatable/equatable.dart';

abstract class PullRequestEvent extends Equatable {
  const PullRequestEvent();

  @override
  List<Object?> get props => [];
}

class FetchPullRequests extends PullRequestEvent {}

class RefreshPullRequests extends PullRequestEvent {}
