import 'package:flutter/material.dart';
import 'package:webx_pos/screens/common_widget/custom_container.dart';
import 'package:webx_pos/utils/webx_colors.dart';
import 'package:webx_pos/utils/webx_constant.dart';

class MyTextField extends StatefulWidget {
  final Key? key;
  final String labelText;
  final void Function(String?) onChanged;
  final void Function(String?)? onSaved;
  final VoidCallback? trailingFunction;
  final String? defaultValue;
  final bool showTrailingWidget;
  final Widget? trailing;
  final bool autofocus;
  final TextEditingController? controller;
  final Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPasswordField;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderWidth;
  final double focusedBorderWidth;
  final double borderRadius;
  final String? hintText;
  final bool overrideHintText;
  final double? width;
  final EdgeInsets? margin;
  final EdgeInsets contentPadding;
  final Widget? prefixIcon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  final maxLength;
  final TextAlign textAlign;
  TextInputAction? textInputAction = TextInputAction.newline;

  MyTextField(
      {required this.labelText,
      required this.onChanged,
      this.onSaved,
      this.onTap,
      this.key,
      this.hintText,
      this.trailingFunction,
      this.defaultValue,
      this.keyboardType,
      this.controller,
      this.validator,
      this.trailing,
      this.width,
      this.margin,
      this.maxLines = 1,
      this.prefixIcon,
      this.overrideHintText = false,
      this.showTrailingWidget = false,
      this.readOnly = false,
      this.autofocus = false,
      this.isPasswordField = false,
      this.borderColor,
      this.focusedBorderColor,
      this.borderWidth = 1,
      this.maxLength = 100000000000,
      this.focusedBorderWidth = 2,
      this.borderRadius = 20,
      this.textAlign = TextAlign.left,
      this.contentPadding = const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      this.textInputAction});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _showPassword;

  @override
  void initState() {
    _showPassword = !widget.isPasswordField;
    super.initState();
  }

  void toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableIMEPersonalizedLearning: true,
      textInputAction: widget.textInputAction,
      onSaved: widget.onSaved,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      textAlign: widget.textAlign,
      controller: widget.controller,
      validator: widget.validator as String? Function(String?)?,
      initialValue: widget.defaultValue,
      textAlignVertical: TextAlignVertical.center,
      buildCounter: (BuildContext context,
              {int? currentLength, int? maxLength, bool? isFocused}) =>
          null,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      obscureText: widget.isPasswordField ? !_showPassword : false,
      maxLines: widget.maxLines,
      style: const TextStyle(color: WebXColor.black, fontSize: 18),
      cursorColor: WebXColor.primary,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Enter Value',
        hintStyle: const TextStyle(fontSize: 12, color: WebXColor.grey),
        contentPadding:
            widget.contentPadding ?? const EdgeInsets.fromLTRB(20, 20, 20, 5),
        errorStyle: const TextStyle(
          fontSize: 14,
          height: 0.8,
          inherit: true,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? Theme.of(context).accentColor,
            width: widget.borderWidth,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        labelStyle: const TextStyle(
            fontSize: 20,
            height: 1,
            fontWeight: FontWeight.bold,
            color: WebXColor.primary,
            inherit: true,
            shadows: [
              Shadow(
                  // bottomLeft
                  offset: Offset(-1.5, -1.5),
                  color: WebXColor.backgroundColor),
              Shadow(
                  // bottomRight
                  offset: Offset(1.5, -1.5),
                  color: WebXColor.backgroundColor),
              Shadow(
                  // topRight
                  offset: Offset(1.5, 1.5),
                  color: WebXColor.backgroundColor),
              Shadow(
                  // topLeft
                  offset: Offset(-1.5, 1.5),
                  color: WebXColor.backgroundColor)
            ]),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.focusedBorderColor ?? Theme.of(context).accentColor,
            width: widget.focusedBorderWidth,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ).copyWith(
        hintText: widget.overrideHintText
            ? widget.hintText
            : "Enter ${widget.labelText}",
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.showTrailingWidget
            ? widget.trailing ??
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: widget.isPasswordField
                      ? IconButton(
                          splashRadius: 1,
                          icon: _showPassword
                              ? const Icon(Icons.visibility,
                                  color: WebXColor.primary, size: 25.0)
                              : const Icon(Icons.visibility_off,
                                  color: WebXColor.grey, size: 25.0),
                          onPressed: toggleShowPassword,
                        )
                      : null,
                )
            : null,
      ),
    );
  }
}
