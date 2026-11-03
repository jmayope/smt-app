import 'package:get/get.dart';

import '../controllers/select_company_controller.dart';

class SelectCompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectCompanyController>(
      () => SelectCompanyController(),
    );
  }
}
