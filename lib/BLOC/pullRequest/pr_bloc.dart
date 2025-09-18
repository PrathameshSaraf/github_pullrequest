import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_pullrequest/BLOC/pullRequest/pr_event.dart' show PullRequestEvent, RefreshPullRequests, FetchPullRequests;
import 'package:github_pullrequest/BLOC/pullRequest/pr_state.dart' show PullRequestInitial, PullRequestState, PullRequestLoading, PullRequestLoaded, PullRequestError;

import '../../Data/Services/githubService.dart' show GitHubService;


class PullRequestBloc extends Bloc<PullRequestEvent, PullRequestState> {
  final GitHubService service;

  PullRequestBloc(this.service) : super(PullRequestInitial()) {
    on<FetchPullRequests>(_onFetch);
    on<RefreshPullRequests>(_onRefresh);
  }

  Future<void> _onFetch(
      FetchPullRequests event, Emitter<PullRequestState> emit) async {
    emit(PullRequestLoading());
    try {
      final prs = await service.fetchPullRequests();
      emit(PullRequestLoaded(prs));
    } catch (e) {
      emit(PullRequestError(e.toString()));
    }
  }

  Future<void> _onRefresh(
      RefreshPullRequests event, Emitter<PullRequestState> emit) async {
    try {
      final prs = await service.fetchPullRequests();
      emit(PullRequestLoaded(prs));
    } catch (e) {
      emit(PullRequestError(e.toString()));
    }
  }
}
