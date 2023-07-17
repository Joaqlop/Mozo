import 'package:flutter/material.dart';
import 'package:mozo_app/helpers/validator.dart';
import 'package:mozo_app/providers/providers.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final urlForm = Provider.of<LoginProvider>(context);

    return Form(
      key: urlForm.urlKey,
      child: TextFormField(
        onChanged: (value) => urlForm.requestUrl = value,
        validator: validateUrl,
        cursorColor: const Color(0xff3e4253),
        keyboardType: TextInputType.url,
        style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
        decoration: _loginDecoration(),
      ),
    );
  }

  InputDecoration _loginDecoration() => InputDecoration(
        prefixIcon: const Icon(Icons.insert_link_rounded, size: 20),
        prefixIconColor: const Color(0xff3e4253),
        hintText: 'Obligatorio',
        hintStyle: const TextStyle(
          fontSize: 13,
          color: Color(0xff3e4253),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xff212330)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xff4f5464)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
      );
}
