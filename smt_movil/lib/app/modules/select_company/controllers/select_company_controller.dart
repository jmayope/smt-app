import 'package:get/get.dart';
import 'package:quiver/core.dart';
import 'package:smt_movil/app/data/preference.service.dart';
import 'package:smt_movil/app/data/supabase.service.dart';
import 'package:smt_movil/app/routes/app_pages.dart';
import 'package:smt_movil/models/index.dart';

class SelectCompanyController extends GetxController {

  final userLoged = User().obs;
  final loading = true.obs;
  final supabase = Get.put(SupabaseService());
  final selectedIndex = int.parse('-1').obs;

  @override
  void onInit() {
    super.onInit();
    getInitialData();
  }

  Future<void> getInitialData() async {
    userLoged.value = await PreferenceService.getSession();

    loading.value = false;
  }

  Future<void> continueNext() async {
    bool userSaved = false;
    userLoged.value = userLoged.value.copyWith(currentCompany: Optional.of(userLoged.value.companies![selectedIndex.value]));
    userSaved = await PreferenceService.setSession(userLoged.value);
    if (userLoged.value.currentCompany!.roles!.length == 1) {
      userLoged.value = userLoged.value.copyWith(currentRole: Optional.of(userLoged.value.currentCompany!.roles!.first));
      userSaved = await PreferenceService.setSession(userLoged.value);
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.SELECT_PROFILE);
    }
  }

  Future<void> selectCompany(int index) async {
    selectedIndex.value = index;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> logout() async {
    PreferenceService.clearAll();
    Get.offAllNamed(Routes.LOGIN);
  }
}
