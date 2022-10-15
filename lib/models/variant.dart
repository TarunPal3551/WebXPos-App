class Variant {
  Variant({
    int? id,
    String? name,
    String? desc,
    int? productId,
    double? price,
    double? unit,
  }) {
    _id = id;
    _name = name;
    _desc = desc;
    _productId = productId;
    _price = price;
    _unit = unit;
  }

  Variant.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _desc = json['desc'];
    _productId = json['product_id'];
    try {
      _price = json['price'];
    } on Exception catch (e) {
      // TODO
      _price = 0.0;
    }
    try{
      _unit = json['unit'];
    }catch(e){
      _unit=0;
    }
  }

  int? _id;
  String? _name;
  String? _desc;
  int? _productId;
  num? _price;
  num? _unit;

  int? get id => _id;

  String? get name => _name;

  String? get desc => _desc;

  int? get productId => _productId;

  num? get price => _price;

  num? get unit => _unit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['desc'] = _desc;
    map['product_id'] = _productId;
    map['price'] = _price;
    map['unit'] = _unit;
    return map;
  }
}
