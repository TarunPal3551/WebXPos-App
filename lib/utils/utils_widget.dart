import 'package:flutter/material.dart';
import 'package:webx_pos/utils/webx_colors.dart';

class UtilsWidget {
  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: const [
          CircularProgressIndicator(),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static Future showWebXBottomSheet(
    BuildContext context,
    Widget child,
  ) {
    return showModalBottomSheet(
      context: context,
      enableDrag: true,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 10,
              right: 0,
              left: 0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                mini: true,
                backgroundColor: WebXColor.black,
                child:
                    const Icon(Icons.close, color: WebXColor.backgroundColor),
              ),
            ),
            Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  color: WebXColor.backgroundColor,
                ),
                padding: const EdgeInsets.only(top: 20, left: 4, right: 4),
                margin: const EdgeInsets.only(top: 70),
                child: SingleChildScrollView(
                    child: Column(
                  children: [child],
                ))),
          ],
        );
      },
    );
  }
}
