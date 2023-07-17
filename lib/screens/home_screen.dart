import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mozo_app/providers/providers.dart';

import 'package:mozo_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedProducts = Provider.of<SelectedProductProvider>(context);
    final url = Provider.of<LoginProvider>(context).requestUrl;
    final printer = Provider.of<PrinterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'mozo',
          style: GoogleFonts.alegreyaSansSc(
            color: const Color(0xfffefefe),
            fontSize: 30,
          ),
        ),
        actions: [
          _menuOptions(url, printer.savedPrinter, printer.havePrinter),
        ],
      ),
      body: _HomeBody(),
      bottomNavigationBar: HomeBottomAppBar(
        total: selectedProducts.total,
        qty: selectedProducts.qtySelected,
        haveAnything: selectedProducts.haveAnything,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Imprimir'),
        onPressed: () {
          Navigator.pushNamed(context, 'print');
        },
      ),
    );
  }

  PopupMenuButton<dynamic> _menuOptions(
      String url, String printer, bool havePrinter) {
    return PopupMenuButton(
      surfaceTintColor: const Color(0xff232333),
      color: const Color(0xff232333),
      icon: const Icon(
        Icons.more_vert,
        color: Color(0xfffefefe),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xff1a1a24),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Database',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      url,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Impresora',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    havePrinter
                        ? Text(printer, textAlign: TextAlign.center)
                        : const Text(
                            'Sin dispositivo seleccionado',
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            tileColor: Colors.transparent,
            leading: Icon(
              Icons.logout_outlined,
              color: Colors.grey.shade300,
            ),
            title: Text(
              'Salir',
              style: TextStyle(color: Colors.grey.shade300),
            ),
            onTap: () {
              Provider.of<ProductProvider>(context, listen: false).exit();
              Provider.of<SelectedProductProvider>(context, listen: false)
                  .removeEverything();
              Provider.of<LoginProvider>(context, listen: false).urlKey =
                  GlobalKey();
              Provider.of<PrinterProvider>(context, listen: false)
                  .removeSavedPrinter();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login', (route) => false);
            },
          ),
        ),
      ],
    );
  }
}

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context);
    final size = MediaQuery.of(context).size;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      scrollDirection: Axis.horizontal,
      itemCount: products.productList.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: size.height / 6,
        mainAxisExtent: size.width / 2.2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (_, i) => ProductCard(product: products.productList[i]),
    );
  }
}
