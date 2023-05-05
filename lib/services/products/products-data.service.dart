import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shopping_list/models/shopping.models.dart';

class ProductDataService {
  List<ShoppingProductModel> shoppingProducts = [];

  static final ProductDataService _singleton = ProductDataService._internal();
  factory ProductDataService() {
    return _singleton;
  }
  ProductDataService._internal();

  loadData() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = json.decode(response);
    shoppingProducts = List<ShoppingProductModel>.from(
        data.map((model) => ShoppingProductModel.fromJson(model)));
  }
}
