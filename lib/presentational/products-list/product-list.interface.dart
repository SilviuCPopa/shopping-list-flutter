
import 'package:flutter/material.dart';
import 'package:shopping_list/models/shopping.models.dart';

abstract class ProductListInterface {
  List<ShoppingProductModel> getProducts(List<ShoppingProductModel> list);
  Widget slideLeftBackground(BuildContext context);
  Widget slideRightBackground(BuildContext context);
  Widget bottomBarWidget(BuildContext context);
  Widget emptyResults(BuildContext context);
  void onSlideLeftAction(BuildContext context, ShoppingProductModel item);
  void onSlideRightAction(BuildContext context, ShoppingProductModel item);
}