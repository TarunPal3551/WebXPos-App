import 'package:flutter/material.dart';
import 'package:webx_pos/database/database_handler.dart';
import 'package:webx_pos/models/order_model.dart';
import 'package:webx_pos/models/product.dart';
import 'package:webx_pos/models/product_stock.dart';
import 'package:webx_pos/models/product_variant.dart';
import 'package:webx_pos/repository/order_repo.dart';
import 'package:webx_pos/repository/product_repo.dart';

class OrderController extends ChangeNotifier {
  List<OrderModel> orderList = [];
  OrderRepo orderRepo = OrderRepo();
  ProductRepo productRepo = ProductRepo();
  int totalSaleCount = 0;
  double totalSaleValue = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  List<ProductStock> productStock = [];

  Future<void> getOrderList(
      {required DateTime startDate, DateTime? endDate}) async {
    totalSaleValue = 0;
    Map<int, double> soldQuantityOfProduct = {};
    Map<int, double> soldValueOfProduct = {};
    await orderRepo
        .getOrderList(startDate: startDate, endDate: endDate)
        .then((value) async {
      orderList = value;
      totalSaleCount = orderList.length;
      notifyListeners();
      for (int i = 0; i < orderList.length; i++) {
        totalSaleValue =
            (totalSaleValue + orderList.elementAt(i).total!.toDouble());
        notifyListeners();
        List<OrderItems> orderItems = orderList.elementAt(i).orderItems!;
        for (int j = 0; j < orderItems.length; j++) {
          double soldCount = orderItems.elementAt(j).quantity!.toDouble() *
              orderItems.elementAt(j).unit!;
          double soldValue = orderItems.elementAt(j).quantity! *
              orderItems.elementAt(j).price!.toDouble();
          if (soldQuantityOfProduct
              .containsKey(orderItems.elementAt(j).productId!)) {
            double previousCount =
                soldQuantityOfProduct[orderItems.elementAt(j).productId!]!;
            double previousSoldValue =
                soldValueOfProduct[orderItems.elementAt(j).productId!]!;
            soldQuantityOfProduct[orderItems.elementAt(j).productId!] =
                previousCount + soldCount;
            soldValueOfProduct[orderItems.elementAt(j).productId!] =
                previousSoldValue + soldValue;
          } else {
            soldQuantityOfProduct[orderItems.elementAt(j).productId!] =
                soldCount;
            soldValueOfProduct[orderItems.elementAt(j).productId!] = soldValue;
          }
        }
      }
      for (int i = 0; i < soldQuantityOfProduct.length; i++) {
        List<Product> products = await productRepo
            .getProductById(soldQuantityOfProduct.entries.elementAt(i).key);
        if (products.isNotEmpty) {
          Product product = products.first;
          List<Map<String, dynamic>> value =
              await (productRepo.getProductAllStockCount(product.id!.toString(),
                  filterDate: startDate));
          for (int j = 0; j < value.length; j++) {
            DateTime orderCreatedAt = DateUtils.dateOnly(startDate);
            if (DateUtils.dateOnly(
                    DateTime.parse(value[j][DatabaseHandler.createAt]))
                .isAtSameMomentAs(orderCreatedAt)) {
              productStock.add(ProductStock(
                  product.name!,
                  value[j][DatabaseHandler.columnStockCount],
                  soldQuantityOfProduct.entries.elementAt(i).value,
                  product.id!,
                  soldValueOfProduct[product.id!]!,
                  startDate));
            }
          }
        }
        notifyListeners();
      }

      List<ProductData> listOfProducts = await productRepo.productWithVariant();
      for (int z = 0; z < listOfProducts.length; z++) {
        int indexWhere = productStock.indexWhere(
            (element) => element.productId == listOfProducts.elementAt(z).id);
        if (indexWhere == -1) {
          num value = await (productRepo.getProductStockCount(
              listOfProducts.elementAt(z).id!.toString(),
              filterDate: startDate));
          productStock.add(ProductStock(listOfProducts.elementAt(z).name!,
              value, 0, listOfProducts.elementAt(z).id!, 0, startDate));
        }
      }
      notifyListeners();
    });
  }
}
