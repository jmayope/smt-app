import 'package:get/get.dart';

import '../controllers/route_active_controller.dart';

class RouteActiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RouteActiveController>(
      () => RouteActiveController(),
    );
  }
}
