class Product {
  Product({
    int? id,
    String? name,
    String? desc,
    int? productId,
    double? price,
    double? stockCount,
  }) {
    _id = id;
    _name = name;
    _desc = desc;
    _productId = productId;
    _price = price;
    _stockCount = stockCount;
  }

  Product.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _desc = json['desc'];
    _productId = json['product_id'];
    _price = json['price'];
    _stockCount = json['stock_count'];

  }

  int? _id;
  String? _name;
  String? _desc;
  int? _productId;
  double? _price;
  num? _stockCount;


  int? get id => _id;

  String? get name => _name;

  String? get desc => _desc;

  int? get productId => _productId;

  double? get price => _price;

  num? get stockCount => _stockCount;



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['desc'] = _desc;
    map['product_id'] = _productId;
    map['price'] = _price;
    map['stock_count'] = _stockCount;
    return map;
  }
}


