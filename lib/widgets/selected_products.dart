import 'package:flutter/material.dart';

import 'package:mozo_app/providers/providers.dart';
import 'package:provider/provider.dart';

class SelectedProducts extends StatelessWidget {
  const SelectedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final style = TextStyle(color: Colors.grey.shade300);
    final selecteds = Provider.of<SelectedProductProvider>(context);
    final product = Provider.of<ProductProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xff1a1a24),
            child: Icon(
              Icons.horizontal_rule_rounded,
              color: Colors.grey.shade300,
              size: 40,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            color: const Color(0xff1a1a24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width / 3,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xff232333).withOpacity(0.5),
                  ),
                  child: Text(
                    r'Total: $' '${selecteds.total.toStringAsFixed(2)}',
                    style: style,
                  ),
                ),
                MaterialButton(
                  elevation: 0,
                  height: 45,
                  color: selecteds.haveAnything
                      ? Colors.red.shade800
                      : const Color(0xff232333).withOpacity(0.5),
                  onPressed: selecteds.haveAnything
                      ? () {
                          selecteds.removeEverything();
                          Navigator.pop(context);
                        }
                      : () {},
                  child: Text(
                    'Eliminar todo',
                    style: style,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: ListView.builder(
              itemCount: selecteds.selectedProducts.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  title: Text(
                    selecteds.selectedProducts[i].name,
                    style: style,
                  ),
                  subtitle: Text(
                    'x${selecteds.selectedProducts[i].qty}',
                    style: const TextStyle(
                      color: Color(0xff3e4253),
                    ),
                  ),
                  leading: Text(
                    r'$' '${selecteds.selectedProducts[i].price}',
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                  ),
                  trailing: IconButton(
                    highlightColor: Colors.red.shade800,
                    icon: Icon(Icons.close, color: Colors.grey.shade300),
                    onPressed: selecteds.haveAnything
                        ? () {
                            final index = product.productList.indexWhere((e) =>
                                e.name == selecteds.selectedProducts[i].name);
                            selecteds.removeProduct(
                              selecteds.selectedProducts[i].name,
                              product.productList[index].price,
                              selecteds.selectedProducts[i].promox2,
                              selecteds.selectedProducts[i].promox3,
                            );
                          }
                        : () {},
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
