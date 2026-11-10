import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:smt_movil/app/routes/app_pages.dart';
import 'package:smt_movil/models/index.dart';

class RouteActiveController extends GetxController {
  
  final loading = true.obs;
  final sendingSos = false.obs;
  final currentTransportAssignment = TransportAssignment().obs;
  final currentRouteSegment = RouteSegment().obs;

  final parameters = Get.arguments;

  final completedStops = int.parse('0').obs;
  final totalStops = int.parse('0').obs;
  final speed = num.parse('0').obs;
  final elapsed = num.parse('0').obs;
  final distance = num.parse('0').obs;
  final incidentTypes = <TableType>[].obs;
  final lastIncident = TextEditingController();
  final incidentPhotoCount = int.parse('0').obs;
  final selectedIncidentType = int.parse('0').obs;

  final sendingIncident = false.obs;

  final finishing = false.obs;

  @override
  void onInit() {
    super.onInit();
    getInitialData();
  }

  Future<void> getInitialData() async {
    currentTransportAssignment.value = parameters["transportAssignment"];
    
    
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
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> sendSos() async {

  }

  Future<void> finishRoute() async {

  }

  Future<void> addIncidentPhoto() async {

  }

  Future<void> submitIncident() async {

  }

  Future<void> selectIncidentType(int index) async {
    selectedIncidentType.value = index;
  }

}
