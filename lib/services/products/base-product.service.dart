import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/services/products/product.interface.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseProductService implements ProductService {
  List<ShoppingProductModel> shoppingProductsList;
  Stream<bool> get isLoading => _productLoadingSubject.stream;
  final _productLoadingSubject = BehaviorSubject<bool>();
  String _prefKey = '';

  set prefKey(String key) {
    this._prefKey = key;
  }

  addItem(ShoppingProductModel item) async {
    if (_isItemInList(item)) {
      updateItemInList(item);
    } else {
      shoppingProductsList.add(item);
    }
    updatePreferences();
    updateItems();
  }

  updateItemQuantity(ShoppingProductModel item, int quantity) {
    int index = getItemIndexInList(item, bought: item.bought);
    shoppingProductsList[index].quantity = quantity;
    updatePreferences();
    updateItems();
  }

  updatePreferences() async {
    await _setPrefferences(shoppingProductsList);
  }

  removeItem(ShoppingProductModel item) {
    int index = getItemIndexInList(item, bought: item.bought);
    this.shoppingProductsList.removeAt(index);
    updateItems();
    updatePreferences();
  }

  removeActiveItemIfExists(ShoppingProductModel item) {
    int index = getItemIndexInList(item, bought: false);
    if (index > 0) {
      shoppingProductsList.removeAt(index);
    }
  }

  bool _isItemInList(ShoppingProductModel item, {bool bought = false}) {
    return shoppingProductsList.length > 0 &&
        getItemIndexInList(item, bought: bought) > 0;
  }

  int getItemIndexInList(ShoppingProductModel item, {@required bool bought}) {
    return shoppingProductsList.indexWhere(
        (element) => element.title == item.title && element.bought == bought);
  }

  updateItemInList(ShoppingProductModel item) {
    int index = getItemIndexInList(item, bought: false);
    if (index >= 0) {
      item.quantity += shoppingProductsList[index].quantity;
      shoppingProductsList[index] = item;
    }
  }

  updateBoughtItems(ShoppingProductModel item, {bool bought = true}) {
    int index = getItemIndexInList(item, bought: bought);
    if (index >= 0) {
      item.quantity += shoppingProductsList[index].quantity;
      shoppingProductsList[index] = item;
    } else {
      shoppingProductsList.add(item);
    }

    updateItems();
    updatePreferences();
  }

  _setPrefferences(List<ShoppingProductModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonList = jsonEncode(list);
    prefs.setString(_prefKey, jsonList);
  }

  Future<List<ShoppingProductModel>> getShoppingProducts(
      {String listId}) async {
    _productLoadingSubject.add(true);
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(listId ?? _prefKey);
    _productLoadingSubject.add(false);
    if (jsonStr != null) {
      Iterable data = json.decode(jsonStr);
      return List<ShoppingProductModel>.from(
          data.map((model) => ShoppingProductModel.fromJson(model)));
    }
    return [];
  }

  List<ShoppingProductModel> filterProductsByCategory(List<ShoppingProductModel> list, ListCategory category) {
    if (list != null) {
      list.sort();
      return list.where((element) {
        if (category == ListCategory.bought) {
          return element.bought == true;
        }
        return element.bought == false;
      }).toList();
    }
    return [];
  }

  void dispose() {
    _productLoadingSubject.close();
  }

  @override
  void updateItems() {
    return;
  }
}
