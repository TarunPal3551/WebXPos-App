import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webx_pos/database/database_handler.dart';

import 'package:webx_pos/models/product_variant.dart';
import 'package:webx_pos/repository/product_repo.dart';

class ProductController extends ChangeNotifier {
  List<TextEditingController> nameListTextEditingController = [];
  List<TextEditingController> unitValueListTextEditingController = [];
  List<TextEditingController> priceListTextEditingController = [];
  TextEditingController productNameEditingController = TextEditingController();
  TextEditingController productDescEditingController = TextEditingController();

  ProductRepo productRepo = ProductRepo();
  List<ProductData> productList = [];
  List<Map<String, dynamic>> productStockCountList = [];
  bool isStockLoading = true;

  ProductController() {
    getProducts();
  }

  void getProducts() {
    isStockLoading = true;
    productRepo.productWithVariant().then((value) {
      productList = value;
      getProductStockCount(productList).then((values) {
        isStockLoading = false;
        notifyListeners();
      });
    });
  }

  num getStockCount(int index, int productId) {
    return isStockLoading
        ? 0
        : productStockCountList
            .elementAt(index)[productList.elementAt(index).id.toString()];
  }

  Future<void> getProductStockCount(List<ProductData> productList) async {
    isStockLoading = true;
    productStockCountList.clear();
    for (int i = 0; i < productList.length; i++) {
      num value = await productRepo.getProductStockCount(
        productList.elementAt(i).id.toString(),
      );
      productStockCountList
          .add({productList.elementAt(i).id.toString(): value});
    }
    isStockLoading = false;
    notifyListeners();
  }

  void setInitialData({bool forEdit = true, ProductData? productData}) {
    if (forEdit) {
      if (productData != null) {
        productNameEditingController.text = productData.name!;
        productDescEditingController.text = productData.desc ?? "";
        nameListTextEditingController.clear();
        unitValueListTextEditingController.clear();
        priceListTextEditingController.clear();
        if (productData.variants != null && productData.variants!.isNotEmpty) {
          for (int i = 0; i < productData.variants!.length; i++) {
            nameListTextEditingController.add(TextEditingController(
                text: productData.variants!.elementAt(i).name));
            unitValueListTextEditingController.add(TextEditingController(
                text: productData.variants!.elementAt(i).unit.toString()));
            priceListTextEditingController.add(TextEditingController(
                text: productData.variants!.elementAt(i).price.toString()));
          }
        }
      }
    }
  }

  Future<void> updateProductStock(int productId, double stockCount) async {
    await productRepo.updateStock(productId, stockCount);
  }

  Future<void> addNewVariant() async {
    nameListTextEditingController.add(TextEditingController());
    unitValueListTextEditingController.add(TextEditingController());
    priceListTextEditingController.add(TextEditingController());
    notifyListeners();
  }

  Future<void> submitProductData() async {
    final id = await productRepo.addProduct(
        productNameEditingController.text, productDescEditingController.text);
    for (int i = 0; i < nameListTextEditingController.length; i++) {
      await productRepo.addVariants(
          name: nameListTextEditingController.elementAt(i).text,
          price: priceListTextEditingController.elementAt(i).text,
          productId: id,
          unit: unitValueListTextEditingController.elementAt(i).text);
    }
    final stockId = productRepo.updateStock(id, 0);
    getProductStockCount(productList).then((value) {
      print("Product Stocks loaded");
      isStockLoading = false;
      notifyListeners();
    });
  }

  // remove
  void removeNewVariant(int index) {
    nameListTextEditingController.removeAt(index);
    unitValueListTextEditingController.removeAt(index);
    priceListTextEditingController.removeAt(index);
    notifyListeners();
  }

  // delete product
  Future<void> deleteProduct(int id) async {
    await productRepo.deleteProduct(id);
  }
}
