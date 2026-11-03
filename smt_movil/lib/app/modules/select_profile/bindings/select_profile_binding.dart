import 'package:get/get.dart';

import '../controllers/select_profile_controller.dart';

class SelectProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectProfileController>(
      () => SelectProfileController(),
    );
  }
}
