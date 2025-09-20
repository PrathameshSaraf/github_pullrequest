import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:github_pullrequest/Presentation/Screens/shimmerLoading.dart';

import '../../BLOC/pullRequest/pr_bloc.dart';
import '../../BLOC/pullRequest/pr_event.dart';
import '../../BLOC/pullRequest/pr_state.dart';
import '../../Data/Model/PrModel.dart';
import '../../Data/Services/githubService.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PullRequestBloc(GitHubService())..add(const FetchPullRequests()),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "GitHub PR Requests",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurple.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<PullRequestBloc, PullRequestState>(
        builder: (context, state) {
          if (state is PullRequestLoading) {
            return const ShimmerLoading();
          } else if (state is PullRequestLoaded) {
            return Column(
              children: [
                // Filter Status Bar
                _FilterStatusBar(state: state),
                // PR List
                Expanded(
                  child: state.pullRequests.isEmpty
                      ? _EmptyState(state: state)
                      : RefreshIndicator(
                    color: Colors.deepPurple,
                    onRefresh: () async {
                      context.read<PullRequestBloc>().add(
                        RefreshPullRequests(
                          state: state.currentState,
                          sort: state.currentSort,
                          direction: state.currentDirection,
                          head: state.currentHead,
                          base: state.currentBase,
                        ),
                      );
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.w),
                      itemCount: state.pullRequests.length,
                      itemBuilder: (context, index) {
                        final pr = state.pullRequests[index];
                        return _PullRequestTile(pr: pr);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is PullRequestError) {
            return _ErrorState(message: state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final bloc = context.read<PullRequestBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: const _FilterBottomSheet(),
      ),
    );
  }
}

class _FilterStatusBar extends StatelessWidget {
  final PullRequestLoaded state;

  const _FilterStatusBar({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _FilterChip(label: '${state.currentState.toUpperCase()}', isActive: true),
          _FilterChip(label: 'Sort: ${state.currentSort}'),
          _FilterChip(label: '${state.currentDirection.toUpperCase()}'),
          if (state.currentHead != null)
            _FilterChip(label: 'Head: ${state.currentHead}'),
          if (state.currentBase != null)
            _FilterChip(label: 'Base: ${state.currentBase}'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade600,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              '${state.pullRequests.length} PRs',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _FilterChip({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive ? Colors.deepPurple.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isActive ? Colors.deepPurple.shade300 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          color: isActive ? Colors.deepPurple.shade700 : Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final PullRequestLoaded state;

  const _EmptyState({required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.deepPurple,
      onRefresh: () async {
        context.read<PullRequestBloc>().add(
          RefreshPullRequests(
            state: state.currentState,
            sort: state.currentSort,
            direction: state.currentDirection,
            head: state.currentHead,
            base: state.currentBase,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        children: [
          SizedBox(height: 100.h),
          Icon(
            Icons.inbox_outlined,
            size: 64.w,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            "No ${state.currentState} pull requests found",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Pull down to refresh",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.w,
            color: Colors.red.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            "Something went wrong",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              context.read<PullRequestBloc>().add(const FetchPullRequests());
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
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
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: () {
          // You can add navigation to PR details here
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and State
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      pr.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: Colors.grey.shade800,
                        height: 1.3,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _StateIndicator(pr: pr),
                ],
              ),
              SizedBox(height: 12.h),

              // Body preview (if available)
              if (pr.body != null && pr.body!.isNotEmpty) ...[
                Text(
                  pr.body!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12.h),
              ],

              // Meta info
              Row(
                children: [
                  _MetaInfo(
                    icon: Icons.person_outline,
                    text: pr.author,
                  ),
                  SizedBox(width: 16.w),
                  _MetaInfo(
                    icon: Icons.schedule,
                    text: _formatDate(pr.createdAt),
                  ),
                  const Spacer(),
                  Text(
                    '#${pr.number}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.deepPurple.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

class _StateIndicator extends StatelessWidget {
  final PullRequest pr;

  const _StateIndicator({required this.pr});

  @override
  Widget build(BuildContext context) {
    final state = _getPRState();
    final color = _getStateColor(state);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            state.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getPRState() {

    return pr.state;
  }

  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'open':
        return Colors.green.shade600;
      case 'closed':
        return Colors.red.shade600;
      case 'merged':
        return Colors.deepPurple.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}

class _MetaInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14.w,
          color: Colors.grey.shade500,
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet();

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String selectedState = 'open';
  String selectedSort = 'created';
  String selectedDirection = 'desc';
  String? selectedHead;
  String? selectedBase;

  final headController = TextEditingController();
  final baseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFromCurrentState();
  }

  void _initializeFromCurrentState() {
    final currentState = context.read<PullRequestBloc>().state;
    if (currentState is PullRequestLoaded) {
      setState(() {
        selectedState = currentState.currentState;
        selectedSort = currentState.currentSort;
        selectedDirection = currentState.currentDirection;
        selectedHead = currentState.currentHead;
        selectedBase = currentState.currentBase;
        headController.text = selectedHead ?? '';
        baseController.text = selectedBase ?? '';
      });
    }
  }

  @override
  void dispose() {
    headController.dispose();
    baseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(top: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                // Header
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune,
                        color: Colors.deepPurple.shade600,
                        size: 24.w,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Filter Options",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _resetFilters,
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            color: Colors.deepPurple.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      // State Selection
                      _SectionTitle("Pull Request State"),
                      _StateSelector(),
                      SizedBox(height: 24.h),

                      // Sort Options
                      _SectionTitle("Sort By"),
                      _SortSelector(),
                      SizedBox(height: 24.h),

                      // Direction
                      _SectionTitle("Order"),
                      _DirectionSelector(),
                      SizedBox(height: 24.h),

                      // Branch Filters
                      // _SectionTitle("Branch Filters (Optional)"),
                      // SizedBox(height: 12.h),
                      // _BranchFilters(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),

                // Apply Button
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Apply Filters",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _SectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _StateSelector() {
    return Row(
      children: [
        Expanded(child: _FilterOption('open', 'Open', selectedState == 'open')),
        SizedBox(width: 8.w),
        Expanded(child: _FilterOption('closed', 'Closed', selectedState == 'closed')),
        SizedBox(width: 8.w),
        Expanded(child: _FilterOption('all', 'All', selectedState == 'all')),
      ],
    );
  }

  Widget _SortSelector() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _FilterOption('created', 'Created', selectedSort == 'created')),
            SizedBox(width: 8.w),
            Expanded(child: _FilterOption('updated', 'Updated', selectedSort == 'updated')),
            SizedBox(width: 8.w),
            Expanded(child: _FilterOption('popularity', 'Popularity', selectedSort == 'popularity')),
          ],
        ),

      ],
    );
  }

  Widget _DirectionSelector() {
    return Row(
      children: [
        Expanded(child: _FilterOption('desc', 'Newest First', selectedDirection == 'desc')),
        SizedBox(width: 8.w),
        Expanded(child: _FilterOption('asc', 'Oldest First', selectedDirection == 'asc')),
      ],
    );
  }

  Widget _FilterOption(String value, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (value == 'open' || value == 'closed' || value == 'all') {
            selectedState = value;
          } else if (value == 'created' || value == 'updated' || value == 'popularity' || value == 'long-running') {
            selectedSort = value;
          } else if (value == 'desc' || value == 'asc') {
            selectedDirection = value;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.shade50 : Colors.grey.shade50,
          border: Border.all(
            color: isSelected ? Colors.deepPurple.shade300 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.deepPurple.shade700 : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _BranchFilters() {
    return Column(
      children: [
        TextField(
          controller: headController,
          decoration: InputDecoration(
            labelText: "Head Branch",
            hintText: "e.g., feature-branch",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.deepPurple.shade600),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: baseController,
          decoration: InputDecoration(
            labelText: "Base Branch",
            hintText: "e.g., main, develop",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.deepPurple.shade600),
            ),
          ),
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      selectedState = 'open';
      selectedSort = 'created';
      selectedDirection = 'desc';
      headController.clear();
      baseController.clear();
    });
  }

  void _applyFilters() {
    context.read<PullRequestBloc>().add(
      ApplyFilters(
        state: selectedState,
        sort: selectedSort,
        direction: selectedDirection,
        head: headController.text.trim().isEmpty ? null : headController.text.trim(),
        base: baseController.text.trim().isEmpty ? null : baseController.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }
}