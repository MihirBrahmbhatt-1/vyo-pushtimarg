import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

import '../const/app_color.dart';

class CustomIconWidget extends StatefulWidget {
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final bool? isLoading;
  final bool? isFontBold;

  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final IconData? icon;
  final double? iconSize;
  final bool? isAnimated;

  const CustomIconWidget({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    this.iconColor,
    this.borderColor,
    this.isLoading,
    this.backgroundColor,
    this.isFontBold,
    required this.icon,
    this.iconSize,
    this.isAnimated,
  });

  @override
  State<CustomIconWidget> createState() => _CustomIconWidgetState();
}

class _CustomIconWidgetState extends State<CustomIconWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isAnimated == true
        ? ShakeAnimatedWidget(
            enabled: true,
            duration: const Duration(milliseconds: 1000),
            shakeAngle: Rotation.deg(z: 10),
            curve: Curves.fastLinearToSlowEaseIn,
            child: Icon(
              widget.icon,
              color: widget.iconColor ?? AppColors.primaryColor,
              size: widget.iconSize ?? 24,
            ),
          )
        : Icon(
            widget.icon,
            color: widget.iconColor ?? AppColors.primaryColor,
            size: widget.iconSize ?? 24,
          );
  }
}

class CustomIconButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final bool? isLoading;
  final bool? isFontBold;
  final bool? isAnimated;
  final bool? isFilled;

  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final IconData? icon;
  final double? iconSize;

  const CustomIconButtonWidget({
    super.key,
    required this.onPressed,
    this.height,
    this.width,
    this.iconColor,
    this.borderColor,
    this.isLoading,
    this.backgroundColor,
    this.isFontBold,
    required this.icon,
    this.iconSize,
    this.isAnimated,
    this.isFilled,
  });

  @override
  State<CustomIconButtonWidget> createState() => _CustomIconButtonWidgetState();
}

class _CustomIconButtonWidgetState extends State<CustomIconButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isFilled == true
        ? IconButton.filled(
            icon: CustomIconWidget(
              icon: widget.icon,
              iconColor: widget.iconColor ?? AppColors.black,
              iconSize: widget.iconSize ?? 24,
              isAnimated: widget.isAnimated ?? false,
            ),
            onPressed: widget.onPressed,
          )
        : IconButton(
            icon: CustomIconWidget(
              icon: widget.icon,
              iconColor: widget.iconColor ?? AppColors.black,
              iconSize: widget.iconSize ?? 24,
              isAnimated: widget.isAnimated ?? false,
            ),
            onPressed: widget.onPressed,
          );
  }
}

class CustomImageAssetWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final bool? isLoading;

  final Color? imageColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final IconData? icon;
  final double? iconSize;
  final String imagePath;
  final VoidCallback? onPressed;

  const CustomImageAssetWidget({
    super.key,
    required this.imagePath,
    required this.height,
    required this.width,
    this.imageColor,
    this.borderColor,
    this.isLoading,
    this.backgroundColor,
    this.icon,
    this.iconSize,
    this.onPressed,
  });

  @override
  State<CustomImageAssetWidget> createState() => _CustomImageAssetWidgetState();
}

class _CustomImageAssetWidgetState extends State<CustomImageAssetWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Image.asset(
        widget.imagePath,
        height: widget.height,
        width: widget.width,
        color: widget.imageColor,
      ),
    );
  }
}
