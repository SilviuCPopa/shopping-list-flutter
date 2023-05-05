import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopping_list/services/products/product.service.dart';
import 'package:shopping_list/utils/dialog.dart';

class AddQuantityWidget {
  BuildContext context;
  ShoppingProductService shoppingProductService = new ShoppingProductService();
  int currentQuantity = 1;

  AddQuantityWidget(this.context, {this.currentQuantity = 1});

  Future<void> showDialog(Function callback) {
    return CustomDialog(AppLocalizations.of(context).quantity + ': ').showGeneralDialog(
        context, 
        Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0), 
            child: _content()
          ),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _customConfirmActions(callback)),
          )
        ]),
        showActions: false
      );
  }

  Widget _content() {
    return StreamBuilder<int>(
      initialData: 1,
      stream: shoppingProductService.getQuantity,
      builder: (context, snapshot) {
        return Container(
          margin: EdgeInsets.only(bottom: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 45,
                height: 45,
                child: FloatingActionButton(
                  onPressed: () {
                    currentQuantity = currentQuantity > 1 ? currentQuantity - 1 : 1;
                    shoppingProductService.updateQuantity(currentQuantity);
                  },
                  child: Icon(Icons.horizontal_rule, color: Colors.black),
                  backgroundColor: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(currentQuantity.toString(),
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 3.0)),
              ),
              Container(
                width: 45,
                height: 45,
                child: FloatingActionButton(
                  onPressed: () {
                    currentQuantity++;
                    shoppingProductService.updateQuantity(currentQuantity);
                  },
                  child: Icon(Icons.add, color: Colors.black),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      }
    );
  }

    List<Widget> _customConfirmActions(Function callback) {
    return <Widget>[
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.black,
              primary: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 21.0),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0))),
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () {
            shoppingProductService.updateQuantity(1);
            callback(DialogActions.cancel, 1);
          }),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 21.0),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0))),
          child: Text(AppLocalizations.of(context).confirm),
          onPressed: () {
            shoppingProductService.updateQuantity(1);
            int quantity = currentQuantity;
            callback(DialogActions.confirm, quantity);
          })
    ];
  }
}
