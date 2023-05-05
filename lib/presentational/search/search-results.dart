import 'package:flutter/material.dart';
import 'package:shopping_list/commons/price.dart';
import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/services/products/product.service.dart';
import 'package:shopping_list/services/search/search-products.service.dart';
import 'package:shopping_list/utils/add-quantity.dart';
import 'package:shopping_list/utils/dialog.dart';
import 'package:shopping_list/utils/image.helper.dart';

// ignore: must_be_immutable
class SearchResultsWidget extends StatefulWidget {
  String query;

  SearchResultsWidget(this.query);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResultsWidget> {
  final SearchService _searchService = new SearchService();
  final ShoppingProductService _shoppingProductService =
      new ShoppingProductService();
  List<ShoppingProductModel> searchedList = [];

  @override
  Widget build(BuildContext context) {
    searchedList = _searchService.search(widget.query);
    return Column(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5),
          scrollDirection: Axis.horizontal,
          child: Row(
              children: _searchService.categories.map((category) {
            if (widget.query.length > 0 &&
                _searchService.categories.length > 1) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                child: ChoiceChip(
                  label: Text(category),
                  selected:
                      _searchService.selectedCategories.indexOf(category) >= 0,
                  onSelected: (bool selected) {
                    if (selected) {
                      _searchService.selectedCategories.add(category);
                    } else {
                      _searchService.selectedCategories.remove(category);
                    }
                    setState(() {});
                  },
                ),
              );
            } else {
              return Container();
            }
          }).toList()),
        ),
        Expanded(
          child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children:
                  _searchService.filterByCategory(searchedList).map((item) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.2,
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListTile(
                          leading: ImageHelper.getImage(item.imageUrl),
                          title: Text(item.title,
                              maxLines: 3, overflow: TextOverflow.ellipsis),
                          trailing: PriceWidget(item.price, color: Colors.red),
                          onTap: () {
                            AddQuantityWidget(context).showDialog(
                                (DialogActions action, int quantity) {
                              if (action == DialogActions.confirm) {
                                item.quantity = quantity;
                                _shoppingProductService.addItem(item);
                              }
                              Navigator.of(context).pop();
                            });
                          })),
                );
              }).toList()),
        ),
      ],
    );
  }
}
