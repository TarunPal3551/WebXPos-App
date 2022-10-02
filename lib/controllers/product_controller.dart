import 'package:flutter/cupertino.dart';
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

  ProductController() {
    getProducts();
  }

  void getProducts() {
    productRepo.productWithVariant().then((value) {
      productList = value;
      notifyListeners();
    });
  }

  Future<void> updateProductStock(int productId, double stockCount) async {
    await productRepo.updateProduct(productId,
        updateData: {DatabaseHandler.columnStockCount: stockCount});
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
