import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Import your custom constants (AppColors and borderRadius)
import '../const/app_color.dart'; 
import '../const/app_constant.dart';// Assuming AppConstant.borderRadius lives here

// ====================================================================
// BASE COMPONENTS (Item Builders)
// ====================================================================

/// 1. A reusable widget representing a single shimmering item in a grid (like a Category Card).
/// (Mapped to: ShimmerCard in the table)
class ShimmerCard extends StatelessWidget {
  final double borderRadius;

  const ShimmerCard({
    super.key,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Placeholder
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.5), 
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            // Text Placeholder (Full line)
            Container(height: 16, width: double.infinity, color: AppColors.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 8),
            // Sub-text Placeholder (Shorter line)
            Align(
              alignment: Alignment.center,
              child: Container(height: 16, width: 80, color: AppColors.grey.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. A reusable widget to display a single shimmering List Tile item.
/// (Mapped to: ShimmerListItem in the table)
class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    // const double borderRadius = borderRadius;
    return Card(
      elevation: 0, // Shimmer cards usually have no elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white, // The color that will be shimmered over
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Placeholder (Circular)
            Container(
              width: 56, // Size of the real icon container
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.white, // The base color of the skeleton
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            // Text Placeholder (Line)
            Container(height: 16, width: double.infinity, color: AppColors.white),
            const SizedBox(height: 8),
            // Sub-text Placeholder (Shorter line)
            Container(height: 16, width: 80, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// COMPOSITE COMPONENTS (Wrappers)
// ====================================================================

/// 3. A highly reusable GridView Shimmer effect, wrapping the items with the shimmer animation.
/// (Mapped to: ShimmerGrid in the table)
class ShimmerGrid extends StatelessWidget {
  final int itemCount;
  final Widget? itemWidget;
  
  const ShimmerGrid({
    super.key,
    this.itemCount = 10, 
    this.itemWidget, // Defaults to ShimmerCard
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey.withValues(alpha:  0.3),
      highlightColor: AppColors.grey.withValues(alpha: 0.1),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(), // For RefreshIndicator support
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 1.2,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          // Defaults to ShimmerCard
          return itemWidget ?? const ShimmerCard();
        },
      ),
    );
  }
}

/// 4. A highly reusable ListView Shimmer effect.
/// (Mapped to: ShimmerList in the table)
class ShimmerList extends StatelessWidget {
  final int itemCount;
  final Widget? itemWidget;
  
  const ShimmerList({
    super.key,
    this.itemCount = 20, // Default to 10 list items
    this.itemWidget, // Defaults to ShimmerListItem
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey.withValues(alpha: 0.3),
      highlightColor: AppColors.grey.withValues(alpha: 0.1),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(), // Only scrollable if wrapped in a scroll view
        itemCount: itemCount,
        itemBuilder: (context, index) {
          // Defaults to ShimmerListItem
          return itemWidget ?? const ShimmerListItem();
        },
      ),
    );
  }
}