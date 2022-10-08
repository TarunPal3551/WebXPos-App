import 'package:flutter/material.dart';

import 'package:webx_pos/database/database_handler.dart';
import 'package:webx_pos/models/cart_product.dart';
import 'package:webx_pos/models/order_model.dart';
import 'package:webx_pos/models/product.dart';
import 'package:webx_pos/models/product_variant.dart';
import 'package:webx_pos/models/variant.dart';
import 'package:webx_pos/repository/product_repo.dart';

class CartController extends ChangeNotifier {
  Map<int, int> cartItem = {};
  Map<int, int> variantItem = {};
  int cartCount = 0;
  ProductRepo productRepo = ProductRepo();
  double grandTotal = 0.0;
  double itemTotal = 0.0;
  List<OrderModel> orderList = [];

  List<CartProduct> cartProducts = [];

  Future<void> getCartProduct() async {
    cartProducts = [];
    print("" + variantItem.length.toString());
    for (int i = 0; i < variantItem.length; i++) {
      Variant? variant =
          await getVariantById(variantItem.entries.elementAt(i).key);
      Product? product = await getProductById(variant!.productId!);
      try {
        cartProducts.add(CartProduct(product!, variant,
            quantity: variantItem.entries.elementAt(i).value));
      } catch (e) {
        print(e);
      }
    }
    notifyListeners();
  }

  void getCartCount() {
    cartCount = 0;
    for (int i = 0; i < variantItem.length; i++) {
      cartCount += variantItem.entries.elementAt(i).value;
    }
    notifyListeners();
  }

  void addItem(int quantity, int productId, int variantId) {
    if (variantItem.containsKey(variantId)) {
      int quantity = cartItem[productId]! + 1;
      cartItem[productId] = quantity;
      int quantityVariant = variantItem[variantId]! + 1;
      variantItem[variantId] = quantityVariant;
    } else {
      cartItem[productId] = quantity;
      variantItem[variantId] = quantity;
    }
    getCartCount();
    notifyListeners();
  }

  void removeItem(int quantity, int productId, int variantId) {
    if (variantItem.containsKey(variantId)) {
      int quantity = variantItem[variantId]! - 1;
      if (quantity > 0) {
        variantItem[variantId] = quantity;
        if (cartItem.containsKey(productId)) {
          int quantity = cartItem[productId]! - 1;
          if (quantity > 0) {
            cartItem[productId] = quantity;
          } else {
            getCartProduct();
            cartItem.remove(productId);
          }
        } else {
          getCartProduct();
          cartItem.remove(productId);
        }
      } else {
        variantItem.remove(variantId);
        getCartProduct();
      }
    } else {
      getCartProduct();
      variantItem.remove(variantId);
    }
    getCartCount();
    notifyListeners();
  }

  Future<void> calculatePriceSummary() async {
    num tempItemTotal = 0.0;
    for (int i = 0; i < variantItem.length; i++) {
      Variant? variant =
          await getVariantById(variantItem.entries.elementAt(i).key);
      if (variant != null) {
        tempItemTotal = tempItemTotal +
            variant.price!.toDouble() * variantItem.entries.elementAt(i).value;
      }
    }
    itemTotal = tempItemTotal.toDouble();
    grandTotal = itemTotal;
    notifyListeners();
  }

  // create order
  Future<OrderModel?> createOrder() async {
    await getCartProduct();
    await calculatePriceSummary();
    Map<String, dynamic> orderData = {};
    int orderId = DateTime.now().millisecondsSinceEpoch;
    orderData[DatabaseHandler.columnTotal] = itemTotal;
    orderData[DatabaseHandler.columnId] = orderId;
    for (int i = 0; i < variantItem.length; i++) {
      Variant? variant =
          await getVariantById(variantItem.entries.elementAt(i).key);
      if (variant != null) {
        Map<String, dynamic> orderItemData = {};
        orderItemData[DatabaseHandler.columnVariantId] = variant.id;
        orderItemData[DatabaseHandler.columnQuantity] =
            variantItem.entries.elementAt(i).value;
        orderItemData[DatabaseHandler.columnVariantName] = variant.name;
        orderItemData[DatabaseHandler.columnPrice] = variant.price;
        Product? product = await getProductById(variant.productId!);
        orderItemData[DatabaseHandler.columnProductName] = product!.name;
        orderItemData[DatabaseHandler.columnUnitValue] = variant.unit;
        orderItemData[DatabaseHandler.columnOrderId] = orderId;
        orderItemData[DatabaseHandler.columnProductId] = variant.productId;
        await productRepo.createOrderItem(orderItemData);
      }
    }
    bool status = await settleStock();
    if (status) {
      await productRepo.createOrder(orderData);
      List<OrderModel> orderList = await productRepo.getOrderList();
      clearCart();
      return orderList.first;
    } else {
      print("Stock Settle Issue");
      return null;
    }
  }

  Future<void> getOrderList() async {
    await productRepo.getOrderList().then((value) {
      orderList = value;
      notifyListeners();
    });
  }

  void clearCart() {
    cartItem.clear();
    cartCount = 0;
    cartProducts.clear();
    variantItem.clear();
    itemTotal = 0.0;
    grandTotal = 0.0;
  }

  // settle stock by product id
  Future<bool> settleStock() async {
    for (int i = 0; i < cartProducts.length; i++) {
      Variant? variant =
          await getVariantById(cartProducts.elementAt(i).variant.id!);
      if (variant != null) {
        Product? product =
            await getProductById(cartProducts.elementAt(i).product.id!);
        if (product != null) {
          num currentStock = (await productRepo.getProductStockCount(
                      cartProducts.elementAt(i).product.id!.toString()))
                  .toDouble() ??
              0.0;
          double orderStock =
              (cartProducts.elementAt(i).quantity) * (variant.unit!.toDouble());
          if (currentStock >= orderStock) {
            double newStockValue = currentStock - orderStock;
            await productRepo.updateStock(product.id!, newStockValue);
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    }

    return true;
  }

  Future<Product?> getProductById(int productId) async {
    List<Product> productList = await productRepo.getProductById(productId);
    if (productList.isNotEmpty) {
      return productList[0];
    } else {
      return null;
    }
  }

  Future<Variant?> getVariantById(int variantId) async {
    List<Variant> productList = await productRepo.getVariantsById(variantId);
    if (productList.isNotEmpty) {
      return productList[0];
    } else {
      return null;
    }
  }

  getPrice(int variantId, num price) {
    if (variantItem.containsKey(variantId)) {
      return variantItem[variantId]! * price.toDouble();
    } else {
      return 0;
    }
  }
}
