import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/presentational/products-list/product-list-template.dart';
import 'package:shopping_list/utils/empty-result.dart';

// ignore: must_be_immutable
class BoughtProductListWidget extends ProductListTemplate {

  @override
  List<ShoppingProductModel> getProducts(List<ShoppingProductModel> list) {
    return shoppingProductService.filterProductsByCategory(list, ListCategory.bought);
  }

  @override
  emptyResults(BuildContext context) {
    return EmptyResults(
        title: AppLocalizations.of(context).emptyBoughtShoppingProductMessage);
  }

  @override
  bottomBarWidget(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.all(7.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.orange, // background
          onPrimary: Colors.white, // foreground
        ),
        onPressed: () {
          shoppingProductService.restoreAllFromBought();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restore),
            Text(' ' + AppLocalizations.of(context).restoreAllProducts),
          ],
        ),
      ),
    );
  }

  Widget slideLeftBackground(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.restore,
              color: Colors.white,
            ),
            Text(
              ' ' + AppLocalizations.of(context).restore,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  @override
  void onSlideRightAction(BuildContext context, ShoppingProductModel item) {
    shoppingProductService.restoreFromBought(item);
    // rebuildStateIfListIsEmpty(context, category: ListCategory.bought);
  }

  @override
  void onSlideLeftAction(BuildContext context, ShoppingProductModel item) {
    shoppingProductService.removeItem(item);
    // rebuildStateIfListIsEmpty(context, category: ListCategory.bought);
  }
}
