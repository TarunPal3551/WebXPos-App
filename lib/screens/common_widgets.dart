import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx_pos/controllers/cart_controller.dart';
import 'package:webx_pos/controllers/product_controller.dart';
import 'package:webx_pos/screens/common_widget/exitDialog.dart';
import 'package:webx_pos/utils/webx_colors.dart';

class CommonWidget {
  static Widget getQuantityButton(
      CartController cartController, int variantId, int productId) {
    return ChangeNotifierProvider.value(
      value: cartController,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  cartController.removeItem(1, productId, variantId);
                },
                child: const CircleAvatar(
                  backgroundColor: WebXColor.textColorGreyTransparent,
                  child: Icon(
                    Icons.remove,
                    color: WebXColor.primary,
                  ),
                  radius: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${cartController.variantItem[variantId] ?? 0}",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              InkWell(
                onTap: () {
                  cartController.addItem(1, productId, variantId);
                },
                child: const CircleAvatar(
                  backgroundColor: WebXColor.textColorGreyTransparent,
                  child: Icon(
                    Icons.add,
                    color: WebXColor.primary,
                  ),
                  radius: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<dynamic> stockUpdateDialog(
      {required BuildContext context,
      required num currentQuantity,
      required int productId}) async {
    double quantity = currentQuantity.toDouble();

    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ChangeNotifierProvider(
              create: (context) => ProductController(),
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Current Stock Count"),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${currentQuantity.toDouble()}",
                      style: const TextStyle(
                          fontSize: 30,
                          color: WebXColor.accent,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: quantity.toString(),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                quantity = double.parse(value.toString());
                                setState(() {});
                              } else {
                                quantity = 0.0;
                              }
                            },
                            validator: (value) {
                              return value!.isNotEmpty ? null : "Required";
                            },
                            decoration: const InputDecoration(
                                hintText: "Enter new stock value",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "New Stock Count",
                                labelStyle: TextStyle(fontSize: 18)),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
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
                                  await Provider.of<ProductController>(context,
                                          listen: false)
                                      .updateProductStock(productId, quantity);
                                  Navigator.pop(context);
                                })),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close")),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // order success dialog

  static Future<dynamic> successDialog(
      {required BuildContext context, required int orderId}) async {
    return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Order Id # ${orderId}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(
                    Icons.assignment_turned_in,
                    color: WebXColor.green,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          WebXColor.accent),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ))),
                              child: Text(
                                "DONE".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () async {
                                // Navigator.pop(context);
                                Navigator.pop(context);
                              })),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Future showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onYes,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ConfirmationDialog(
              title: title, message: message, onYes: onYes);
        });
  }

  static Widget variantAddView(int index, BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<ProductController>(context),
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TextFormField(
              controller: Provider.of<ProductController>(context)
                  .nameListTextEditingController[index],
              validator: (value) {
                return value!.isNotEmpty ? null : "Required";
              },
              decoration: const InputDecoration(hintText: "Name"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: Provider.of<ProductController>(context)
                  .priceListTextEditingController[index],
              validator: (value) {
                return value!.isNotEmpty ? null : "Required";
              },
              decoration: const InputDecoration(hintText: "Price"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: Provider.of<ProductController>(context)
                  .unitValueListTextEditingController[index],
              validator: (value) {
                return value!.isNotEmpty ? null : "Required";
              },
              decoration:
                  const InputDecoration(hintText: "Unit Value , eg - 0.5 , 1"),
            ),
          ],
        );
      },
    );
  }
}
