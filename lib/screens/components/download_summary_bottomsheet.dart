import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx_pos/controllers/summary_controller.dart';
import 'package:webx_pos/models/download_range_enum.dart';
import 'package:webx_pos/screens/common_widget/custom_button.dart';
import 'package:webx_pos/screens/common_widget/my_text_field.dart';
import 'package:webx_pos/utils/webx_colors.dart';
import 'package:webx_pos/utils/webx_constant.dart';
import 'package:webx_pos/utils/webx_helper.dart';

class DownloadSummaryBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (context) {
        return SummaryController();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Download sale summary ",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  "Select a summary period",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
            title: const Text("Today (12:00 AM - Now)"),
            value: DownloadRange.TODAY,
            groupValue: Provider.of<SummaryController>(context).selectedRange,
            onChanged: (DownloadRange? value) {
              Provider.of<SummaryController>(context, listen: false)
                  .changeDateRange(value!);
            },
          ),
          RadioListTile(
            title: const Text("Yesterday"),
            value: DownloadRange.YESTERDAY,
            groupValue: Provider.of<SummaryController>(context).selectedRange,
            onChanged: (DownloadRange? value) {
              Provider.of<SummaryController>(context, listen: false)
                  .changeDateRange(value!);
            },
          ),
          RadioListTile(
            title: const Text("Last week"),
            value: DownloadRange.LASTWEEK,
            groupValue: Provider.of<SummaryController>(context).selectedRange,
            onChanged: (DownloadRange? value) {
              Provider.of<SummaryController>(context, listen: false)
                  .changeDateRange(value!);
            },
          ),
          RadioListTile(
            title: const Text("Last month"),
            value: DownloadRange.LASTMONTH,
            groupValue: Provider.of<SummaryController>(context).selectedRange,
            onChanged: (DownloadRange? value) {
              Provider.of<SummaryController>(context, listen: false)
                  .changeDateRange(value!);
            },
          ),
          // RadioListTile(
          //   title: Text(
          //       "Last financial year (${DateTime.now().year - 1} - ${DateTime.now().year})"),
          //   value: DownloadRange.LASTYEAR,
          //   groupValue: Provider.of<SummaryController>(context).selectedRange,
          //   onChanged: (DownloadRange? value) {
          //     Provider.of<SummaryController>(context, listen: false)
          //         .changeDateRange(value!);
          //   },
          // ),
          RadioListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Custom date range"),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 10, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: MyTextField(
                          borderRadius: 5,
                          readOnly: true,
                          borderColor: WebXColor.grey,
                          labelText: 'Start date',
                          defaultValue: WebXConstant.formatDate(
                              Provider.of<SummaryController>(context)
                                  .startDate
                                  .toIso8601String()),
                          onChanged: (value) {},
                          showTrailingWidget: false,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: MyTextField(
                          borderRadius: 5,
                          readOnly: true,
                          defaultValue: WebXConstant.formatDate(
                              Provider.of<SummaryController>(context)
                                  .startDate
                                  .toIso8601String()),
                          borderColor: WebXColor.grey,
                          showTrailingWidget: false,
                          labelText: 'End date',
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            value: DownloadRange.CUSTOM,
            groupValue: Provider.of<SummaryController>(context).selectedRange,
            onChanged: (DownloadRange? value) {
              Provider.of<SummaryController>(context, listen: false)
                  .changeDateRange(value!);
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {},
                    text: "Download",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
