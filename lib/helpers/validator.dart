String? validateUrl(String? value) {
  final pattern = RegExp(
    r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
  );

  if (value?.isEmpty ?? false) {
    return 'Este campo no puede estar vacío';
  }

  if (!pattern.hasMatch(value ?? '')) {
    return 'Ingrese una URL válida';
  }

  if (!value!.startsWith('http')) {
    return 'La URL debe contener el prefijo HTTP';
  }

  if (!value.endsWith('.json')) {
    return 'No se encontró archivo json';
  }

  return null;
}
