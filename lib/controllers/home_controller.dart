import 'package:flutter/cupertino.dart';
import 'package:webx_pos/screens/cart_screen.dart';
import 'package:webx_pos/screens/order_list.dart';
import 'package:webx_pos/screens/product_list.dart';

class HomeController extends ChangeNotifier {
  int bottomSelectedIndex = 0;
  List bottomPageList = [
    ProductList(
      forCart: true,
    ),
    ProductList(
      forCart: false,
    ),
    OrderList()
  ];

  void changeBottomIndex(int index) {
    bottomSelectedIndex = index;
    notifyListeners();
  }
}
