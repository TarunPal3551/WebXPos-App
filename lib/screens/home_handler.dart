import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx_pos/controllers/cart_controller.dart';
import 'package:webx_pos/controllers/home_controller.dart';

class HomeHandler extends StatelessWidget {
  const HomeHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("object");
    return ChangeNotifierProvider(
      create: (context) {
        return CartController();
      },
      builder: (context, child) {
        return ChangeNotifierProvider(
          create: (context) => HomeController(),
          builder: (context, child) {
            return Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.point_of_sale_sharp),
                    label: 'POS',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt_outlined),
                    label: 'Products',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart),
                    label: 'Summary',
                  ),
                ],
                currentIndex: context.watch<HomeController>().bottomSelectedIndex,
                onTap: (index) {
                  Provider.of<HomeController>(context, listen: false)
                      .changeBottomIndex(index);
                  Provider.of<CartController>(context, listen: false)
                      .getCartProduct();
                },
              ),
              body: context.watch<HomeController>().bottomPageList[
              context.watch<HomeController>().bottomSelectedIndex],
            );
          },
        );
      },
    );
  }
}
