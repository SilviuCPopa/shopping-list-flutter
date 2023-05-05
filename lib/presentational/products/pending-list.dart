import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopping_list/commons/price.dart';
import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/presentational/products-list/product-list-template.dart';
import 'package:shopping_list/utils/empty-result.dart';

// ignore: must_be_immutable
class PendingProductListWidget extends ProductListTemplate {
  static const _opacity = 0.6;
  static const _xOffset = 0.7;
  static const _yOffset = 0.8;
  static const _blurRadius = 8.0;
  static const _spreadRadius = 0.5;

  @override
  List<ShoppingProductModel> getProducts(List<ShoppingProductModel> list) {
    return shoppingProductService.filterProductsByCategory(list, ListCategory.active);
  }

  @override
  emptyResults(BuildContext context) {
    return EmptyResults(
        title: AppLocalizations.of(context).emptyShoppingProductMessage);
  }

  @override
  bottomBarWidget(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
        color: !darkModeOn ? Colors.white : Colors.transparent,
        boxShadow: [
        !darkModeOn ? BoxShadow(
          color: Color.fromRGBO(0, 0, 0, _opacity),
          offset: Offset(_xOffset, _yOffset),
          blurRadius: _blurRadius,
          spreadRadius: _spreadRadius,
        ) : BoxShadow(color: Colors.transparent)
      ],),
      height: 50, 
      child: StreamBuilder<ProductInfoData>(
          initialData: ProductInfoData(0, 0),
          stream: shoppingProductService.getProductInfo,
          builder: (context, AsyncSnapshot<ProductInfoData> snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${AppLocalizations.of(context).total}: ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    PriceWidget('${snapshot.data.totalPrice}', color: Colors.red)
                  ],
                )
              ],
            );
          }),
    );
  }

  @override
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

  @override
  Widget slideRightBackground(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.done,
              color: Colors.white,
            ),
            Text(
              ' ' + AppLocalizations.of(context).marksAsBought,
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
    shoppingProductService.markAsBought(item);
  }

  @override
  void onSlideLeftAction(BuildContext context, ShoppingProductModel item) {
    shoppingProductService.removeItem(item);
  }
}
