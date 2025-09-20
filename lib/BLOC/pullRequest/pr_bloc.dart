import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_pullrequest/BLOC/pullRequest/pr_event.dart';
import 'package:github_pullrequest/BLOC/pullRequest/pr_state.dart';

import '../../Data/Services/githubService.dart';

class PullRequestBloc extends Bloc<PullRequestEvent, PullRequestState> {
  final GitHubService service;

  PullRequestBloc(this.service) : super(PullRequestInitial()) {
    on<FetchPullRequests>(_onFetch);
    on<RefreshPullRequests>(_onRefresh);
    on<ApplyFilters>(_onApplyFilters);
  }

  Future<void> _onFetch(
      FetchPullRequests event, Emitter<PullRequestState> emit) async {
    emit(PullRequestLoading());
    try {
      final prs = await service.fetchPullRequestsWithFilters(
        state: event.state,
        sort: event.sort,
        direction: event.direction,
        head: event.head,
        base: event.base,
      );
      emit(PullRequestLoaded(
        prs,
        currentState: event.state,
        currentSort: event.sort,
        currentDirection: event.direction,
        currentHead: event.head,
        currentBase: event.base,
      ));
    } catch (e) {
      print("Error fetching PRs: $e");
      emit(PullRequestError(e.toString()));
    }
  }

  Future<void> _onRefresh(
      RefreshPullRequests event, Emitter<PullRequestState> emit) async {
    try {
      final prs = await service.fetchPullRequestsWithFilters(
        state: event.state,
        sort: event.sort,
        direction: event.direction,
        head: event.head,
        base: event.base,
      );
      emit(PullRequestLoaded(
        prs,
        currentState: event.state,
        currentSort: event.sort,
        currentDirection: event.direction,
        currentHead: event.head,
        currentBase: event.base,
      ));
    } catch (e) {
      emit(PullRequestError(e.toString()));
    }
  }

  Future<void> _onApplyFilters(
      ApplyFilters event, Emitter<PullRequestState> emit) async {
    emit(PullRequestLoading());
    try {
      final prs = await service.fetchPullRequestsWithFilters(
        state: event.state,
        sort: event.sort,
        direction: event.direction,
        head: event.head,
        base: event.base,
      );
      emit(PullRequestLoaded(
        prs,
        currentState: event.state,
        currentSort: event.sort,
        currentDirection: event.direction,
        currentHead: event.head,
        currentBase: event.base,
      ));
    } catch (e) {
      emit(PullRequestError(e.toString()));
    }
  }
}