import 'package:flutter/material.dart';
import 'package:playstation_manager/core/widgets/vector_icon.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/theme/app_colors.dart';

class GoogleButton extends StatefulWidget {
  final bool loading;
  final VoidCallback? onPressed;

  const GoogleButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: _hovered && !widget.loading ? AppColors.grey100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey300),
          boxShadow:
              _hovered && !widget.loading
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.loading) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    LocaleKeys.openingBrowser,
                    style: const TextStyle(
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ] else ...[
                  VectorIcon(
                    assetPath: VectorIcons.google,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    LocaleKeys.continueWithGoogle,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
