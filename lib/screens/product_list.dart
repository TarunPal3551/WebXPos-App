import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx_pos/controllers/cart_controller.dart';
import 'package:webx_pos/controllers/home_controller.dart';
import 'package:webx_pos/controllers/product_controller.dart';
import 'package:webx_pos/models/variant.dart';
import 'package:webx_pos/screens/cart_screen.dart';
import 'package:webx_pos/screens/common_widgets.dart';
import 'package:webx_pos/screens/home_screen.dart';
import 'package:webx_pos/utils/utils_widget.dart';
import 'package:webx_pos/utils/webx_colors.dart';
import 'package:webx_pos/utils/webx_constant.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext contextMain) {
    return ChangeNotifierProvider.value(
      value: Provider.of<CartController>(context),
      child: ChangeNotifierProvider<ProductController>(
        create: (context) {
          return ProductController();
        },
        lazy: true,
        builder: (contextMain, child) {
          return Scaffold(
            key: scaffoldState,
            floatingActionButton: Provider.of<CartController>(context,
                        listen: false)
                    .cartItem
                    .isNotEmpty
                ? Stack(
                    children: [
                      FloatingActionButton(
                        onPressed: () async {
                          Provider.of<CartController>(context, listen: false)
                              .getCartProduct();
                          UtilsWidget.showWebXBottomSheet(
                              context,
                              ChangeNotifierProvider<CartController>.value(
                                value: Provider.of<CartController>(context,
                                    listen: false),
                                child: CartScreen(
                                  Provider.of<CartController>(context,
                                      listen: false),
                                ),
                              ));
                        },
                        child: const Icon(Icons.add_shopping_cart),
                      ),
                      Positioned(
                        right: 1,
                        child: CircleAvatar(
                          radius: 13,
                          child: ChangeNotifierProvider.value(
                            value: Provider.of<CartController>(contextMain),
                            child: Text(
                              "${contextMain.watch<CartController>().cartCount}",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
            appBar: AppBar(
              title: const Text("Product List"),
              actions: [
                InkWell(
                  child: const Icon(Icons.add),
                  onTap: () {
                    Navigator.push(contextMain, MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    )).then((value) {
                      Provider.of<ProductController>(contextMain, listen: false)
                          .getProducts();
                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: const Icon(Icons.refresh),
                  onTap: () {
                    Provider.of<ProductController>(contextMain, listen: false)
                        .getProducts();
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        Provider.of<ProductController>(
                                                    contextMain)
                                                .productList[index]
                                                .name ??
                                            '',
                                        style: const TextStyle(
                                          color: WebXColor.textColorPrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await Provider.of<ProductController>(
                                                  contextMain,
                                                  listen: false)
                                              .deleteProduct(Provider.of<
                                                          ProductController>(
                                                      contextMain,
                                                      listen: false)
                                                  .productList[index]
                                                  .id!);
                                          Provider.of<ProductController>(
                                                  contextMain,
                                                  listen: false)
                                              .getProducts();
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Count: ${Provider.of<ProductController>(contextMain).productList[index].stockCount ?? 0}",
                                        style: const TextStyle(
                                          color: WebXColor.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        child: const CircleAvatar(
                                          child: Icon(
                                            Icons.add,
                                            size: 22,
                                          ),
                                          radius: 15,
                                        ),
                                        onTap: () {
                                          CommonWidget.stockUpdateDialog(
                                            context: context,
                                            currentQuantity:
                                                Provider.of<ProductController>(
                                                            contextMain,
                                                            listen: false)
                                                        .productList[index]
                                                        .stockCount ??
                                                    0,
                                            productId:
                                                Provider.of<ProductController>(
                                                        contextMain,
                                                        listen: false)
                                                    .productList[index]
                                                    .id!,
                                          ).then((value) {
                                            Provider.of<ProductController>(
                                                    contextMain,
                                                    listen: false)
                                                .getProducts();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                child: ListView.builder(
                                    itemBuilder: (context, indexSide) {
                                      return getVariantItem(
                                          contextMain
                                              .watch<ProductController>()
                                              .productList[index]
                                              .variants![indexSide],
                                          context,
                                          Provider.of<CartController>(context),
                                          contextMain
                                              .watch<ProductController>()
                                              .productList[index]
                                              .id!);
                                    },
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: contextMain
                                        .watch<ProductController>()
                                        .productList[index]
                                        .variants!
                                        .length),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: contextMain
                        .watch<ProductController>()
                        .productList
                        .length,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getVariantItem(Variant variant, BuildContext context,
      CartController cartController, int productId) {
    return ChangeNotifierProvider.value(
      value: cartController,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${variant.name}",
                        style: const TextStyle(
                            color: WebXColor.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${WebXConstant.currencySymbol}${variant.price}",
                        style: const TextStyle(
                            color: WebXColor.textColorGrey, fontSize: 18),
                      ),
                      Text(
                        variant.unit.toString(),
                        style: const TextStyle(
                            color: WebXColor.textColorGrey, fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
              CommonWidget.getQuantityButton(
                  cartController, variant.id!, productId)
            ],
          ),
        ),
      ),
    );
  }

//
}
