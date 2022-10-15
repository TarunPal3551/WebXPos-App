import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx_pos/controllers/cart_controller.dart';
import 'package:webx_pos/controllers/home_controller.dart';
import 'package:webx_pos/controllers/product_controller.dart';
import 'package:webx_pos/models/variant.dart';
import 'package:webx_pos/screens/cart_screen.dart';
import 'package:webx_pos/screens/common_widgets.dart';
import 'package:webx_pos/screens/product_edit_screen.dart';
import 'package:webx_pos/utils/utils_widget.dart';
import 'package:webx_pos/utils/webx_colors.dart';
import 'package:webx_pos/utils/webx_constant.dart';
import 'package:webx_pos/utils/webx_helper.dart';

class ProductList extends StatefulWidget {
  bool forCart;

  ProductList({Key? key, required this.forCart});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            floatingActionButton:
                Provider.of<CartController>(context, listen: false)
                        .cartItem
                        .isNotEmpty
                    ? Stack(
                        children: [
                          FloatingActionButton(
                            onPressed: () async {
                              Provider.of<CartController>(contextMain,
                                      listen: false)
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
                                  )).then((value) {
                                Provider.of<ProductController>(contextMain,
                                        listen: false)
                                    .getProducts();
                              });
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
              title: Text(!widget.forCart ? "Product List" : "WebX POS"),
              actions: [
                !widget.forCart
                    ? InkWell(
                        child: const Icon(Icons.add),
                        onTap: () {
                          Navigator.push(contextMain, MaterialPageRoute(
                            builder: (context) {
                              return ProductEditor();
                            },
                          )).then((value) {
                            Provider.of<ProductController>(contextMain,
                                    listen: false)
                                .getProducts();
                          });
                        },
                      )
                    : Container(),
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
                      return getProductItem(contextMain, index, widget.forCart);
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

  Widget getProductItem(BuildContext contextMain, int index, bool forCart) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          Provider.of<ProductController>(contextMain)
                                  .productList[index]
                                  .name ??
                              '',
                          style: const TextStyle(
                            color: WebXColor.textColorPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Stock : ${(Provider.of<ProductController>(contextMain).isStockLoading) ? 0 : Provider.of<ProductController>(contextMain).getStockCount(index, Provider.of<ProductController>(contextMain).productList[index].id!)}",
                          style: const TextStyle(
                            color: WebXColor.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                !forCart
                    ? Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              CommonWidget.showConfirmDialog(context,
                                  title: "Confirmation",
                                  message: "Are you sure you want to remove ?",
                                  onYes: () async {
                                await Provider.of<ProductController>(
                                        contextMain,
                                        listen: false)
                                    .deleteProduct(
                                        Provider.of<ProductController>(
                                                contextMain,
                                                listen: false)
                                            .productList[index]
                                            .id!);
                                Provider.of<ProductController>(contextMain,
                                        listen: false)
                                    .getProducts();
                              });
                            },
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: WebXColor.primaryTransparent,
                              child: Icon(
                                Icons.delete,
                                color: WebXColor.primary,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.push(contextMain, MaterialPageRoute(
                                builder: (context) {
                                  return ProductEditor(
                                    forEdit: true,
                                    productData: Provider.of<ProductController>(
                                            contextMain,
                                            listen: false)
                                        .productList[index],
                                  );
                                },
                              )).then((value) {
                                Provider.of<ProductController>(contextMain,
                                        listen: false)
                                    .getProducts();
                              });
                            },
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: WebXColor.primaryTransparent,
                              child: Icon(
                                Icons.edit,
                                color: WebXColor.primary,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: WebXColor.primaryTransparent,
                              child: Icon(
                                Icons.add,
                                color: WebXColor.primary,
                              ),
                            ),
                            onTap: () {
                              CommonWidget.stockUpdateDialog(
                                context: context,
                                currentQuantity: Provider.of<ProductController>(
                                        contextMain,
                                        listen: false)
                                    .getStockCount(
                                        index,
                                        Provider.of<ProductController>(
                                                contextMain,
                                                listen: false)
                                            .productList[index]
                                            .id!),
                                productId: Provider.of<ProductController>(
                                        contextMain,
                                        listen: false)
                                    .productList[index]
                                    .id!,
                              ).then((value) {
                                Provider.of<ProductController>(contextMain,
                                        listen: false)
                                    .getProducts();
                              });
                            },
                          )
                        ],
                      )
                    : Container(),
              ],
            ),
            const SizedBox(
              height: 10,
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
                            .id!,
                        forCart,
                        contextMain.watch<ProductController>().getStockCount(
                                index,
                                Provider.of<ProductController>(contextMain,
                                        listen: false)
                                    .productList[index]
                                    .id!) >
                            0);
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
  }

  Widget getVariantItem(
      Variant variant,
      BuildContext context,
      CartController cartController,
      int productId,
      bool forCart,
      bool isStockAvailable) {
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
              forCart
                  ? isStockAvailable
                      ? CommonWidget.getQuantityButton(
                          cartController, variant.id!, productId)
                      : const Card(
                          child: Text("OUT OF STOCK"),
                        )
                  : Row(
                      children: [
                        InkWell(
                            onTap: () {
                              editVariantView(
                                variant.name!,
                                variant.price!.toString(),
                                variant.unit!.toString(),
                                variant.id!,
                                variant.productId!,
                                context,
                              );
                            },
                            child: const CircleAvatar(
                              backgroundColor: WebXColor.primary,
                              radius: 15,
                              child: Icon(
                                Icons.edit,
                                size: 15,
                                color: Colors.white,
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              CommonWidget.showConfirmDialog(context,
                                  title: "Delete Variant",
                                  message: "Are you sure you want to delete ?",
                                  onYes: () async {
                                await Provider.of<ProductController>(context,
                                        listen: false)
                                    .removeVariantById(variant.id!);
                              });
                            },
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: WebXColor.primary,
                              child: Icon(
                                Icons.delete,
                                size: 15,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  void editVariantView(String name, String price, String unit, int id,
      int productId, BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameEditingController =
        TextEditingController(text: name);
    TextEditingController priceEditingController =
        TextEditingController(text: price);
    TextEditingController unitEditingController =
        TextEditingController(text: unit);

    UtilsWidget.showWebXBottomSheet(
        context,
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Variant",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      controller: nameEditingController,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Required";
                      },
                      decoration: const InputDecoration(hintText: "Name"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: priceEditingController,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Required";
                      },
                      decoration: const InputDecoration(hintText: "Price"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: unitEditingController,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Required";
                      },
                      decoration: const InputDecoration(
                          hintText: "Unit Value , eg - 0.5 , 1"),
                    ),
                  ],
                )),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  WebXColor.accent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                          child: Text(
                            "Submit".toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              UtilsWidget.showLoaderDialog(context);
                              Provider.of<ProductController>(context,
                                      listen: false)
                                  .editVariant(
                                      productId,
                                      priceEditingController.text,
                                      unitEditingController.text,
                                      nameEditingController.text,
                                      id);
                              UtilsWidget.hideLoading(context);
                              Navigator.pop(context);
                              Provider.of<ProductController>(context,
                                      listen: false)
                                  .getProducts();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
