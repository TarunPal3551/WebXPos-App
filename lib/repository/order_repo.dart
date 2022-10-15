import 'package:flutter/material.dart';
import 'package:webx_pos/database/database_handler.dart';

import '../models/order_model.dart';

class OrderRepo {
  final dbHelper = DatabaseHandler.instance;

  Future<List<OrderModel>> getOrderList(
      {required DateTime startDate, DateTime? endDate}) async {
    List<Map<String, dynamic>> orderListData =
        await dbHelper.getDataFromTable(DatabaseHandler.ordersTable);
    List<OrderModel> orderList = [];
    for (int i = 0; i < orderListData.length; i++) {
      print(compareStartAndEndDate(
          startDate: startDate,
          endDate: endDate,
          orderDate: orderListData.elementAt(i)[DatabaseHandler.createAt]));
      if (compareStartAndEndDate(
          startDate: startDate,
          endDate: endDate,
          orderDate: orderListData.elementAt(i)[DatabaseHandler.createAt])) {
        List<Map<String, Object?>> orderItemListData =
            await dbHelper.getDataFromTable(DatabaseHandler.orderItemsTable,
                whereColumnName: DatabaseHandler.columnOrderId,
                value: orderListData
                    .elementAt(i)[DatabaseHandler.columnId]
                    .toString());
        Map<String, dynamic> orderData = Map.of(orderListData[i]);
        orderData['orderItems'] = orderItemListData;
        orderList.add(OrderModel.fromJson(orderData));
      } else {}
    }

    return orderList;
  }

  bool compareStartAndEndDate(
      {required String orderDate,
      required DateTime startDate,
      DateTime? endDate}) {
    DateTime orderCreatedAt = DateUtils.dateOnly(DateTime.parse(orderDate));
    if (endDate != null) {
      int count = 0;
      if (DateUtils.dateOnly(orderCreatedAt).isAtSameMomentAs(startDate) ||
          DateUtils.dateOnly(orderCreatedAt).isAfter(startDate)) {
        count++;
      }
      if (orderCreatedAt.isBefore(DateUtils.dateOnly(endDate)) ||
          endDate.isAtSameMomentAs(DateUtils.dateOnly(orderCreatedAt))) {
        count++;
      }
      if (count > 1) {
        return true;
      }

      return false;
    } else {
      return DateUtils.dateOnly(orderCreatedAt).isAtSameMomentAs(DateUtils.dateOnly(startDate));
    }
  }
}
