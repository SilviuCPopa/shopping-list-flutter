import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopping_list/commons/price.dart';
import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/presentational/shopping-item/shopping-products-list.dart';
import 'package:shopping_list/services/product-list/shopping-list.service.dart';
import 'package:shopping_list/services/settings/settings.service.dart';
import 'package:shopping_list/utils/dialog.dart';
import 'package:shopping_list/utils/empty-result.dart';
import 'package:shopping_list/utils/placeholder-list-item.dart';
import 'package:shopping_list/utils/snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

class ShoppingItemList extends StatefulWidget {
  ShoppingItemList(BuildContext context);

  @override
  _ShoppingItemListState createState() => _ShoppingItemListState();
}

class _ShoppingItemListState extends State<ShoppingItemList> {
  List<ShoppingListModel> shoppingList = [];
  final shoppingListService = new ShoppingListService();
  final _settingsService = new SettingsService();

  initState() {
    super.initState();
    shoppingListService.init();
  }

  @override
  Widget build(BuildContext context) {
    final _renameItemController = TextEditingController();

    return StreamBuilder<List<ShoppingListModel>>(
        initialData: [],
        stream: shoppingListService.shoppingList$,
        builder: (BuildContext context,
            AsyncSnapshot<List<ShoppingListModel>> snapshot) {
          if (snapshot.data.isEmpty) {
            return EmptyResults(
                title: AppLocalizations.of(context).emptyShoppingListMessage);
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, position) {
              return FutureBuilder<ShoppingListModel>(
                  future: snapshot.data[position].init(),
                  builder: (BuildContext context,
                      AsyncSnapshot<ShoppingListModel> itemSnapshot) {
                    if (!itemSnapshot.hasData) {
                      return PlaceholderListItem();
                    }
                    var item = itemSnapshot.data;
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_cart,
                                      size: 30, color: Colors.red),
                                ],
                              ),
                              title: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Text(item.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.w600))),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.access_time, size: 12),
                                      Text(
                                          ' ' +
                                              timeago.format(
                                                  item.lastModifiedDate,
                                                  locale:
                                                      _settingsService.locale),
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Container(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  PriceWidget(item.totalPrice,
                                      color: Colors.red),
                                  Text(
                                      '${item.totalItems} ${AppLocalizations.of(context).items}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400))
                                ],
                              )),
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            ShoppingProductsListPage(
                                                listId: item.id,
                                                title: item.title)))
                                    .then((value) => setState(() {}));
                              }),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                            caption: AppLocalizations.of(context).rename,
                            color: Colors.green,
                            icon: Icons.more_horiz,
                            onTap: () {
                              _renameItemController.text = item.title;
                              CustomDialog(
                                      AppLocalizations.of(context).renameItem,
                                      controller: _renameItemController)
                                  .showAddItemDialog(context, (action) {
                                if (action == DialogActions.confirm) {
                                  shoppingListService.renameItem(
                                      item, _renameItemController.text);

                                  Snackbar.showSnackbar(
                                      context,
                                      AppLocalizations.of(context)
                                          .renameShoppingListItemMessage);
                                }
                              });
                            }),
                        IconSlideAction(
                            caption: AppLocalizations.of(context).delete,
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              CustomDialog(
                                      AppLocalizations.of(context).deleteItem,
                                      subtitle: AppLocalizations.of(context)
                                              .removeItemConfirmation +
                                          ' "${item.title}"')
                                  .showConfirmDialog(context, (action) {
                                if (action == DialogActions.confirm) {
                                  shoppingListService.deleteItem(item);
                                  Snackbar.showSnackbar(
                                      context,
                                      '"${item.title}" ' +
                                          AppLocalizations.of(context)
                                              .removeShoppingListItemMessage);
                                }
                              });
                            }),
                      ],
                    );
                  });
            },
          );
        });
  }
}
