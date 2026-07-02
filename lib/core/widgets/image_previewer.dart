import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_erp_system/core/constants/app_values.dart';
import 'package:local_erp_system/core/extentions/media_query_extenstions.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';
import 'package:local_erp_system/core/utils/gaps.dart';
import 'package:local_erp_system/core/widgets/custom_dialog.dart';

import '../languages/local_keys.g.dart';

class ImagePreviewer extends StatelessWidget {
  const ImagePreviewer({
    super.key,
    required this.imagePath,
    this.child,
    this.heroTag,
    this.isNetwork,
    this.isAsset,
  });

  /// The path or URL of the image to preview.
  final String imagePath;

  /// Optional child widget. If provided, tapping on this widget triggers the preview.
  /// If not provided, a default styled thumbnail is rendered.
  final Widget? child;

  /// Optional Hero tag for smooth transition animation.
  final String? heroTag;

  /// Explicitly specify if the image is from the network.
  /// If null, auto-detection will be performed.
  final bool? isNetwork;

  /// Explicitly specify if the image is from assets.
  /// If null, auto-detection will be performed.
  final bool? isAsset;

  bool get _isNetworkImage {
    if (isNetwork != null) return isNetwork!;
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  bool get _isAssetImage {
    if (isAsset != null) return isAsset!;
    return imagePath.startsWith('assets/');
  }

  void _showPreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final imageWidget = _buildImage(fit: BoxFit.contain, context: context);
        return CustomDialog(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Image Preview',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  splashRadius: 20.r,
                ),
              ],
            ),
            gapH(8),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.r8),
              child: Container(
                constraints: BoxConstraints(maxHeight: context.height * 0.65),
                color: context.theme.scaffoldBackgroundColor.withValues(
                  alpha: 0.3,
                ),
                child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  minScale: 1.0,
                  maxScale: 5.0,
                  child:
                      heroTag != null
                          ? Hero(tag: heroTag!, child: imageWidget)
                          : imageWidget,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage({required BoxFit fit, required BuildContext context}) {
    if (imagePath.isEmpty) {
      return _buildErrorWidget(context);
    }

    if (_isNetworkImage) {
      return Image.network(
        imagePath,
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) => _buildErrorWidget(context),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
      );
    } else if (_isAssetImage) {
      return Image.asset(
        imagePath,
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) => _buildErrorWidget(context),
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) => _buildErrorWidget(context),
      );
    }
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_not_supported_rounded,
            size: 48.r,
            color: Colors.grey,
          ),
          gapH(4),
          Text(
            LocaleKeys.failedToLoadImage,
            style: context.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultThumbnail(BuildContext context) {
    final thumbnailImage = _buildImage(fit: BoxFit.cover, context: context);
    return Container(
      constraints: BoxConstraints(maxWidth: 150.w, maxHeight: 150.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(
          color: context.colorScheme.secondaryFixed.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r12 - 1.0),
        child:
            heroTag != null
                ? Hero(tag: heroTag!, child: thumbnailImage)
                : thumbnailImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget displayWidget = child ?? _buildDefaultThumbnail(context);
    if (heroTag != null && child != null) {
      displayWidget = Hero(tag: heroTag!, child: displayWidget);
    }
    return InkWell(
      onTap: () => _showPreviewDialog(context),
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: displayWidget,
    );
  }
}
