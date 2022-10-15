import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webx_pos/controllers/order_controller.dart';
import 'package:webx_pos/database/database_handler.dart';
import 'package:webx_pos/models/download_range_enum.dart';
import 'package:webx_pos/models/order_model.dart';
import 'package:webx_pos/models/product.dart';
import 'package:webx_pos/models/product_stock.dart';
import 'package:webx_pos/models/product_variant.dart';
import 'package:webx_pos/repository/order_repo.dart';
import 'package:webx_pos/repository/product_repo.dart';
import 'package:webx_pos/utils/webx_helper.dart';

class SummaryController extends ChangeNotifier {
  DownloadRange selectedRange = DownloadRange.TODAY;
  DateTime startDate = DateUtils.dateOnly(DateTime.now());
  DateTime? endDate = DateUtils.dateOnly(DateTime.now());
  OrderController orderController = OrderController();
  OrderRepo orderRepo = OrderRepo();
  ProductRepo productRepo = ProductRepo();

  void changeDateRange(DownloadRange selectedValue) {
    startDate = DateTime.now();
    endDate = DateTime.now();
    selectedRange = selectedValue;
    if (selectedRange == DownloadRange.TODAY) {
      startDate = DateTime.now();
      endDate = null;
    } else if (selectedRange == DownloadRange.YESTERDAY) {
      startDate = DateTime.now().subtract(const Duration(days: 1));
      endDate = null;
    } else if (selectedRange == DownloadRange.LASTWEEK) {
      startDate = DateTime.now().subtract(Duration(
        days: (DateTime.now().weekday + 7),
      ));
      print("WEEK START");
      print(startDate);
      endDate = startDate.add(const Duration(days: 7));
      print("WEEK END");
      print(endDate);
    } else if (selectedRange == DownloadRange.LASTMONTH) {
      startDate = DateTime.now().subtract(Duration(
        days: (DateTime.now().day + 30),
      ));
      print("MONTH START");
      print(startDate);
      endDate = startDate.add(const Duration(days: 30));
      print("MONTH END");
      print(endDate);
    } else if (selectedRange == DownloadRange.CUSTOM) {
      startDate = DateTime.now().subtract(Duration(
        days: (DateTime.now().day + 30),
      ));
      print("MONTH START");
      print(startDate);
      endDate = startDate.add(const Duration(days: 30));
      print("MONTH END");
      print(endDate);
    }
    exportExcel();
    notifyListeners();
  }

