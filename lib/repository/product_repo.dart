import 'package:webx_pos/database/database_handler.dart';
import 'package:webx_pos/models/order_model.dart';
import 'package:webx_pos/models/product.dart';
import 'package:webx_pos/models/product_variant.dart';
import 'package:webx_pos/models/variant.dart';

class ProductRepo {
  final dbHelper = DatabaseHandler.instance;

  Future<int> addProduct(String name, String desc) async {
    return await dbHelper.insert(DatabaseHandler.productTable, data: {
      DatabaseHandler.columnName: name,
      DatabaseHandler.columnDesc: desc
    });
  }

  // update Product
  Future<int> updateProduct(int id, {Map<String, dynamic>? updateData}) async {
    return await dbHelper.updateData(DatabaseHandler.productTable, id,
        data: updateData);
  }

  // variants
  Future<int> addVariants(
      {required String name,
      required String price,
      required String unit,
      required int productId}) async {
    return await dbHelper.insert(DatabaseHandler.variantsTable, data: {
      DatabaseHandler.columnName: name,
      DatabaseHandler.columnDesc: name,
      DatabaseHandler.columnUnitValue: unit,
      DatabaseHandler.columnPrice: price,
      DatabaseHandler.columnProductId: productId
    });
  }

  // get products
  Future<List<Product>> getProducts() async {
    List<Map<String, dynamic?>> data =
        await dbHelper.getDataFromTable(DatabaseHandler.productTable);
    List<Product> productList = [];
    data.forEach((element) {
      productList.add(Product.fromJson(element));
    });

    return productList;
  }

  Future<List<Product>> getProductById(int productId) async {
    List<Map<String, dynamic?>> data = await dbHelper.getDataFromTable(
        DatabaseHandler.productTable,
        whereColumnName: DatabaseHandler.columnId,
        value: productId.toString());
    List<Product> productList = [];
    data.forEach((element) {
      productList.add(Product.fromJson(element));
    });
    return productList;
  }

  Future<List<Variant>> getVariantsById(int variantId) async {
    List<Map<String, dynamic?>> data = await dbHelper.getDataFromTable(
        DatabaseHandler.variantsTable,
        whereColumnName: DatabaseHandler.columnId,
        value: variantId.toString());
    List<Variant> productList = [];
    data.forEach((element) {
      productList.add(Variant.fromJson(element));
    });

    return productList;
  }

  // get variants
  Future<void> getVariants() async {
    List<Map<String, dynamic?>> variantData =
        await dbHelper.getDataFromTable(DatabaseHandler.variantsTable);
    List<Variant> variant = [];
    variantData.forEach((element) {
      variant.add(Variant.fromJson(element));
    });
  }

  Future<List<ProductData>> productWithVariant() async {
    List<Map<String, dynamic>> productData =
        await dbHelper.getDataFromTable(DatabaseHandler.productTable);
    List<ProductData> finalList = [];
    for (int i = 0; i < productData.length; i++) {
      List<Map<String, dynamic>> variantData = await dbHelper.getDataFromTable(
          DatabaseHandler.variantsTable,
          whereColumnName: DatabaseHandler.columnProductId,
          value: productData[i]['id'].toString());
      
      final newData = Map.of(productData[i]);
      newData['variants'] = variantData ?? [];
      
      
      finalList.add(ProductData.fromJson(newData));
    }
    
    return finalList;
  }

  Future<void> deleteProduct(int id) async {
    await dbHelper.deleteData(DatabaseHandler.productTable, id);
  }

  // create order
  Future<void> createOrder(Map<String, dynamic> orderData) async {
    await dbHelper.insert(DatabaseHandler.ordersTable, data: orderData);
  }

  // add orderItem
  Future<void> createOrderItem(Map<String, dynamic> orderItems) async {
    await dbHelper.insert(DatabaseHandler.orderItemsTable, data: orderItems);
  }

  // get order list
  Future<List<OrderModel>> getOrderList() async {
    List<Map<String, dynamic>> orderListData =
        await dbHelper.getDataFromTable(DatabaseHandler.ordersTable);
    List<OrderModel> orderList = [];
    for (int i = 0; i < orderListData.length; i++) {
      List<Map<String, Object?>> orderItemListData =
          await dbHelper.getDataFromTable(DatabaseHandler.orderItemsTable,
              whereColumnName: DatabaseHandler.columnOrderId,
              value: orderListData
                  .elementAt(i)[DatabaseHandler.columnId]
                  .toString());

      Map<String, dynamic> orderData = Map.of(orderListData[i]);
      orderData['orderItems'] = orderItemListData;
      orderList.add(OrderModel.fromJson(orderData));
    }
    
    return orderList;
  }
}
