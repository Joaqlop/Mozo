import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mozo_app/providers/providers.dart';

import 'package:mozo_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                'Ingrese una URL a su base de datos. ',
                style: TextStyle(color: Color(0xff3e4253)),
              ),
              const LoginForm(),
              const SizedBox(height: 50),
              MaterialButton(
                minWidth: size.width * 0.8,
                elevation: 0,
                color: Colors.indigo,
                onPressed: product.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (!urlForm.isValid()) return;
                        product.getProducts(urlForm.requestUrl);
                        listUrl.saveUrl(urlForm.requestUrl);

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
                highlightColor: const Color(0xff232333).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: listUrl.haveAnything
                    ? () {
                        showModalBottomSheet(
                          elevation: 0,
                          context: context,
                          builder: (_) => SavedUrls(saved: listUrl.savedUrl),
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
