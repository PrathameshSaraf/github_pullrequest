import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../BLOC/pullRequest/pr_bloc.dart';
import '../../BLOC/pullRequest/pr_event.dart';
import '../../BLOC/pullRequest/pr_state.dart';
import '../../Data/Model/PrModel.dart';
import '../../Data/Services/githubService.dart';

class HomeScreen extends StatelessWidget {
  final String owner;
  final String repo;

  const HomeScreen({super.key, required this.owner, required this.repo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      PullRequestBloc(GitHubService(owner: owner, repo: repo))
        ..add(FetchPullRequests()),
      child: Scaffold(
        appBar: AppBar(title: Text("$owner/$repo PRs")),
        body: BlocBuilder<PullRequestBloc, PullRequestState>(
          builder: (context, state) {
            if (state is PullRequestLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PullRequestLoaded) {
              if (state.pullRequests.isEmpty) {
                return const Center(child: Text("No open pull requests"));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PullRequestBloc>().add(RefreshPullRequests());
                },
                child: ListView.builder(
                  itemCount: state.pullRequests.length,
                  itemBuilder: (context, index) {
                    final pr = state.pullRequests[index];
                    return _PullRequestTile(pr: pr);
                  },
                ),
              );
            } else if (state is PullRequestError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _PullRequestTile extends StatelessWidget {
  final PullRequest pr;

  const _PullRequestTile({required this.pr});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(pr.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pr.body != null && pr.body!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Text(
                  pr.body!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Text("Author: ${pr.author}"),
            Text("Created: ${pr.createdAt.toLocal()}"),
          ],
        ),
      ),
    );
  }
}
