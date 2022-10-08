import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx_pos/controllers/product_controller.dart';
import 'package:webx_pos/models/product_variant.dart';
import 'package:webx_pos/screens/common_widget/custom_container.dart';
import 'package:webx_pos/screens/common_widget/webx_textfield.dart';
import 'package:webx_pos/screens/common_widgets.dart';
import 'package:webx_pos/utils/utils_widget.dart';
import 'package:webx_pos/utils/webx_colors.dart';

class ProductEditor extends StatelessWidget {
  bool forEdit;
  ProductData? productData;

  ProductEditor({this.forEdit = false, this.productData});

  final _formKey = GlobalKey<FormState>();

  Widget variantAddView(int index, BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<ProductController>(
      create: (context) {
        return ProductController();
      },
      builder: (context, child) {
        Provider.of<ProductController>(context, listen: false)
            .setInitialData(forEdit: true, productData: productData);
        return Scaffold(
          backgroundColor: WebXColor.backgroundColor,
          appBar: AppBar(
            title: const Text("Product Editor"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "ADD PRODUCT",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          customTextField(
                              title: "Name",
                              textEditingController: context
                                  .watch<ProductController>()
                                  .productNameEditingController,
                              validator: (value) {
                                return value!.isNotEmpty ? null : "Required";
                              },
                              hinttext: "Enter Product Name",
                              required: true),
                          const SizedBox(
                            height: 20,
                          ),
                          customTextField(
                              title: "Description",
                              textEditingController: context
                                  .watch<ProductController>()
                                  .productDescEditingController,
                              hinttext: "Enter Product Desc (Optional)",
                              required: false),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Text(
                                "Add Variants",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: WebXColor.primary),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Provider.of<ProductController>(context,
                                            listen: false)
                                        .addNewVariant();
                                  },
                                  child: const Text(
                                    "ADD",
                                    style: const TextStyle(fontSize: 18),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ChangeNotifierProvider.value(
                              value: Provider.of<ProductController>(context),
                              builder: (context, child) {
                                return ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 20,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Variant ${index + 1}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  CommonWidget.showConfirmDialog(
                                                      context,
                                                      title: "Confirmation",
                                                      message:
                                                          "Are you sure you want to remove ?",
                                                      onYes: () {
                                                    Provider.of<ProductController>(
                                                            context,
                                                            listen: false)
                                                        .removeNewVariant(
                                                            index);
                                                  });
                                                },
                                                icon: const Icon(Icons.delete)),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                        variantAddView(index, context),
                                      ],
                                    );
                                  },
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: context
                                      .watch<ProductController>()
                                      .nameListTextEditingController
                                      .length,
                                );
                              }),
                          const SizedBox(
                            height: 0,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 40),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(WebXColor.accent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        if (Provider.of<ProductController>(context,
                                listen: false)
                            .nameListTextEditingController
                            .isNotEmpty) {
                          UtilsWidget.showLoaderDialog(context);
                          await Provider.of<ProductController>(context,
                                  listen: false)
                              .submitProductData();
                          UtilsWidget.hideLoading(context);
                          Navigator.pop(context);
                        } else {}
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
