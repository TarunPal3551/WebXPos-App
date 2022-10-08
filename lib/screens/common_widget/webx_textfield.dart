import 'package:flutter/material.dart';
import 'package:webx_pos/utils/webx_colors.dart';
import 'package:webx_pos/utils/webx_constant.dart';

Widget customTextField(
    {String title = "",
    String hinttext = "",
    MainAxisAlignment alignment = MainAxisAlignment.start,
    bool required = false,
    bool enabled = true,
    bool isSuffix = false,
    bool obscureText = false,
    Widget? suffixIcon,
    TextEditingController? textEditingController,
    ValueChanged<String>? onChanged,
    GestureTapCallback? gestureTapCallback,
    FormFieldValidator<String>? validator,
    TextInputType? inputType,
    int? maxLength}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: alignment,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          if (required)
            Text(
              " *",
              style: TextStyle(
                color: WebXColor.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
        ],
      ),
      Material(
        color: Colors.transparent,
        child: TextFormField(
          maxLength: maxLength,
          onTap: gestureTapCallback,
          controller: textEditingController,
          onChanged: onChanged,
          keyboardType: inputType,
          obscureText: obscureText,
          validator: validator,
          cursorColor: WebXColor.primary,
          textInputAction: TextInputAction.done,
          enabled: enabled,
          enableIMEPersonalizedLearning: true,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: const Color(0xffC4C4C4).withOpacity(0.4)),
            ),
            counter: const Offstage(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffC4C4C4)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffC4C4C4)),
            ),
            // errorText: "Enter valid $title",
            hintText: hinttext,
            suffixIcon: isSuffix
                ? suffixIcon ??
                    const Icon(
                      Icons.keyboard_arrow_down,
                    )
                : null,
            hintStyle: TextStyle(
              color: const Color(0xffababac),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ],
  );
}
