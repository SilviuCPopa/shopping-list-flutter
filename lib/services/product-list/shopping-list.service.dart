import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/services/products/product.service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ShoppingListService {
  // ignore: close_sinks
  final shoppingList$ = BehaviorSubject<List<ShoppingListModel>>();
  final _shoopingItemsKey = 'shopping-items';
  List<ShoppingListModel> shoppingList = [];
  static final ShoppingListService _singleton = ShoppingListService._internal();
  final ShoppingProductService _shoppingProductService =
      new ShoppingProductService();

  factory ShoppingListService() {
    return _singleton;
  }

  ShoppingListService._internal();

  init() {
    _setShoppingListItems();
  }

  _setShoppingListItems() async {
    final items = await this._getShoppingItems();
    this.shoppingList = items;
      this.shoppingList$.add(items);
  }

  renameItem(ShoppingListModel item, String title) {
    final index = this.shoppingList.indexWhere((element) => element.title == item.title);
    item.title = title;
    this.shoppingList[index] = item;
    this._updateItems();
  }

  deleteItem(ShoppingListModel item) {
    this.shoppingList.remove(item);
    _shoppingProductService.removeItems(item.id);
    this._updateItems();
  }

  addItem(ShoppingListModel item) {
    this.shoppingList.add(item);
    this._updateItems();
  }

  _updateItems() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonList = jsonEncode(this.shoppingList);
    prefs.setString(this._shoopingItemsKey, jsonList);
    this.shoppingList$.add(shoppingList);
  }

  Future<List<ShoppingListModel>> _getShoppingItems() async {
    final prefs = await SharedPreferences.getInstance();
    final pref = prefs.getString(this._shoopingItemsKey);
    if (pref != null) {
      Iterable data = json.decode(prefs.getString(this._shoopingItemsKey));
      return List<ShoppingListModel>.from(
          data.map((model) => ShoppingListModel.fromJson(model)));
    } else {
      return [];
    }
  }
}
