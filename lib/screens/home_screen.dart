import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx_pos/controllers/product_controller.dart';
import 'package:webx_pos/utils/utils_widget.dart';
import 'package:webx_pos/utils/webx_colors.dart';

class HomeScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Widget variantAddView(int index, BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<ProductController>(context),
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextFormField(
                        controller: Provider.of<ProductController>(context)
                            .nameListTextEditingController[index],
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Required";
                        },
                        decoration: const InputDecoration(hintText: "Name"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: Provider.of<ProductController>(context)
                            .priceListTextEditingController[index],
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Required";
                        },
                        decoration: const InputDecoration(hintText: "Price"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: Provider.of<ProductController>(context)
                            .unitValueListTextEditingController[index],
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Required";
                        },
                        decoration: const InputDecoration(
                            hintText: "Unit Value , eg - 0.5 , 1"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  Provider.of<ProductController>(context, listen: false)
                      .removeNewVariant(index);
                },
                icon: const Icon(Icons.delete))
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
      child: Scaffold(
        backgroundColor: WebXColor.backgroundColor,
        appBar: AppBar(
          title: const Text("WebX POS"),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: context
                              .watch<ProductController>()
                              .productNameEditingController,
                          onChanged: (value) {},
                          decoration: const InputDecoration(hintText: "Name"),
                          validator: (value) {
                            return value!.isNotEmpty ? null : "Required";
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: context
                              .watch<ProductController>()
                              .productDescEditingController,
                          validator: (value) {
                            return value!.isNotEmpty ? null : "Required";
                          },
                          decoration:
                              const InputDecoration(hintText: "Description"),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              "Variants",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
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
                              return ListView.builder(
                                itemBuilder: (context, index) {
                                  return variantAddView(index, context);
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
                                  if (_formKey.currentState!.validate()) {
                                    if (Provider.of<ProductController>(context,
                                            listen: false)
                                        .nameListTextEditingController
                                        .isNotEmpty) {
                                      UtilsWidget.showLoaderDialog(context);
                                      await Provider.of<ProductController>(
                                              context,
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
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
