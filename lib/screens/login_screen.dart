import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mozo_app/providers/providers.dart';

import 'package:mozo_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String stateMessage = '';
  @override
  void initState() {
    super.initState();
    Provider.of<SavedUrlProvider>(context, listen: false).loadUrlDb();
  }

  @override
  Widget build(BuildContext context) {
    final urlForm = Provider.of<LoginProvider>(context);
    final product = Provider.of<ProductProvider>(context);
    final listUrl = Provider.of<SavedUrlProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          height: size.height * 0.7,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'mozo',
                style: GoogleFonts.alegreyaSansSc(
                    color: Colors.white, fontSize: 60),
              ),
              const SizedBox(height: 50),
              Text(
                'Bienvenido!',
                style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Ingrese una URL a su base de datos.',
                style: TextStyle(color: Color(0xff3e4253)),
              ),
              const LoginForm(),
              Text(
                stateMessage,
                style: TextStyle(color: Colors.red.shade800, fontSize: 13),
              ),
              const SizedBox(height: 50),
              MaterialButton(
                minWidth: size.width * 0.8,
                elevation: 0,
                highlightElevation: 0,
                color: Colors.indigo,
                splashColor: Colors.indigo.shade800,
                highlightColor: Colors.indigo.shade800,
                onPressed: product.isLoading
                    ? () {}
                    : () async {
                        stateMessage = '';
                        FocusScope.of(context).unfocus();
                        if (!urlForm.isValid()) return;

                        await product.getProducts(urlForm.requestUrl);
                        if (product.productList.isEmpty) {
                          stateMessage = 'No se encontró base de datos';
                          return;
                        }

                        listUrl.saveUrl(urlForm.requestUrl);
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, 'home');
                      },
                child: product.isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                        ),
                      )
                    : Text(
                        'Ingresar',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                        ),
                      ),
              ),
              MaterialButton(
                minWidth: size.width * 0.8,
                elevation: 0,
                highlightElevation: 0,
                color: const Color(0xff232333).withOpacity(0.5),
                highlightColor: const Color(0xff1a1a24).withOpacity(0.5),
                splashColor: const Color(0xff1a1a24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: listUrl.haveAnything
                    ? () {
                        showModalBottomSheet(
                          elevation: 0,
                          context: context,
                          builder: (_) => const SavedUrls(),
                        );
                      }
                    : () {},
                child: const Text(
                  'Guardados',
                  style: TextStyle(color: Color(0xff4f5464)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
