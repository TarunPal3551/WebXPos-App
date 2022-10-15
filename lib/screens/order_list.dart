import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:webx_pos/controllers/order_controller.dart';
import 'package:webx_pos/models/download_range_enum.dart';
import 'package:webx_pos/screens/common_widget/my_text_field.dart';
import 'package:webx_pos/screens/common_widget/webx_textfield.dart';
import 'package:webx_pos/screens/common_widgets.dart';
import 'package:webx_pos/screens/components/download_summary_bottomsheet.dart';
import 'package:webx_pos/utils/utils_widget.dart';
import 'package:webx_pos/utils/webx_colors.dart';
import 'package:webx_pos/utils/webx_constant.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DateTime startDateTime = DateTime.now().subtract(const Duration(days: 0));
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 65,
        title: ChangeNotifierProvider(
            create: (context) => OrderController(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Sales Summary"),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  WebXConstant.formatDate(startDateTime.toIso8601String()),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            )),
        actions: [
          InkWell(
            child: Icon(Icons.download),
            onTap: () {
              DownloadRange selectedValue = DownloadRange.LASTYEAR;
              UtilsWidget.showWebXBottomSheet(
                  context, DownloadSummaryBottomSheet());
            },
          ),

          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => OrderController()
          ..getOrderList(
            startDate: startDateTime,
          ),
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 4,
                          margin:
                              const EdgeInsets.only(top: 0, left: 10, right: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "${context.watch<OrderController>().totalSaleCount}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: WebXColor.textColorPrimary),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text("Sale Count")
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin:
                              const EdgeInsets.only(top: 0, left: 5, right: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "${context.watch<OrderController>().totalSaleValue}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: WebXColor.textColorPrimary),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text("Sale Count")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Sales Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: DataTable(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            // 10% of the width, so there are ten blinds.
                            colors: <Color>[
                              WebXColor.backgroundColor,
                              WebXColor.backgroundColor,
                              WebXColor.backgroundColor
                            ],
                            // red to yellow
                            tileMode: TileMode
                                .repeated, // repeats the gradient over the canvas
                          ),
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(16)),
                      showCheckboxColumn: true,

                      sortAscending: true,
                      showBottomBorder: true,
                      sortColumnIndex: 3,
                      onSelectAll: (value) {},
                      columns: const [
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Product Name',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Sold',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Left',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Amount',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
                      ],
                      rows: context
                          .watch<OrderController>()
                          .productStock
                          .map(
                            (e) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(e.productName)),
                                DataCell(Text(e.soldStock.toString())),
                                DataCell(Text(e.currentStock.toString())),
                                DataCell(Text(e.soldSaleValue.toString())),
                              ],
                            ),
                          )
                          .toList()),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Order Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  itemBuilder: (contextList, index) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(WebXConstant.formatDateTime(context
                                        .watch<OrderController>()
                                        .orderList
                                        .elementAt(index)
                                        .createdAt!)),
                                    Text(
                                        "Order Id #${context.watch<OrderController>().orderList.elementAt(index).id}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        )),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                Text(
                                  "${WebXConstant.currencySymbol}${context.watch<OrderController>().orderList.elementAt(index).total}",
                                  style: const TextStyle(
                                      color: WebXColor.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(context
                                    .watch<OrderController>()
                                    .orderList
                                    .elementAt(index)
                                    .getOrderedItemString()),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: context.watch<OrderController>().orderList.length,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
