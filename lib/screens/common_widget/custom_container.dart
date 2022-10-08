import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webx_pos/utils/webx_colors.dart';

class CustomContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final double padding;
  final EdgeInsets? paddingEdge;
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final Color? borderColor;
  final Color backgroundColor;
  final Widget? backgroundImage;
  final double borderRadius;
  final Color? shadowColor;
  final double elevation;
  final Constraints? constraints;
  final double borderWidth;

  // ignore: use_key_in_widget_constructors
  const CustomContainer(
      {required this.child,
      this.onTap,
      this.height,
      this.width,
      this.margin,
      this.borderColor,
      this.shadowColor,
      this.padding = 10,
      this.paddingEdge,
      this.borderRadius = 5,
      this.backgroundColor = Colors.white,
      this.elevation = 2.5,
      this.borderWidth = 1,
      this.constraints,
      this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: Card(
          shape: RoundedRectangleBorder(
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: borderWidth)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          color: backgroundColor,
          elevation: elevation,
          margin: margin,
          shadowColor: shadowColor ?? WebXColor.primaryLight,
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding:
                paddingEdge == null ? EdgeInsets.all(padding) : paddingEdge!,
            child: backgroundImage != null
                ? Stack(
                    children: [
                      Positioned(right: 0, child: backgroundImage!),
                      child,
                    ],
                  )
                : child,
          ),
        ),
      ),
    );
  }
}
