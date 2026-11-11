import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:quiver/core.dart';
import 'package:smt_movil/app/data/constants.dart';
import 'package:smt_movil/app/data/supabase.service.dart';
import 'package:smt_movil/app/routes/app_pages.dart';
import 'package:smt_movil/models/index.dart';
import 'package:http/http.dart' as http;
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

  final supabase = Get.put(SupabaseService());

  final mapController = MapController().obs;
  final userLocation = LatLng(0, 0).obs;
  final location = Location();
  final routeFromTo = <LatLng>[].obs;
  final hasBegining = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeLocation();
  }

  Future<void> initializeLocation() async {
    if (!await checkRequestPermissions()) return;
    getInitialData();
  }

  Future<bool> checkRequestPermissions() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }

  Future<void> getInitialData() async {
    currentTransportAssignment.value = parameters["transportAssignment"];
    
    if (currentTransportAssignment.value.status == STATUS_PENDING) {
      final updateTransportAssignment = await supabase.update(TRANSPORT_ASSIGNMENTS, currentTransportAssignment.value.id, {"status": STATUS_IN_PROGRESS});
      if ((updateTransportAssignment as Iterable).isEmpty) {
        Get.snackbar("Error", "No se pudo actualizar la asignación");
        return;
      }

      hasBegining.value = true;
    } else {
      hasBegining.value = false;
    }

    location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        userLocation.value = LatLng(locationData.latitude!, locationData.longitude!);
      }
    });

    final segments = await supabase.select(ROUTE_SEGMENTS, filters: {"route_id": currentTransportAssignment.value.routeId});
    if ((segments as Iterable).isEmpty) {
      Get.snackbar("Error", "No se registraron segmentos para esta ruta. Contacte con su administrador");
      return;
    }
    List<RouteSegment> allSegments = (segments as Iterable).map((s) => RouteSegment.fromJson(s)).toList();

    final pointIds = <String>{
      ...allSegments.map((s) => s.toPointId!),
      ...allSegments.map((s) => s.fromPointId!),
    }.toList();

    final points = await supabase.select(ROUTE_POINTS, filters: {"id": pointIds});
    List<RoutePoint> allPoints = (points as Iterable).map((p) => RoutePoint.fromJson(p)).toList();
    for (var i = 0; i < allSegments.length; i++) {
      RoutePoint toPoint = allPoints.singleWhere((t) => t.id == allSegments[i].toPointId);
      RoutePoint fromPoint = allPoints.singleWhere((t) => t.id == allSegments[i].fromPointId);
      allSegments[i] = allSegments[i].copyWith(toPoint: Optional.of(toPoint), fromPoint: Optional.of(fromPoint));
    }

    if (hasBegining.value) {
      currentRouteSegment.value = allSegments.first;
      final newTransportLog = {
        "assignment_id": currentTransportAssignment.value.id,
        "route_point_id": currentRouteSegment.value.fromPoint!.id,
        "timestamp": DateTime.now().toIso8601String(),
        "location": currentRouteSegment.value.fromPoint!.name,
        "event_type": STATUS_DEPARTURE,
        "latitude": currentRouteSegment.value.fromPoint!.latitude,
        "longitude": currentRouteSegment.value.fromPoint!.longitude,
        "notes": "Salida de la unidad según programación.",
        "has_issue": false,
        "is_verified": true
      };

      userLocation.value = LatLng(currentRouteSegment.value.fromPoint!.latitude!, currentRouteSegment.value.fromPoint!.longitude!);

      final resultTransportLog = await supabase.insert(TRANSPORT_LOGS, newTransportLog);
      if ((resultTransportLog as Iterable).isEmpty) {
        Get.snackbar("Error", "Hubo un error al momento de registrar el log.");
        return;
      }
    } else {
      // Obtención del segmento actual

      // Verificar si un segmento tiene:
      // departure - INICIA
      // arrival - TERMINA
      // transport_logs

      final transportLogs = await supabase.select(TRANSPORT_LOGS, filters: {"assignment_id": currentTransportAssignment.value.id});

      if ((transportLogs as Iterable).isEmpty) {
        currentRouteSegment.value = allSegments.first;
      } else{
        List<TransportLog> logs = (transportLogs as Iterable).map((l) => TransportLog.fromJson(l)).toList();
        bool segmentFound = false;
        int transportLogOfSegmentFound = 0;
        RouteSegment? pendingSegment;
        bool needsDeparture = false;

        for (var i = 0; i < allSegments.length; i++) {
          RouteSegment segment = allSegments[i];
          
          // Buscar si YA EXISTE un departure para el punto de salida de ESTE segmento
          final hasDeparture = logs.any((l) => 
            l.assignmentId == currentTransportAssignment.value.id &&
            l.eventType == STATUS_DEPARTURE && 
            l.routePointId == segment.fromPointId
          );

          // Buscar si YA EXISTE un arrival para el punto de llegada de ESTE segmento
          final hasArrival = logs.any((l) => 
            l.assignmentId == currentTransportAssignment.value.id &&
            l.eventType == STATUS_ARRIVAL && 
            l.routePointId == segment.toPointId
          );

          // Si falta alguna de las dos, este es el segmento pendiente
          if (!hasDeparture || !hasArrival) {
            pendingSegment = segment;
            needsDeparture = !hasDeparture;
            break; // Detenemos la búsqueda en el primer segmento incompleto
          }
        }

        // Evaluar el segmento pendiente
        if (pendingSegment != null) {
          currentRouteSegment.value = pendingSegment;
          
          if (needsDeparture) {
            // Si falta el departure, lo insertamos y seteamos la ubicación en el punto de salida
            userLocation.value = LatLng(
              pendingSegment.fromPoint!.latitude!, 
              pendingSegment.fromPoint!.longitude!
            );

            final newTransportLog = {
              "assignment_id": currentTransportAssignment.value.id,
              "route_point_id": pendingSegment.fromPoint!.id,
              "timestamp": DateTime.now().toIso8601String(),
              "location": pendingSegment.fromPoint!.name,
              "event_type": STATUS_DEPARTURE,
              "latitude": pendingSegment.fromPoint!.latitude,
              "longitude": pendingSegment.fromPoint!.longitude,
              "notes": "Salida de la unidad según programación.",
              "has_issue": false,
              "is_verified": true
            };

            final resultTransportLog = await supabase.insert(TRANSPORT_LOGS, newTransportLog);
            if ((resultTransportLog as Iterable).isEmpty) {
              Get.snackbar("Error", "Hubo un error al momento de registrar el log.");
              return;
            }
          } else {
            // Si ya tiene departure pero falta arrival, significa que el usuario está en camino al toPoint
            userLocation.value = LatLng(
              pendingSegment.toPoint!.latitude!, 
              pendingSegment.toPoint!.longitude!
            );
            print("Esperando llegada al punto: ${pendingSegment.toPoint!.name}");
          }
        } else {
          print("¡Ruta completada!");
        }
      }
    }

    userLocation.value = LatLng(currentRouteSegment.value.fromPoint!.latitude!, currentRouteSegment.value.fromPoint!.longitude!);
    // await paintRoute();
    if (currentRouteSegment.value.id == null) return;
    final url = Uri.parse("http://router.project-osrm.org/route/v1/driving/"
      '${currentRouteSegment.value.fromPoint!.longitude!},${currentRouteSegment.value.fromPoint!.latitude!};'
      '${currentRouteSegment.value.toPoint!.longitude},${currentRouteSegment.value.toPoint!.latitude}?overview=full&geometries=polyline');
    
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final geometry = data["routes"][0]["geometry"];
      decodePolyline(geometry);
      loading.value = false;
    } else {
      Get.snackbar("Error", "No se pudo obtener la ruta entre segmentos");
      loading.value = false;
    }
  }

  // Future<void> paintRoute() async {
    
  // }

  void decodePolyline(String encodedPolyline) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(encodedPolyline);
    routeFromTo.value = decodedPoints.map((p) => LatLng(p.latitude, p.longitude)).toList();
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
    // Validación de proximidad
    final newTransportLog = {
      "assignment_id": currentTransportAssignment.value.id,
      "route_point_id": currentRouteSegment.value.toPoint!.id,
      "timestamp": DateTime.now().toIso8601String(),
      "location": currentRouteSegment.value.toPoint!.name,
      "event_type": STATUS_ARRIVAL,
      "latitude": currentRouteSegment.value.toPoint!.latitude,
      "longitude": currentRouteSegment.value.toPoint!.longitude,
      "notes": "Llegada registrada dentro del tiempo estimado.",
      "has_issue": false,
      "is_verified": true
    };

    final resultTransportLog = await supabase.insert(TRANSPORT_LOGS, newTransportLog);
    if ((resultTransportLog as Iterable).isEmpty) {
      Get.snackbar("Error", "No se pudo completar el recorrido. Vuelva a intentar");
      return;
    }
    Get.snackbar("Éxito", "Recorrido completado");
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> addIncidentPhoto() async {

  }

  Future<void> submitIncident() async {

  }

  Future<void> selectIncidentType(int index) async {
    selectedIncidentType.value = index;
  }

}
