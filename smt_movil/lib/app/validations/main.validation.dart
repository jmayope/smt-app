String? validateRuc(String? value) {
  if (value == null || value.isEmpty) {
    return 'El Ruc es necesario';
  }
  if (value.length < 11) {
    return 'Mínimo 11 caracteres';
  }
  return null;
}

String? validateBusinessName(String? value) {
  if (value == null || value.isEmpty) {
    return 'La razon social es necesaria';
  }
  return null;
}

String? validateAddress(String? value) {
  if (value == null || value.isEmpty) {
    return 'La dirección es necesaria';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'El telefono es necesario';
  }
  final phone = value.trim();

  // Exactamente 9 dígitos, el primero debe ser 9
  final phoneRegex = RegExp(r'^9\d{8}$');

  if (!phoneRegex.hasMatch(phone)) {
    return 'Debe tener 9 dígitos y empezar con 9';
  }

  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'El correo electrónico es necesario';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value.trim())) {
    return 'Correo inválido';
  }
  return null;
}

String? validateDocumentNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'El Número de Documento es obligatorio';
  }
  if (value.length < 8) {
    return 'Mínimo 8 caracteres';
  }
  return null;
}

String? validateFirstName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Los nombres son necesarios';
  }
  if (value.length < 4) {
    return 'Mínimo 4 caracteres';
  }
  return null;
}

String? validateLastName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Los apellidos son necesarios';
  }
  if (value.length < 4) {
    return 'Mínimo 4 caracteres';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es necesaria';
  }
  if (value.length < 8) {
    return 'Mínimo 8 caracteres';
  }
  if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
    return 'Debe incluir al menos una letra';
  }
  if (!RegExp(r'\d').hasMatch(value)) {
    return 'Debe incluir al menos un número';
  }
  return null;
}

String? validateConfirmPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La confirmación de contrseña es necesaria';
  }
  if (value.length < 8) {
    return 'Mínimo 8 caracteres';
  }
  if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
    return 'Debe incluir al menos una letra';
  }
  if (!RegExp(r'\d').hasMatch(value)) {
    return 'Debe incluir al menos un número';
  }
  return null;
}