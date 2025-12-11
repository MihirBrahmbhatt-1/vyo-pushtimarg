import 'package:flutter/material.dart';

import '../const/app_color.dart';
import '../const/app_constant.dart';
import 'custom_icon_widget.dart';
import 'custom_text_widget.dart';

class CustomCheckboxWidget extends StatefulWidget {
  final Function onChange;
  final bool isChecked;
  final double size;
  final double iconSize;
  final String name;
  final Color selectedColor;
  final Color selectedIconColor;
  final Color borderColor;
  final IconData checkIcon;

  const CustomCheckboxWidget(
      {super.key,
      required this.isChecked,
      required this.onChange,
      required this.name,
      required this.size,
      required this.iconSize,
      required this.selectedColor,
      required this.selectedIconColor,
      required this.borderColor,
      required this.checkIcon});

  @override
  State<CustomCheckboxWidget> createState() => _CustomCheckboxWidgetState();
}

class _CustomCheckboxWidgetState extends State<CustomCheckboxWidget> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isSelected = widget.isChecked;
    return InkWell(
      key: ValueKey(widget.name),
      splashColor: AppColors.primaryColor,
      radius: 20,
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onChange(_isSelected);
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 10),
            decoration: BoxDecoration(
                color: _isSelected ? widget.selectedColor : AppColors.grey,
                borderRadius: BorderRadius.circular(3.0),
                border: Border.all(
                  color: widget.borderColor,
                  width: 1,
                )),
            width: widget.size,
            height: widget.size,
            child: _isSelected
                ? CustomIconWidget(
                    icon: widget.checkIcon,
                    iconColor: widget.selectedIconColor,
                    iconSize: widget.iconSize,
                  )
                : CustomIconWidget(
                    icon: widget.checkIcon,
                    iconColor: AppColors.white,
                    iconSize: widget.iconSize,
                  ),
          ),
          const SizedBox(
            width: 5,
          ),
          widget.name.isNotEmpty
              ? Expanded(
                  child: CustomTextWidget(
                    uiKey: Key('${widget.name.toString()}-key'),
                    textString: widget.name,
                    textSize: FontSize().regular,
                    isFontBold: false,
                    fontColor: AppColors.black,
                    isFontUnderline: false,
                    numberOfLines: 1,
                    textCenter: false,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
