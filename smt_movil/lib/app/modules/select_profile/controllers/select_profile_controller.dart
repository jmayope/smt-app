import 'package:get/get.dart';
import 'package:quiver/core.dart';
import 'package:smt_movil/app/data/preference.service.dart';
import 'package:smt_movil/app/routes/app_pages.dart';
import 'package:smt_movil/models/index.dart';

class SelectProfileController extends GetxController {

  final userLoged = User().obs;
  final loading = true.obs;
  final selectedIndex = int.parse('0').obs;
  final itComesFromHome = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    getInitialData();
  }

  Future<void> getInitialData() async {
    userLoged.value = await PreferenceService.getSession();
    itComesFromHome.value = userLoged.value.currentRole!.id != null;

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

  Future<void> goBack() async {
    String origin = Routes.SELECT_COMPANY;
    if (itComesFromHome.value) {
      origin = Routes.HOME;
    }
    Get.offAllNamed(origin);
  }

  Future<void> continueNext() async {
    UserCompanyRole userCompanyRole = userLoged.value.currentCompany!.roles![selectedIndex.value];
    userLoged.value = userLoged.value.copyWith(currentRole: Optional.of(userCompanyRole));
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> selectProfile(int index) async {
    selectedIndex.value = index;
  }

}