  void exportExcel() {
    Map<String, Map<int, double>> soldQuantityOfProduct = {};
    Map<String, Map<int, double>> soldValueOfProduct = {};
    Map<String, List<ProductStock>> productStock = {};
    orderRepo
        .getOrderList(startDate: startDate, endDate: endDate)
        .then((orderList) async {
      for (int i = 0; i < orderList.length; i++) {
        OrderModel currentOrderModel = orderList.elementAt(i);
        String orderDate =
            DateUtils.dateOnly(DateTime.parse(currentOrderModel.createdAt!))
                .toString();
        if (!(soldQuantityOfProduct.containsKey(orderDate))) {
          soldQuantityOfProduct[orderDate] = {};
        }
        if (!(soldValueOfProduct.containsKey(orderDate))) {
          soldValueOfProduct[orderDate] = {};
        }
        if (!(productStock.containsKey(orderDate))) {
          productStock[orderDate] = [];
        }
        Map<int, double>? mapSoldQuantityOfProduct =
            soldQuantityOfProduct[orderDate] ?? {};
        Map<int, double>? mapSoldValueOfProduct =
            soldValueOfProduct[orderDate] ?? {};
        List<ProductStock> productStockList = productStock[orderDate] ?? [];
        List<OrderItems> orderItems = currentOrderModel.orderItems!;
        for (int j = 0; j < orderItems.length; j++) {
          double soldCount = orderItems.elementAt(j).quantity!.toDouble() *
              orderItems.elementAt(j).unit!;
          double soldValue = orderItems.elementAt(j).quantity! *
              orderItems.elementAt(j).price!.toDouble();
          if (soldQuantityOfProduct.containsKey(orderDate)) {
            if (mapSoldQuantityOfProduct
                .containsKey(orderItems.elementAt(j).productId!)) {
              double previousCount =
                  mapSoldQuantityOfProduct[orderItems.elementAt(j).productId!]!;
              double previousSoldValue =
                  mapSoldValueOfProduct[orderItems.elementAt(j).productId!]!;
              mapSoldValueOfProduct[orderItems.elementAt(j).productId!] =
                  previousCount + soldCount;
              mapSoldValueOfProduct[orderItems.elementAt(j).productId!] =
                  previousSoldValue + soldValue;
            } else {
              mapSoldQuantityOfProduct[orderItems.elementAt(j).productId!] =
                  soldCount;
              mapSoldValueOfProduct[orderItems.elementAt(j).productId!] =
                  soldValue;
            }
          }
        }
        for (int i = 0; i < mapSoldQuantityOfProduct.length; i++) {
          List<Product> products = await productRepo.getProductById(
              mapSoldQuantityOfProduct.entries.elementAt(i).key);
          if (products.isNotEmpty) {
            Product product = products.first;
            List<Map<String, dynamic>> value = await (productRepo
                .getProductAllStockCount(product.id!.toString(),
                    filterDate: DateUtils.dateOnly(DateTime.parse(orderDate))));
            for (int j = 0; j < value.length; j++) {
              DateTime orderCreatedAt =
                  DateUtils.dateOnly(DateTime.parse(orderDate));
              productStockList.add(ProductStock(
                  product.name!,
                  value[j][DatabaseHandler.columnStockCount],
                  mapSoldQuantityOfProduct.entries.elementAt(i).value,
                  product.id!,
                  mapSoldValueOfProduct[product.id!]!,
                  orderCreatedAt));
            }
          } else {
            print("PRODUCT IS EMPTY");
            // TODO
          }
        }
        // List<ProductData> listOfProducts =
        //     await productRepo.productWithVariant();
        // for (int z = 0; z < listOfProducts.length; z++) {
        //   int indexWhere = productStockList.indexWhere(
        //       (element) => element.productId == listOfProducts.elementAt(z).id);
        //   if (indexWhere == -1) {
        //     num value = await (productRepo.getProductStockCount(
        //         listOfProducts.elementAt(z).id!.toString(),
        //         filterDate: DateTime.parse(orderDate)));
        //     productStockList.add(ProductStock(
        //         listOfProducts.elementAt(z).name!,
        //         value,
        //         0,
        //         listOfProducts.elementAt(z).id!,
        //         0,
        //         DateTime.parse(orderDate)));
        //   }
        // }
      }
      print("sold Quantity" + soldQuantityOfProduct.toString());
      print("sold Value" + soldValueOfProduct.toString());
      print(productStock);
      downloadExcel(productStock);
      for (int i = 0; i < productStock.entries.length; i++) {
        print("Date " + productStock.entries.elementAt(i).key);
        String data = "Order Data";
        for (int j = 0;
            j < productStock.entries.elementAt(i).value.length;
            j++) {
          data = data +
              "\n" +
              productStock.entries.elementAt(i).value.elementAt(j).toString();
        }
        print(data);
      }
    });
  }

  Future<void> downloadExcel(
      Map<String, List<ProductStock>> productStock) async {
    List<List<String>> finalData = [
      ["No.", "Date", "Sold Quantity", "Left Stock", "Sale Value"],
    ];
    List<String> data = [];
    for (int j = 0; j < productStock.entries.length; j++) {
      final productList = productStock.entries.elementAt(j).value;
      for (int z = 0; z < productList.length; z++) {
        data.add(z.toString());
        data.add(productList.elementAt(z).createdAt.toString());
        data.add(productList.elementAt(z).soldStock.toString());
        data.add(productList.elementAt(z).soldSaleValue.toString());
        data.add(productList.elementAt(z).productName.toString());
        finalData.add(data);
      }
    }
    print(finalData.toString());
    String csvData = ListToCsvConverter().convert(finalData);
    print(csvData);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
  }
}
