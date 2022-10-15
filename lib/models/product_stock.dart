class ProductStock {
  String productName;
  int productId;
  num currentStock;
  num soldStock;
  num soldSaleValue;
  DateTime? createdAt;

  ProductStock(this.productName, this.currentStock, this.soldStock,
      this.productId, this.soldSaleValue, this.createdAt);

  @override
  String toString() {
    return 'ProductStock{productName: $productName, productId: $productId, currentStock: $currentStock, soldStock: $soldStock, soldSaleValue: $soldSaleValue, createdAt: $createdAt}';
  }
}
