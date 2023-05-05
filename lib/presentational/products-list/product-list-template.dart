import 'package:flutter/material.dart';
import 'package:shopping_list/commons/price.dart';
import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/presentational/products-list/product-list.interface.dart';
import 'package:shopping_list/services/products/product.service.dart';
import 'package:shopping_list/utils/add-quantity.dart';
import 'package:shopping_list/utils/circular-spinner.dart';
import 'package:shopping_list/utils/dialog.dart';
import 'package:shopping_list/utils/image.helper.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class ProductListTemplate extends StatelessWidget
    implements ProductListInterface {
  final shoppingProductService = new ShoppingProductService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ShoppingProductModel>>(
        initialData: [],
        stream: shoppingProductService.shoppingProducts,
        builder: (context, products) {
          List<ShoppingProductModel> productsList = getProducts(products.data);

          if (products.connectionState == ConnectionState.waiting) {
            return CircularSpinner();
          }

          if (productsList.isEmpty) {
            return this.emptyResults(context);
          }

          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 2, left: 10, bottom: 6),
              ),
              Expanded(
                child: ListView(
                    children: productsList.asMap().entries.map((item) {
                  return Dismissible(
                    background: slideRightBackground(context),
                    secondaryBackground: slideLeftBackground(context),
                    key: Key(Uuid().v1()),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        onSlideRightAction(context, item.value);
                      } else {
                        onSlideLeftAction(context, item.value);
                      }
                    },
                    child: InkWell(
                      child: Container(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.only(left: 4.0, right: 6.0),
                                width: 70,
                                height: 70,
                                child:
                                    ImageHelper.getImage(item.value.imageUrl),
                              ),
                              Flexible(
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: item.key == 0
                                          ? BorderSide(
                                              color: Colors.grey,
                                              width: 0.3,
                                            )
                                          : BorderSide(color: Colors.transparent),
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text(item.value.title.trim(),
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          textAlign: TextAlign.start,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 4),
                                                        child: Text(
                                                            '${item.value.quantity.toString()} ${AppLocalizations.of(context).items}',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .red))),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 6.0),
                                              child: PriceWidget(
                                                  _calculatePrice(item.value))),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      onTap: () {
                        _changeQuantity(context, item.value);
                      },
                    ),
                  );
                }).toList()),
              ),
              bottomBarWidget(context),
            ],
          );
        });
  }

  bottomBarWidget(BuildContext context) {
    return Container(height: 1);
  }

  _calculatePrice(ShoppingProductModel item) {
    return (item.quantity * double.parse(item.price.replaceAll(',', '.')))
        .toStringAsFixed(2);
  }

  _changeQuantity(BuildContext context, ShoppingProductModel item) {
    AddQuantityWidget(context, currentQuantity: item.quantity)
        .showDialog((DialogActions action, int quantity) {
      if (action == DialogActions.confirm) {
        shoppingProductService.updateItemQuantity(item, quantity);
      }
      Navigator.of(context).pop();
    });
  }
}
