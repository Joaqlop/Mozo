import 'package:flutter/material.dart';
import 'package:mozo_app/widgets/widgets.dart';

class HomeBottomAppBar extends StatelessWidget {
  const HomeBottomAppBar({
    super.key,
    required this.total,
    required this.qty,
    required this.haveAnything,
  });

  final int total;
  final int qty;
  final bool haveAnything;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(color: Colors.grey.shade300);
    return BottomAppBar(
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 200),
      elevation: 0,
      height: 70,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff232333).withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$qty Producto(s)', style: style),
                Text(r'Total: $' '${total.toStringAsFixed(2)}', style: style),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_up_outlined,
                color: Colors.grey.shade300,
              ),
              onPressed: haveAnything
                  ? () {
                      showModalBottomSheet(
                        elevation: 0,
                        context: context,
                        builder: (_) => const SelectedProducts(),
                      );
                    }
                  : () {},
            ),
            //const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
