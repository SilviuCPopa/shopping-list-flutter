import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/environments.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shopping_list/services/products/products-data.service.dart';

class SearchService {
  int searchMiliseconds = 500;
  int previousSearchLength = 0;
  ProductDataService productDataService = new ProductDataService();
  List<String> categories = [];
  List<String> selectedCategories = [];

  Stream<bool> get isLoading => _searchLoadingSubject.stream;
  final _searchLoadingSubject = BehaviorSubject<bool>();

  List<ShoppingProductModel> shoppingProductList = [];
  final _searchTerms = BehaviorSubject<String>();
  void searchTerm(String query) => _searchTerms.add(query);

  Stream<List<ShoppingProductModel>> results;

  SearchService() {
    results = _searchTerms
        .debounce(
            (_) => TimerStream(true, Duration(milliseconds: searchMiliseconds)))
        .switchMap((query) async* {
      yield search(query);
    });
  }

  Future<List<ShoppingProductModel>> makeSearch(String title) async {
    final foundProducts = _searchTitleInList(title);
    _resetDebounce();

    if (title.isEmpty) {
      searchMiliseconds = 500;
      shoppingProductList = [];
      return shoppingProductList;
    } else if (_canCallApi(title) || foundProducts.length == 0) {
      searchMiliseconds = 500;
      final productList = await searchOnApi(title);
      if (await _isNumberOfProductsChanged(productList)) {
        shoppingProductList = productList;
      }
      _resetDebounce();
      previousSearchLength = title.length;
      return shoppingProductList;
    } else {
      return foundProducts;
    }
  }

  List<ShoppingProductModel> search(String title) {
    if (productDataService.shoppingProducts == null || title.length == 0) {
      categories = [];
      selectedCategories = [];
      return [];
    }
    final results =
        productDataService.shoppingProducts.where((ShoppingProductModel item) {
      bool condition = false;
      title.split(' ').forEach((String value) {
        if (!item.title.toLowerCase().contains(value)) {
          condition = true;
        }
      });
      return !condition;
    }).toList();

    categories = _changeCategoriesOrder(results);
    return results;
  }

  List<String> _changeCategoriesOrder(List<ShoppingProductModel> products) {
    var categories =
        products.map((product) => product.category).toSet().toList();

    if (selectedCategories.length > 0) {
      List<String> filteredList = List.from(
          categories.where((value) => !selectedCategories.contains(value)));
      return List.from(selectedCategories)..addAll(filteredList);
    }
    return categories;
  }

  List<ShoppingProductModel> filterByCategory(products) {
    return products.where((item) {
      if (selectedCategories.length > 0) {
        return selectedCategories.indexOf(item.category) >= 0;
      } else {
        return true;
      }
    }).toList();
  }

  bool _canCallApi(String title) {
    return _searchContainsLessText(title) ||
        (shoppingProductList.isEmpty && title.isNotEmpty);
  }

  Future<bool> _isNumberOfProductsChanged(
      List<ShoppingProductModel> productList) async {
    return shoppingProductList.length != productList.length;
  }

  _resetDebounce() {
    searchMiliseconds = 70;
  }

  _searchContainsLessText(String title) {
    return title.length < previousSearchLength;
  }

  List<ShoppingProductModel> _searchTitleInList(String title) {
    return shoppingProductList
        .where((product) => _containTitle(title, product))
        .toList();
  }

  bool _containTitle(String title, ShoppingProductModel product) {
    bool flag = true;
    title.split(' ').forEach((element) {
      if (element.isNotEmpty) {
        if (!product.title.toLowerCase().contains(element)) {
          flag = false;
        }
      }
    });
    return flag;
  }

  Future<List<ShoppingProductModel>> searchOnApi(String title) async {
    final response =
        await http.get(Uri.http(API_URL, 'search', {'title': title}));
    final data = json.decode(response.body);
    return List<ShoppingProductModel>.from(
        data.map((model) => ShoppingProductModel.fromJson(model)));
  }

  dispose() {
    _searchLoadingSubject.close();
  }
}
