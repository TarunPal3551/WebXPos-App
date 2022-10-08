import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx_pos/controllers/cart_controller.dart';
import 'package:webx_pos/controllers/home_controller.dart';
import 'package:webx_pos/controllers/order_controller.dart';
import 'package:webx_pos/controllers/product_controller.dart';
import 'package:webx_pos/screens/product_edit_screen.dart';
import 'package:webx_pos/screens/product_list.dart';
import 'package:webx_pos/utils/webx_colors.dart';

import 'screens/home_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => CartController()),
      ],
      child: MaterialApp(
          title: 'WebXPos',
          theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch:
                  MaterialColor(WebXColor.primary.value, const <int, Color>{
            50: Color(0xff085DB6), //10%
            100: Color(0xff4CC3FD), //20%
            200: Color(0xff0C7DD9), //30%
            300: Color(0xff11a1fd), //40%
            400: Color(0x8011a1fd), //50%
            500: Color(0x9911a1fd), //60%
            600: Color(0xb311a1fd), //70%
            700: Color(0xff11a1fd), //80%
            800: Color(0xff170907), //90%
            900: Color(0xff000000),
          })),
          home: const HomeHandler()),
    );
  }
}
