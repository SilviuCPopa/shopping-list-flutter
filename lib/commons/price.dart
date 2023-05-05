import 'package:flutter/material.dart';
import 'package:shopping_list/services/settings/settings.service.dart';

class PriceWidget extends StatelessWidget {
  final _settingsService = new SettingsService();
  final String _price;
  final Color color;

  final double euro = 4.9;
  final double usd = 4.0;

  PriceWidget(this._price, {this.color});

  @override
  Widget build(BuildContext context) {
    return Text(_calculatePrice(),
        textAlign: TextAlign.right,
        style: TextStyle(
            color: color,
            fontFamily: 'DancingScript',
            fontWeight: FontWeight.w600,
            fontSize: 12));
  }

  String _calculatePrice() {
    String price = _price.replaceAll(",", ".");
    switch (_settingsService.currency) {
      case Currencies.euro:
        return (double.parse(price) / euro).toStringAsFixed(2) + " €";
      case Currencies.usd:
        return (double.parse(price) / usd).toStringAsFixed(2) + " \$";
      default:
        return price + ' RON';
    }
  }
}
