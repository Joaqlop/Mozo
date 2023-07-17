import 'package:flutter/material.dart';
import 'package:mozo_app/models/models.dart';
import 'package:mozo_app/providers/providers.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final selectedProduct = Provider.of<SelectedProductProvider>(context);

    return Stack(
      children: [
        MaterialButton(
          minWidth: double.infinity,
          height: double.infinity,
          elevation: 0,
          highlightElevation: 0,
          color: const Color(0xff232333).withOpacity(0.5),
          splashColor: Colors.red.shade800,
          highlightColor: Colors.red.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.close,
              size: 22,
              color: Colors.grey.shade400,
            ),
          ),
          onPressed: () {
            selectedProduct.removeProduct(
                product.name, product.price, product.promox2, product.promox3);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
          child: MaterialButton(
            minWidth: 130,
            color: const Color(0xff1a1a24),
            textColor: Colors.grey.shade500,
            splashColor: const Color(0xff232333),
            highlightColor: const Color(0xff232333).withOpacity(0.5),
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Text(
                    r'$' + product.price.toString(),
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            onPressed: () {
              selectedProduct.addProduct(product.name, product.price,
                  product.promox2, product.promox3);
            },
          ),
        ),
      ],
    );
  }
}
