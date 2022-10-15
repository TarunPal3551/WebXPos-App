import 'package:flutter/material.dart';
import 'package:webx_pos/utils/webx_colors.dart';

class CustomButton extends StatelessWidget {
  VoidCallback onTap;
  String text;

  CustomButton({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(WebXColor.accent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ))),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      onPressed: () async {
        onTap();
      },
    );
  }
}
