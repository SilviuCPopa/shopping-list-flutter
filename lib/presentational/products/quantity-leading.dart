import 'package:flutter/material.dart';
import 'package:shopping_list/models/shopping.models.dart';
import 'package:shopping_list/services/products/product.service.dart';

class ProductQuantityLeading extends StatelessWidget {
  final ShoppingProductModel item;
  final shoppingProductService = new ShoppingProductService();

  ProductQuantityLeading(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          margin: EdgeInsets.only(right: 6.0, left: 2),
          width: 28,
          height: 25,
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle,
          //   border: Border.all(
          //     color: Colors.red,
          //     width: 2,
          //   ),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.quantity.toString() + ' X ',
                style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red),
              ),
            ],
          )),
    );
  }
}
