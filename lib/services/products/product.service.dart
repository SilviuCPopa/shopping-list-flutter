import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/services/products/base-product.service.dart';
import 'package:shopping_list/services/products/product.interface.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingProductService extends BaseProductService
    implements ProductService {
  Stream<List<ShoppingProductModel>> get shoppingProducts =>
      _shoppingProductListSubject.stream;

  Stream<int> get getQuantity => _quantity.stream;
  Stream<TabInfoData> get getTabInfoData => _tabInfoData.stream;
  Stream<ListCategory> get getCurrentCategory => currentCategory.stream;
  Stream<ProductInfoData> get getProductInfo => _productInfoDataSubject.stream;

  final _shoppingProductListSubject =
      BehaviorSubject<List<ShoppingProductModel>>();
  final _productInfoDataSubject = BehaviorSubject<ProductInfoData>();
  final _quantity = BehaviorSubject<int>();
  final _tabInfoData = BehaviorSubject<TabInfoData>();
  final currentCategory = BehaviorSubject<ListCategory>();

  static final ShoppingProductService _singleton =
      ShoppingProductService._internal();
  factory ShoppingProductService() {
    return _singleton;
  }
  ShoppingProductService._internal();

  init(String listId) {
    prefKey = listId;
    shoppingProductsList = [];
    this.getShoppingProducts().then((value) {
      this.shoppingProductsList = value;
      updateItems();
    });

    _shoppingProductListSubject.listen((value) {
      _updateInfoData();
    });
  }

  get shoppingListSubject => _shoppingProductListSubject;

  Future<String> getTotal(String listId) async {
    final total = await calculateTotalByListItem(listId);
    return total.toStringAsFixed(2);
  }

  updateQuantity(int quantity) {
    _quantity.add(quantity);
  }

  markAsBought(ShoppingProductModel item) {
    final ShoppingProductModel clone = ShoppingProductModel.clone(item);
    clone.markAsBought();
    updateBoughtItems(clone);
    removeItem(item);
  }

  restoreAllFromBought() async {
    shoppingProductsList
        .where((element) => element.bought == true)
        .forEach((item) => item.bought = false);
    updateItems();
    updatePreferences();
  }

  restoreFromBought(ShoppingProductModel item) {
    final ShoppingProductModel clone = ShoppingProductModel.clone(item);
    clone.markAsActive();
    updateBoughtItems(clone, bought: false);
    removeItem(item);
  }

  @override
  updateItems() {
    this._shoppingProductListSubject.add(shoppingProductsList);
    this.currentCategory.add(ListCategory.active);
    this._tabInfoData.add(new TabInfoData(
      filterProductsByCategory(shoppingProductsList, ListCategory.active).length,
      filterProductsByCategory(shoppingProductsList, ListCategory.bought).length,
    ));
  }

  removeItems(String listId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(listId);
    shoppingProductsList = [];
  }

  _countProducts() {
    return shoppingProductsList.fold(
        0, (previousValue, element) => previousValue + element.quantity);
  }

  _updateInfoData() {
    if (shoppingProductsList != null && shoppingProductsList.length > 0) {
      final info = new ProductInfoData(_countProducts(), _calculateTotal());
      this._productInfoDataSubject.add(info);
    } else {
      this._productInfoDataSubject.add(new ProductInfoData(0, 0));
    }
  }

  double _calculateTotal() {
    return shoppingProductsList.fold(0, (t, element) {
      var parse = double.parse(element.price.replaceAll(',', '.'));
      return t + (element.quantity * parse);
    });
  }

  Future<double> calculateTotalByListItem(String listId) async {
    final list = await getShoppingProducts(listId: listId);
    double total = 0;
    if (list != null && list.isNotEmpty) {
      total = list.fold(0.0, (t, element) {
        var parse = double.parse(element.price.replaceAll(',', '.'));
        return t + (element.quantity * parse);
      });
    }
    return total;
  }

  Future<int> getNumberOfItemsById(String listId) async {
    final list = await getShoppingProducts(listId: listId);
    int total = 0;
    if (list != null && list.isNotEmpty) {
      total = list.fold(0, (t, element) {
        return t + (element.quantity);
      });
    }
    return total;
  }

  void dispose() {
    _quantity.close();
    _shoppingProductListSubject.close();
    _productInfoDataSubject.close();
    currentCategory.close();
    _tabInfoData.close();
  }
}
