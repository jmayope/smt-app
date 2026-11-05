import 'dart:math';

import 'package:get/get.dart';
import 'package:smt_movil/app/data/constants.dart';
import 'package:smt_movil/app/data/preference.service.dart';
import 'package:smt_movil/app/data/supabase.service.dart';
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
  final hasTransportAssignments = false.obs;
  final transportAssignments = <TransportAssignment>[].obs;
  final currentTransportAssignment = TransportAssignment().obs;
  final supabase = Get.put(SupabaseService());
  final hasActive = false.obs;

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

    final resultTransportAssignments = await supabase.select(TRANSPORT_ASSIGNMENTS, filters: {"driver_id": userLoged.value.id, "status": [STATUS_PENDING, STATUS_IN_PROGRESS, STATUS_COMPLETED]});
    transportAssignments.value = (resultTransportAssignments as Iterable).map((ta) => TransportAssignment.fromJson(ta)).toList();

    if (transportAssignments.isNotEmpty) {
      currentTransportAssignment.value = transportAssignments.singleWhere((ta) => ta.status == STATUS_IN_PROGRESS, orElse: () => TransportAssignment());
      if (currentTransportAssignment.value.id != null) {
        hasActive.value = true;
        activeRoute.value = currentTransportAssignment.value.route!;
      }
      assignedCount.value = transportAssignments.length;
    } else {
      assignedCount.value = 0;
      hasTransportAssignments.value = false;
    }
    
    completedCount.value = transportAssignments.where((ta) => ta.status == STATUS_COMPLETED).length;
    kmTotal.value = transportAssignments.where((ta) => ta.status == STATUS_COMPLETED).fold(0, (m, i) => i.route!.distanceKm!);

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

  Future<void> goToProfile() async {
    Get.offAllNamed(Routes.USER_PROFILE);
  }

  Future<void> refreshData() async {

  }

  Future<void> goToNotifications() async {

  }

  Future<void> openActiveRoute() async {
    Get.offAllNamed(Routes.ROUTE_ACTIVE, arguments: {"transportAssignment": currentTransportAssignment.value});
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
    if (userLoged.value.currentCompany!.roles!.length > 1) {
      Get.offAllNamed(Routes.SELECT_PROFILE);
    }
  }
}
