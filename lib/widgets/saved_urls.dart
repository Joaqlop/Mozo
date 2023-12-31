import 'package:flutter/material.dart';
import 'package:mozo_app/providers/providers.dart';
import 'package:provider/provider.dart';

class SavedUrls extends StatelessWidget {
  const SavedUrls({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context);
    final url = Provider.of<LoginProvider>(context);
    final listUrl = Provider.of<SavedUrlProvider>(context);

    final style = TextStyle(color: Colors.grey.shade300);

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
                Text(
                  'URLs Guardadas',
                  style: style,
                ),
                MaterialButton(
                  elevation: 0,
                  height: 45,
                  color: Colors.red.shade800,
                  child: Text(
                    'Eliminar todo',
                    style: style,
                  ),
                  onPressed: () {
                    listUrl.removeEverything();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: ListView.builder(
              itemCount: listUrl.savedUrl.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  splashColor: Colors.green.shade700,
                  title: Text(listUrl.savedUrl[i], style: style),
                  leading:
                      const Icon(Icons.link_outlined, color: Color(0xff3e4253)),
                  trailing: IconButton(
                    highlightColor: Colors.red.shade800,
                    icon: Icon(Icons.close, color: Colors.grey.shade300),
                    onPressed: () {
                      listUrl.removeUrl(listUrl.savedUrl[i]);
                    },
                  ),
                  onTap: () {
                    url.requestUrl = listUrl.savedUrl[i];
                    product.getProducts(listUrl.savedUrl[i]);
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'home', (route) => false);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
