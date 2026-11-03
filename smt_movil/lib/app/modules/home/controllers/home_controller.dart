import 'dart:math';

import 'package:get/get.dart';
import 'package:smt_movil/app/data/preference.service.dart';
import 'package:smt_movil/app/routes/app_pages.dart';
import 'package:smt_movil/models/index.dart';

class HomeController extends GetxController {

  final userLoged = User().obs;
  final loading = true.obs;
  final isOnline = true.obs;
  final assignedCount = num.parse('0').obs;
  final completedCount = num.parse('0').obs;
  final kmTotal = num.parse('0').obs;
  final activeRoute = RouteMap().obs;
  final todayRoutes = <RouteMap>[];

  @override
  void onInit() {
    super.onInit();
    getInitialData();
  }

  Future<void> getInitialData() async {
    userLoged.value = await PreferenceService.getSession();
    assignedCount.value = Random().nextInt(10);
    completedCount.value = Random().nextInt(15);
    kmTotal.value = Random().nextInt(20);
    activeRoute.value = RouteMap(name: "Ruta en progreso - A -> B", progressText: "En camino");
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

  Future<void> goToNotifications() async {

  }

  Future<void> openActiveRoute() async {

  }

  Future<void> openRoute(int index) async {

  }

  Future<void> startRoute() async {

  }

  Future<void> goToMap() async {

  }

  Future<void> goToIncidents() async {

  }

  Future<void> goToHistory() async {

  }

  Future<void> sos() async {

  }


  Future<void> goToRoutes() async {

  }

  Future<void> logout() async {
    PreferenceService.clearAll();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> changeProfile() async {
    Get.offAllNamed(Routes.SELECT_PROFILE);
  }
}
