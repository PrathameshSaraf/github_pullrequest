import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.w),
      itemCount: 8, // Show 8 shimmer items
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and State Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title shimmer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer(
                            duration: const Duration(seconds: 2),
                            child: Container(
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Shimmer(
                            duration: const Duration(seconds: 2),
                            child: Container(
                              height: 16.h,
                              width: 0.7.sw, // 70% of screen width
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // State indicator shimmer
                    Shimmer(
                      duration: const Duration(seconds: 2),
                      child: Container(
                        width: 60.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Body preview shimmer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer(
                      duration: const Duration(seconds: 2),
                      child: Container(
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Shimmer(
                      duration: const Duration(seconds: 2),
                      child: Container(
                        height: 14.h,
                        width: 0.8.sw, // 80% of screen width
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Meta info row shimmer
                Row(
                  children: [
                    // Author shimmer
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Shimmer(
                          duration: const Duration(seconds: 2),
                          child: Container(
                            width: 14.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Shimmer(
                          duration: const Duration(seconds: 2),
                          child: Container(
                            width: 60.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16.w),
                    // Date shimmer
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Shimmer(
                          duration: const Duration(seconds: 2),
                          child: Container(
                            width: 14.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Shimmer(
                          duration: const Duration(seconds: 2),
                          child: Container(
                            width: 40.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // PR number shimmer
                    Shimmer(
                      duration: const Duration(seconds: 2),
                      child: Container(
                        width: 30.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}