String? validateUrl(String? value) {
  final pattern = RegExp(
    r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?',
  );

  if (value?.isEmpty ?? false) {
    return 'Este campo no puede estar vacío';
  }

  if (!pattern.hasMatch(value ?? '')) {
    return 'Ingrese una URL válida';
  }

  return null;
}
