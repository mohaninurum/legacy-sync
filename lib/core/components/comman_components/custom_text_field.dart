import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legacy_sync/core/colors/colors.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? lableText;
  final int? maxLength;
  final int? maxLines;
  final double radias;
  final double contentPaddingHorizontal;
  final TextEditingController controller;
  final bool isPassword;
  final bool bottomPadding;
  final bool readOnly;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixImageWidgetPathSVG;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  Function? onChanged;
  Function? onTap;
  Color bgColor;
  Color borderColor;

  CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.radias = 20,
    this.contentPaddingHorizontal = 12,
    this.isPassword = false,
    this.maxLength,
    this.maxLines,
    this.readOnly = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.lableText,
    this.suffixImageWidgetPathSVG,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.bottomPadding = true,
    this.bgColor = AppColors.primaryColorDull,
    this.borderColor = AppColors.greyBlue,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.lableText != null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(widget.lableText ?? ""),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          child: Container(
            margin: EdgeInsets.only(bottom: widget.bottomPadding ? 16 : 0),
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(widget.radias),
              // border: Border.all(
              //   color: _isFocused ? AppColors.whiteColor : AppColors.greyBlue,
              //   width: 1,
              // ),
            ),
            child: TextFormField(
              maxLines: widget.maxLines,
              autofocus: false,
              focusNode: widget.focusNode,
              maxLength: widget.maxLength,
              controller: widget.controller,
              obscureText: widget.isPassword ? _obscureText : false,
              keyboardType: widget.keyboardType,
              enableInteractiveSelection: true,
              textInputAction: TextInputAction.done,
              textAlignVertical: TextAlignVertical.center,
              readOnly: widget.readOnly,
              enabled: widget.enabled && !widget.readOnly,

              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!();
                }
              },
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
                setState(() {});
              },
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color:
                    widget.controller.text.isNotEmpty
                        ? AppColors.whiteColor
                        : AppColors.grey,
                fontSize: Platform.isIOS ? 18 : 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
              decoration: InputDecoration(
                fillColor: widget.bgColor,
                enabled: widget.enabled,
                counterText: "",
                counter: const SizedBox.shrink(),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon:
                    widget.suffixIcon ??
                    (widget.suffixImageWidgetPathSVG != null
                        ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            widget.suffixImageWidgetPathSVG!,
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                              widget.controller.text.isNotEmpty
                                  ? AppColors.whiteColor
                                  : AppColors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                        : null) ??
                    (widget.isPassword
                        ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color:
                                widget.controller.text.isNotEmpty
                                    ? AppColors.whiteColor
                                    : AppColors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                        : null),
                isDense: true,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radias),
                  borderSide: BorderSide(color: widget.borderColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radias),
                  borderSide: const BorderSide(
                    color: AppColors.whiteColor,
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radias),
                  borderSide: BorderSide(color: widget.borderColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radias),
                  borderSide: BorderSide(color: widget.borderColor, width: 1),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.contentPaddingHorizontal,
                  vertical: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
