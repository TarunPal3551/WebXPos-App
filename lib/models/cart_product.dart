import 'package:webx_pos/models/product.dart';
import 'package:webx_pos/models/variant.dart';

class CartProduct {
  Product _product;
  Variant _variant;
  num quantity;

  Product get product => _product;

  set product(Product value) {
    _product = value;
  }

  Variant get variant => _variant;

  set variant(Variant value) {
    _variant = value;
  }

  CartProduct(this._product, this._variant,{required this.quantity});
}
