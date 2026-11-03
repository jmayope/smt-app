import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smt_movil/app/data/constants.dart';
import 'package:smt_movil/app/data/supabase.service.dart';
import 'package:smt_movil/app/routes/app_pages.dart';
import 'package:smt_movil/models/index.dart';

class RegisterController extends GetxController {

  final ruc = TextEditingController();
  final documentNumber = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final showPassword = false.obs;
  final confirmPassword = TextEditingController();
  final acceptTerms = false.obs;
  final isValid = false.obs;
  final canContinue = false.obs;
  final userExists = false.obs;
  final companySelected = Company().obs;
  final userCreated = User().obs;

  final businessName = TextEditingController();
  final businessTypes = <TableType>[].obs;
  final businessTypeSelected = TableType().obs;
  final businessAddress = TextEditingController();
  final businessPhone = TextEditingController();

  final isNewCompany = false.obs;
  final loading = true.obs;
  final validatingEntity = false.obs;
  final validatingUser = false.obs;
  final registering = false.obs;

  final supabase = Get.put(SupabaseService());

  // Uso de GlobalFormState
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    getInitialData();
  }

  Future<void> getInitialData() async {
    businessTypes.value = [
      TableType(code: "TRANSPORTE MINERO", name: "TRANSPORTE MINERO"),
      TableType(code: "TRANSPORTE DE CARGA", name: "TRANSPORTE DE CARGA"),
      TableType(code: "LOGISTICA", name: "LOGISTICA"),
      TableType(code: "OPERACIONES", name: "OPERACIONES"),
    ];
    businessTypeSelected.value = businessTypes.first;
    loading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> goToLogin() async {
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    if (password.value.text != confirmPassword.value.text) {
      Get.snackbar("Validación", "Las contraseñas deben ser iguales");
      registering.value = false;
    }
    if (registering.value) return;
    registering.value = true;

    if (isNewCompany.value) {
      final newCompany = {
        "name": businessName.value.text,
        "business_type": businessTypeSelected.value.code,
        "ruc": ruc.value.text,
        "phone": businessPhone.value.text,
        "address": businessAddress.value.text,
        "is_active": false
      };
      final resultCompany = await supabase.insert(COMPANIES, newCompany);
      List<Company> companyCreateds = (resultCompany as Iterable).map((c) => Company.fromJson(c)).toList();
      if (companyCreateds.isEmpty) {
        Get.snackbar("Error", "Hubo un error al momento de crear la Empresa");
        return;
      }
      companySelected.value = companyCreateds.first;
    }

    if (!userExists.value) {
      final newUser = {
        "company_id": companySelected.value.id,
        "email": email.value.text,
        "password_hash": password.value.text,
        "first_name": firstName.value.text,
        "last_name": lastName.value.text,
        "document_id" : documentNumber.value.text,
        "phone": phone.value.text,
        "role": isNewCompany.value ? 'administrador_empresa' : 'asociado',
        "is_active": false,
        "has_2fa": false
      };

      final resultUser = await supabase.insert(USERS, newUser);
      List<User> userCreateds = (resultUser as Iterable).map((u) => User.fromJson(u)).toList();
      if (userCreateds.isEmpty) {
        Get.snackbar("Error", "Hubo un error al momento de crear el Usuario");
        return;
      }
      userCreated.value = userCreateds.first;
    }

    final newUserCompanyRole = {
      "user_id": userCreated.value.id,
      "company_id": companySelected.value.id,
      "role": isNewCompany.value ? "admin" : "viewer",
      "is_active": true,
      "has_access_all": isNewCompany.value
    };
    print(newUserCompanyRole);

    final resultUserCompanyRole = await supabase.insert(USER_COMPANY_ROLES, newUserCompanyRole);
    
    if ((resultUserCompanyRole as Iterable).isEmpty) {
      Get.snackbar("Error", "Hubo un error al momento de crear el Rol del Usuario en la Empresa");
      return;
    }
    registering.value = false;
    Get.snackbar("Éxito", isNewCompany.value ? "Se creó la empresa y el Usuario. Espere la validación" : "Se creó correctamente el usuario.");
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> validateUser() async {
    userExists.value = false;
    if (documentNumber.value.text.isEmpty) {
      Get.snackbar("Validación", "Necesitas ingresar el número de documento para validar el usuario.");
      return;
    }

    if (validatingUser.value) return;
    validatingUser.value = true;

    final resultUser = await supabase.select(USERS, filters: {"document_id": documentNumber.value.text});
    if ((resultUser as Iterable).isEmpty) {
      canContinue.value = true;
      Get.snackbar("Validación", "Ingrese los datos del usuario");
      return;
    }
    Get.snackbar("Validación", "El usuario ya existe. La empresa validará su asociación");
    List<User> userFounds = (resultUser as Iterable).map((u) => User.fromJson(u)).toList();
    User user = userFounds.first;
    firstName.value = TextEditingValue(text: user.firstName!);
    lastName.value = TextEditingValue(text: user.lastName!);
    email.value = TextEditingValue(text: user.email!);
    userCreated.value = user;
    userExists.value = true;
  }

  Future<void> validateEntity() async {
    print(ruc.value.text);
    if (ruc.value.text.isEmpty) {
      Get.snackbar("Validación", "Necesitas ingresar el ruc para validar la empresa.");
      return;
    }
    if (validatingEntity.value) return;
    validatingEntity.value = true;

    final resultEntity = await supabase.select(COMPANIES, filters: {"ruc": ruc.value.text});
    validatingEntity.value = false;
    List<Company> companiesFound = (resultEntity as Iterable).map((c) => Company.fromJson(c)).toList();
    if (companiesFound.isEmpty) {
      isNewCompany.value = true;
      Get.snackbar("Es nueva Empresa", "Pasa a rellenar la información de la Empresa y Representante Legal.");
    } else {
      isNewCompany.value = false;
      companySelected.value = companiesFound.first;
      Get.snackbar("Empresa existente", "Los datos del nuevo usuario serán validados por el Administrador de la Empresa.");
    }
    isValid.value = true;
    
  }

}
