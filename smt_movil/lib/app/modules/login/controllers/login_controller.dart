import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiver/core.dart';
import 'package:smt_movil/app/data/constants.dart';
import 'package:smt_movil/app/data/preference.service.dart';
import 'package:smt_movil/app/data/supabase.service.dart';
import 'package:smt_movil/app/routes/app_pages.dart';
import 'package:smt_movil/models/index.dart';

class LoginController extends GetxController {

  final email = TextEditingController();
  final password = TextEditingController();
  final showPassword = false.obs;
  final loading = true.obs;
  final logging = false.obs;
  
  final formKey = GlobalKey<FormState>();

  final supabase = Get.put(SupabaseService());

  @override
  void onInit() {
    super.onInit();
    getInitialData();
  }

  Future<void> getInitialData() async {
    loading.value = false;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    if (logging.value) return;
    logging.value = true;
    final credentials = {
      "email": email.value.text,
      "password_hash": password.value.text
    };

    final resultUserLoged = await supabase.select(USERS, filters: credentials);
    if ((resultUserLoged as Iterable).isEmpty) {
      Get.snackbar("Validación", "Correo Electrónico o Contraseña incorrectas.");
      logging.value = false;
      return;
    }
    List<User> userFounds = (resultUserLoged as Iterable).map((u) => User.fromJson(u)).toList();
    
    User userLoged = userFounds.first;
    if (!userLoged.isActive!) {
      logging.value = false;
      Get.snackbar("Validación", "El usuario no esta activo. Falta la validación correspondiente");
      return;
    }

    final resultUserCompanyRoles = await supabase.select(USER_COMPANY_ROLES, filters: {"user_id": userLoged.id});
    if ((resultUserCompanyRoles as Iterable).isEmpty) {
      logging.value = false;
      Get.snackbar("Validación", "El usuario no tiene Roles asignados.");
      return;
    }

    List<UserCompanyRole> userCompanyRoles = (resultUserCompanyRoles as Iterable).map((ucr) => UserCompanyRole.fromJson(ucr)).toList();
    print("userCompanyRoles.length");
    print(userCompanyRoles.length);
    final resultCompanies = await supabase.select(COMPANIES, filters: {"id": userCompanyRoles.map((c) => c.companyId).toSet().toList()});
    if ((resultCompanies as Iterable).isEmpty) {
      logging.value = false;
      Get.snackbar("Validación", "El usuario no tiene compañias asociadas.");
      return;
    }
    List<Company> companies = (resultCompanies as Iterable).map((c) => Company.fromJson(c)).toList();
    for (var i = 0; i < companies.length; i++) {
      Company company = companies[i];
      companies[i] = company.copyWith(roles: Optional.of(userCompanyRoles.where((ucr) => ucr.companyId == company.id).toList()));
      print("<<<<<<<<<<<<company.toJson()>>>>>>>>>>>>");
      print(company.toJson());
    }
    userLoged = userLoged.copyWith(companies: Optional.of(companies));
    bool userSaved = false;
    print(userLoged.toJson());
    if (userLoged.companies!.length == 1) {
      userLoged = userLoged.copyWith(currentCompany: Optional.of(userLoged.companies!.first));
      userSaved = await PreferenceService.setSession(userLoged);
      if (userLoged.currentCompany!.roles!.length == 1) {
        userLoged = userLoged.copyWith(currentRole: Optional.of(userLoged.currentCompany!.roles!.first));
        userSaved = await PreferenceService.setSession(userLoged);
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.SELECT_PROFILE);
      }
    } else {
      userSaved = await PreferenceService.setSession(userLoged);
      Get.offAllNamed(Routes.SELECT_COMPANY);
    }

    
  }

  Future<void> register() async {
    Get.offAllNamed(Routes.REGISTER);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


}
