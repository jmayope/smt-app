import 'package:get/get.dart';
import 'package:quiver/core.dart';
import 'package:smt_movil/app/data/constants.dart';
import 'package:smt_movil/app/data/preference.service.dart';
import 'package:smt_movil/app/data/supabase.service.dart';
import 'package:smt_movil/app/routes/app_pages.dart';
import 'package:smt_movil/models/index.dart';

class UserProfileController extends GetxController {
  
  final userLoged = User().obs;
  final loading = true.obs;
  final subscriptionPackage = CompanySubscription().obs;
  final hasSubscriptionPackage = false.obs;

  final supabase = Get.put(SupabaseService());

  @override
  void onInit() {
    super.onInit();
    getInitialData();
  }

  Future<void> getInitialData() async {
    userLoged.value = await PreferenceService.getSession();

    final resultCompanySubscription = await supabase.select(COMPANY_SUBSCRIPTIONS, filters: {"company_id": userLoged.value.currentCompany!.id, "is_active": true});

    if ((resultCompanySubscription as Iterable).isEmpty) {
      Get.snackbar("Aviso", "No cuenta con un Paquete de Subscripción.");
      hasSubscriptionPackage.value = false;
    } else {
      hasSubscriptionPackage.value = true;
      subscriptionPackage.value = (resultCompanySubscription as Iterable).map((sp) => CompanySubscription.fromJson(sp)).toList().first;
      final resultSubscriptionPackage = await supabase.select(SUBSCRIPTION_PACKAGES, filters: {"id": subscriptionPackage.value.packageId});
      if ((resultSubscriptionPackage as Iterable).isEmpty) {
        Get.snackbar("Error", "No se encontró el Paquete de Subscripción de la Empresa");
      } else {
        subscriptionPackage.value = subscriptionPackage.value.copyWith(package: Optional.of((resultSubscriptionPackage as Iterable).map((sp) => SubscriptionPackage.fromJson(sp)).toList().first));
      }
    }

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

  Future<void> refreshData() async {

  }

  Future<void> goBack() async {
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> changePassword() async {

  }

  Future<void> logout() async {
    PreferenceService.clearAll();
    Get.offAllNamed(Routes.LOGIN);
  }

}
