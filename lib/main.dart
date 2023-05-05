import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/presentational/settings/settings.dart';
import 'package:shopping_list/presentational/shopping-item/shopping-item.dart';
import 'package:shopping_list/services/product-list/shopping-list.service.dart';
import 'package:shopping_list/services/products/products-data.service.dart';
import 'package:shopping_list/services/settings/settings.service.dart';
import 'package:shopping_list/utils/dialog.dart';
import 'package:shopping_list/utils/snackbar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _settingsService = new SettingsService();
ProductDataService _productDataService = new ProductDataService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _settingsService.init();
  _productDataService.loadData();
  timeago.setLocaleMessages('ro', timeago.RoMessages());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Settings>(
        initialData: Settings(Locale('en'), Currencies.ron),
        stream: _settingsService.currentSettings,
        builder: (context, localeSnapshot) {
          return MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
              const Locale('ro', ''),
            ],
            locale: localeSnapshot.data.locale,
            title: 'Shopping List',
            darkTheme: ThemeData(
              fontFamily: 'WorkSans',
              primarySwatch: Colors.red,
              tabBarTheme: TabBarTheme(labelColor: Colors.white),
              primaryTextTheme:
                  TextTheme(headline6: TextStyle(color: Colors.white)),
              brightness: Brightness.dark,
              appBarTheme: AppBarTheme(brightness: Brightness.dark),
            ),
            theme: ThemeData(
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  foregroundColor: Colors.white,
                ),
                fontFamily: 'WorkSans',
                primarySwatch: Colors.red,
                tabBarTheme: TabBarTheme(labelColor: Colors.black),
                appBarTheme: AppBarTheme(
                    brightness: Brightness.light, color: Colors.white),
                primaryIconTheme: Theme.of(context)
                    .primaryIconTheme
                    .copyWith(color: Colors.black),
                primaryTextTheme:
                    TextTheme(headline6: TextStyle(color: Colors.black))),
            home: MyHomePage(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _shoppingListItemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _shoppingListService = new ShoppingListService();
    _shoppingListService.init();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined), //color: Colors.black54),
            onPressed: () {
              SettingsPage(context).showSettings();
            },
          ),
        ],
        centerTitle: false,
        // backgroundColor: Colors.white,
        title: Text(AppLocalizations.of(context).appTitle,
            textAlign: TextAlign.left),
      ),
      body: ShoppingItemList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _shoppingListItemController.clear();
          CustomDialog(AppLocalizations.of(context).addNewShoppingListItem,
                  controller: _shoppingListItemController)
              .showAddItemDialog(context, (DialogActions action) {
            if (action == DialogActions.confirm) {
              _shoppingListService.addItem(new ShoppingListModel(
                title: _shoppingListItemController.text,
                createdDate: DateTime.now(),
                lastModifiedDate: DateTime.now(),
              ));
              Snackbar.showSnackbar(
                  context,
                  AppLocalizations.of(context)
                      .addNewShoppingItemSnackbarSuccessMessage);
            }
          });
        },
        tooltip: 'Increment',
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }
}
