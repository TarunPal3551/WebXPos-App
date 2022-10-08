import 'package:flutter/material.dart';

class WebXHelper {
  static bool compareStartAndEndDate(
      {required String orderDate,
      required DateTime startDate,
      DateTime? endDate}) {
    DateTime orderCreatedAt = DateUtils.dateOnly(DateTime.parse(orderDate));
    if (endDate != null) {
      int count = 0;
      if (DateUtils.dateOnly(startDate).isAtSameMomentAs(orderCreatedAt) ||
          DateUtils.dateOnly(startDate).isAfter(orderCreatedAt)) {
        count++;
      }
      if (orderCreatedAt.isBefore(DateUtils.dateOnly(endDate)) ||
          orderCreatedAt.isAtSameMomentAs(DateUtils.dateOnly(endDate))) {
        count++;
      }
      if (count > 1) {
        return true;
      }
      return false;
    } else {
      return DateUtils.dateOnly(startDate).isAtSameMomentAs(orderCreatedAt);
    }
  }
}
