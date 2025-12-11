import 'package:flutter/material.dart';
import '../const/app_color.dart';
import '../const/app_constant.dart';
import 'custom_text_widget.dart';

enum ButtonType { elevated, icon, text }

class CustomButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isLoading;
  final bool isBold;
  final bool isUnderline;
  final ButtonType type;

  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;

  final double? width;
  final double? height;
  final Icon? icon;
  final Key? buttonKey;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.isBold = true,
    this.isUnderline = false,
    this.type = ButtonType.elevated,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.width,
    this.height,
    this.icon,
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    final loadingIndicator = SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(color: textColor, strokeWidth: 2),
    );

    final textWidget = CustomTextWidget(
      uiKey: Key('${title ?? "button"}-key'),
      textString: title ?? '',
      textSize: FontSize().medium,
      isFontBold: isBold,
      fontColor: textColor,
      isFontUnderline: isUnderline,
      textCenter: true,
    );

    Widget content = isLoading
        ? Center(child: loadingIndicator)
        : (type == ButtonType.icon && icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [icon!, const SizedBox(width: 8), textWidget],
              )
            : textWidget);

    Widget button;

    switch (type) {
      case ButtonType.text:
        button = InkWell(
          key: buttonKey ?? const Key('textButtonKey'),
          onTap: onPressed,
          onLongPress: onLongPress,
          splashColor: backgroundColor,
          highlightColor: backgroundColor,
          hoverColor: backgroundColor,
          overlayColor: WidgetStatePropertyAll(backgroundColor),
          child: SizedBox(
            width: width ?? 120,
            height: height,
            child: Center(child: content),
          ),
        );
        break;

      case ButtonType.icon:
      case ButtonType.elevated:
        button = ElevatedButton(
          key: buttonKey ?? const Key('elevatedButtonKey'),
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: buttonBorderRadius,
              side: BorderSide(
                color: borderColor ?? backgroundColor ?? AppColors.transparent,
                width: 1,
              ),
            ),
          ),
          child: content,
        );
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 45,
      child: button,
    );
  }
}
