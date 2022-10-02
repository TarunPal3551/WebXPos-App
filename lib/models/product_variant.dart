import 'package:webx_pos/models/variant.dart';

class ProductData {
  int? id;
  String? name;
  String? desc;
  num? stockCount;
  List<Variant>? variants;

  ProductData({this.id, this.name, this.desc, this.stockCount, this.variants});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    stockCount = json['stock_count'];

    if (json['variants'] != null) {
      variants = <Variant>[];
      json['variants'].forEach((v) {
        variants!.add(Variant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['desc'] = desc;
    data['stock_count'] = stockCount;

    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
