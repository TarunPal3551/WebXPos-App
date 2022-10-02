class OrderModel {
  OrderModel({
    int? id,
    double? total,
    String? createdAt,
    String? updatedAt,
    List<OrderItems>? orderItems,
  }) {
    _id = id;
    _total = total;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _orderItems = orderItems;
  }

  OrderModel.fromJson(dynamic json) {
    _id = json['id'];
    _total = json['total'].runtimeType == String
        ? double.tryParse(json['total'])
        : json['total'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['orderItems'] != null) {
      _orderItems = [];
      json['orderItems'].forEach((v) {
        _orderItems?.add(OrderItems.fromJson(v));
      });
    }
  }

  int? _id;
  num? _total;
  String? _createdAt;
  String? _updatedAt;
  List<OrderItems>? _orderItems;

  int? get id => _id;

  num? get total => _total;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  List<OrderItems>? get orderItems => _orderItems;

  String getOrderedItemString() {
    String data = "";
    for (int i = 0; i < orderItems!.length; i++) {
      data = data +
          "${orderItems!.elementAt(i).productName} (${orderItems!.elementAt(i).variantName}) X ${orderItems!.elementAt(i).quantity}"
              " = ${orderItems!.elementAt(i).price!.toDouble() * orderItems!.elementAt(i).quantity!.toDouble()}";
      if (i != orderItems!.length - 1) {
        data = data + "\n";
      }
    }
    return data;
  }

  int geItemsCount() {
    int count = 0;
    orderItems!.forEach((element) {
      count = count + element.quantity!;
    });
    return count;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['total'] = _total;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_orderItems != null) {
      map['orderItems'] = _orderItems?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OrderItems {
  OrderItems({
    int? id,
    int? variantId,
    int? quantity,
    int? price,
    String? variantName,
    double? unit,
    int? orderId,
    int? productId,
    String? productName,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _variantId = variantId;
    _quantity = quantity;
    _price = price;
    _variantName = variantName;
    _unit = unit;
    _orderId = orderId;
    _productId = productId;
    _productName = productName;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  OrderItems.fromJson(dynamic json) {
    _id = json['id'];
    _variantId = json['variant_id'];
    _quantity = json['quantity'];
    _price = json['price'];
    _variantName = json['variant_name'];
    _unit = json['unit'];
    _orderId = json['order_id'];
    _productId = json['product_id'];
    _productName = json['product_name'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  int? _id;
  int? _variantId;
  int? _quantity;
  int? _price;
  String? _variantName;
  num? _unit;
  int? _orderId;
  int? _productId;
  String? _productName;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  int? get variantId => _variantId;

  int? get quantity => _quantity;

  int? get price => _price;

  String? get variantName => _variantName;

  num? get unit => _unit;

  int? get orderId => _orderId;

  int? get productId => _productId;

  String? get productName => _productName;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['variant_id'] = _variantId;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['variant_name'] = _variantName;
    map['unit'] = _unit;
    map['order_id'] = _orderId;
    map['product_id'] = _productId;
    map['product_name'] = _productName;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
