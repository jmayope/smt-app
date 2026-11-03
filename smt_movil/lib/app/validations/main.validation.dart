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
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'El correo electrónico es necesario';
  }
  return null;
}

String? validateDocumentNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'El Número de Documento es obligatorio';
  }
  return null;
}

String? validateFirstName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Los nombres son necesarios';
  }
  return null;
}

String? validateLastName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Los apellidos son necesarios';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es necesaria';
  }
  return null;
}

String? validateConfirmPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La confirmación de contrseña es necesaria';
  }
  return null;
}