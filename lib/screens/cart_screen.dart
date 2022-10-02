import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx_pos/controllers/cart_controller.dart';
import 'package:webx_pos/controllers/home_controller.dart';
import 'package:webx_pos/controllers/product_controller.dart';
import 'package:webx_pos/models/order_model.dart';
import 'package:webx_pos/screens/common_widgets.dart';
import 'package:webx_pos/utils/webx_colors.dart';
import 'package:webx_pos/utils/webx_constant.dart';

class CartScreen extends StatelessWidget {
  CartController cartController;

  CartScreen(this.cartController);

  @override
  Widget build(BuildContext context) {
    print("cartController.cartProducts.length");
    print(cartController.cartProducts.length);
    // TODO: implement build
    return Scaffold(
      backgroundColor: WebXColor.backgroundColor,
      body: ChangeNotifierProvider.value(
        value: Provider.of<CartController>(context),
        builder: (context, child) {
          print(Provider.of<CartController>(context).cartProducts.length);
          return ChangeNotifierProvider<ProductController>(
            create: (context) {
              return ProductController();
            },
            builder: (contextProduct, child) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (context.watch<CartController>().cartProducts.isNotEmpty)
                      ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (contextList, index) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "${context.watch<CartController>().cartProducts.elementAt(index).variant.name}",
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                      Text(
                                        "${WebXConstant.currencySymbol}${context.watch<CartController>().cartProducts.elementAt(index).variant.price}",
                                        style: const TextStyle(fontSize: 18),
                                      )
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${WebXConstant.currencySymbol}${context.watch<CartController>().getPrice(context.watch<CartController>().cartProducts.elementAt(index).variant.id!, context.watch<CartController>().cartProducts.elementAt(index).variant.price!)}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: WebXColor.textColorPrimary),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CommonWidget.getQuantityButton(
                                          Provider.of<CartController>(context,
                                              listen: false),
                                          context
                                              .watch<CartController>()
                                              .cartProducts
                                              .elementAt(index)
                                              .variant
                                              .id!,
                                          context
                                              .watch<CartController>()
                                              .cartProducts
                                              .elementAt(index)
                                              .product
                                              .id!),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount:
                            context.watch<CartController>().cartProducts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      )
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 130,
                          ),
                          InkWell(
                            onTap: () {
                              Provider.of<CartController>(context,
                                      listen: false)
                                  .getCartProduct();
                            },
                            child: Image.asset(
                              "assets/images/shopping-list.png",
                              width: 100,
                              height: 100,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Center(
                            child: Text("Cart is empty",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: context
              .watch<CartController>()
              .cartProducts
              .isNotEmpty
          ? Container(
              margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              WebXColor.accent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ))),
                      child: Text(
                        "Checkout".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        OrderModel? orderModel =
                            await Provider.of<CartController>(context,
                                    listen: false)
                                .createOrder();
                        if (orderModel != null) {
                          CommonWidget.successDialog(
                                  context: context, orderId: orderModel.id!)
                              .then((value) async {
                            Provider.of<CartController>(context, listen: false)
                                .getCartProduct();
                            Navigator.pop(context);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: 0,
            ),
    );
  }
}
