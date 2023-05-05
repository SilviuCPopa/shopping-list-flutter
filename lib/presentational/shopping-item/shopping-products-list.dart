import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/presentational/products/boght-list.dart';
import 'package:shopping_list/presentational/products/pending-list.dart';
import 'package:shopping_list/presentational/products/product-status-bar.dart';
import 'package:shopping_list/presentational/search/search.dart';
import 'package:shopping_list/services/products/product.service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopping_list/utils/product-search-delegate.dart';

class ShoppingProductsListPage extends StatefulWidget {
  final String title;
  final String listId;
  final _activeShoppingProductService = new ShoppingProductService();

  ShoppingProductsListPage({Key key, this.title, this.listId})
      : super(key: key) {
    _activeShoppingProductService.init(listId);
  }

  @override
  _ShoppingProductState createState() => _ShoppingProductState();
}

class _ShoppingProductState extends State<ShoppingProductsListPage>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      ListCategory category =
          _tabController.index == 0 ? ListCategory.active : ListCategory.bought;
      widget._activeShoppingProductService.currentCategory.add(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                  child: Center(
                child: Text('${widget.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold)),
              ))
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            // labelColor: Colors.black,
            tabs: [
              Tab(
                child: StreamBuilder<TabInfoData>(
                    initialData: new TabInfoData(0, 0),
                    stream: widget._activeShoppingProductService.getTabInfoData,
                    builder: (context, tabInfo) {
                      return Badge(
                          animationType: BadgeAnimationType.fade,
                          badgeColor: Colors.yellow,
                          badgeContent: Text(
                              tabInfo.data.totalPendingItems.toString(),
                              style: TextStyle(color: Colors.black)),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(AppLocalizations.of(context).pending),
                          ));
                    }),
              ),
              Tab(
                child: StreamBuilder<TabInfoData>(
                    initialData: new TabInfoData(0, 0),
                    stream: widget._activeShoppingProductService.getTabInfoData,
                    builder: (context, snapshot) {
                      return Badge(
                          animationType: BadgeAnimationType.fade,
                          badgeColor: Colors.red,
                          badgeContent: Text(
                              snapshot.data.totalBoughtItems.toString(),
                              style: TextStyle(color: Colors.white)),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(AppLocalizations.of(context).bought),
                          ));
                    }),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showCustomSearch(
                    context: context, delegate: SearchPage(widget.listId));
              },
            ),
          ],
        ),
        bottomNavigationBar: ProductStatusBarWidget(),
        body: Container(
          padding: EdgeInsets.only(top: 3),
          child: Column(
            children: [
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: [
                  PendingProductListWidget(),
                  BoughtProductListWidget(),
                ],
              )),
            ],
          ),
        )
        // }),
        );
  }
}
