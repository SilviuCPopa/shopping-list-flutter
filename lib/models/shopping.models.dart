import 'package:shopping_list/services/products/product.service.dart';
import 'package:uuid/uuid.dart';

enum ListCategory { active, bought }

class ShoppingListModel {
  String id;
  String title;
  DateTime createdDate;
  DateTime lastModifiedDate;
  String totalPrice = '0.0';
  int totalItems = 0;
  ShoppingProductService _activeShoppingProductService =
      new ShoppingProductService();

  ShoppingListModel(
      {this.id,
      this.title,
      this.totalItems,
      this.totalPrice,
      this.createdDate,
      this.lastModifiedDate}) {
    this.id = id ?? Uuid().v1();
  }

  Future<ShoppingListModel> init() async {
    await setTotalPrice();
    await setTotalItems();
    return this;
  }

  Future<void> setTotalPrice() async {
    final total =
        await _activeShoppingProductService.calculateTotalByListItem(this.id);
    this.totalPrice = total.toStringAsFixed(2);
  }

  Future<void> setTotalItems() async {
    this.totalItems =
        await _activeShoppingProductService.getNumberOfItemsById(this.id);
  }

  Map toJson() {
    return {
      'id': id,
      'title': title,
      'createdDate': createdDate.toString(),
      'lastModifiedDate': lastModifiedDate.toString(),
      "totalItems": totalItems,
      "totalPrice": totalPrice
    };
  }

  static fromJson(json) {
    return new ShoppingListModel(
        id: json['id'],
        title: json['title'],
        totalItems: json['totalItems'],
        totalPrice: json['totalPrice'],
        createdDate: DateTime.parse(json['createdDate']),
        lastModifiedDate: DateTime.parse(json['lastModifiedDate']));
  }
}

class ShoppingProductModel implements Comparable<ShoppingProductModel> {
  String id;
  String title;
  String price;
  String category;
  int quantity;
  String imageUrl;
  String listId;
  bool bought = false;

  ShoppingProductModel(
      {this.id,
      this.title,
      this.price,
      this.category,
      this.imageUrl,
      this.listId,
      this.bought,
      this.quantity}) {
    this.id = id ?? Uuid().v1();
    this.bought = bought ?? false;
  }

  markAsBought() {
    this.bought = true;
  }

  markAsActive() {
    this.bought = false;
  }

  Map toJson() {
    return {
      'id': id ?? '',
      'title': title,
      'price': price,
      'category': category,
      'quantity': quantity,
      'image': imageUrl,
      'listId': listId,
      'bought': bought,
    };
  }

  static fromJson(json) {
    return new ShoppingProductModel(
      id: json['id'] ?? '',
      title: json['title'],
      price: json['price'],
      category: json['category'],
      quantity: json['quantity'],
      imageUrl: json['image'],
      bought: json['bought'],
    );
  }

  ShoppingProductModel.clone(ShoppingProductModel object)
      : this(
            id: object.id,
            title: object.title,
            price: object.price,
            category: object.category,
            quantity: object.quantity,
            imageUrl: object.imageUrl,
            bought: object.bought);

  @override
  int compareTo(ShoppingProductModel other) {
    return this.title.compareTo(other.title);
  }
}

class ProductInfoData {
  int totalItems;
  double _totalPrice;

  ProductInfoData(this.totalItems, this._totalPrice);

  get totalPrice => _totalPrice.toStringAsFixed(2);
}

class TabInfoData {
  int totalPendingItems;
  int totalBoughtItems;

  TabInfoData(this.totalPendingItems, this.totalBoughtItems);
}
