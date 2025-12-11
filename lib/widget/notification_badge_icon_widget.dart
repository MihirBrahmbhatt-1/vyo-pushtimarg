import 'package:flutter/material.dart';

import '../const/constant.dart';
import 'custom_text_widget.dart';

// ignore: must_be_immutable
class NotificationBellIconWidget extends StatefulWidget {
  int notificationCount;
  NotificationBellIconWidget({
    super.key,
    required this.notificationCount,
  });

  @override
  State<NotificationBellIconWidget> createState() =>
      _NotificationBellIconWidgetState();
}

class _NotificationBellIconWidgetState
    extends State<NotificationBellIconWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.notificationCount > 0
        ? Positioned(
            top: 7,
            right: 5,
            child: Container(
              height: 18,
              width: 18,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.red,
              ),
              alignment: Alignment.center,
              child: CustomTextWidget(
                uiKey: Key('notificationcountbadge-key'),
                textString: widget.notificationCount.toString(),
                textSize: widget.notificationCount > 99
                    ? FontSize().xxsmall
                    : FontSize().xsmall,
                isFontBold: false,
                fontColor: AppColors.white,
                isFontUnderline: false,
              ),
            ),
          )
        : Container();
  }
}
