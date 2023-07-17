import 'package:flutter/material.dart';
import 'package:mozo_app/providers/providers.dart';
import 'package:provider/provider.dart';

class SavedUrls extends StatelessWidget {
  const SavedUrls({super.key, required this.saved});

  final List<String> saved;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: Colors.grey.shade300);

    final product = Provider.of<ProductProvider>(context);
    final url = Provider.of<LoginProvider>(context);
    final savedUrl = Provider.of<SavedUrlProvider>(context);

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
                  'Links Guardados',
                  style: style,
                ),
                MaterialButton(
                  elevation: 0,
                  height: 45,
                  color: Colors
                      .red.shade800, //const Color(0xfffe4a55).withOpacity(0.7),
                  child: Text(
                    'Eliminar todo',
                    style: style,
                  ),
                  onPressed: () {
                    savedUrl.removeEverything();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: ListView.builder(
              itemCount: saved.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  splashColor: Colors.green.shade700,
                  title: Text(saved[i], style: style),
                  leading:
                      const Icon(Icons.link_outlined, color: Color(0xff3e4253)),
                  trailing: IconButton(
                    highlightColor: Colors.red.shade800,
                    icon: Icon(Icons.close, color: Colors.grey.shade300),
                    onPressed: () {
                      savedUrl.removeUrl(saved[i]);
                    },
                  ),
                  onTap: () {
                    saved[i] = url.requestUrl;
                    product.getProducts(saved[i]);
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'home', (route) => false);
                    //Navigator.pushReplacementNamed(context, 'home');
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
