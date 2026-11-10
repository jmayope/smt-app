import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:smt_movil/app/theme/app_colors.dart';

import '../controllers/route_active_controller.dart';

class RouteActiveView extends GetView<RouteActiveController> {
  const RouteActiveView({super.key});
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    
    final container = Obx(() {
      return controller.loading.value ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Cargando información de la Ruta")
            ],
          ),
        )
      :
        Stack(
          children: [
            // ================= MAPA (fondo) =================
            // TODO: reemplazar por tu widget de mapa real (GoogleMap, flutter_map, etc.)
            // Positioned.fill(
            //   child: 
            //   // CustomPaint(painter: _MapPlaceholderPainter()),
            // ),
            FlutterMap(
              mapController: controller.mapController.value,
              options: MapOptions(
                initialCenter: controller.userLocation.value ?? LatLng(0,0),
                initialZoom: 15,
                minZoom: 0,
                maxZoom: 40
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.stmapp.utpdevs.smt_movil'
                ),
                CurrentLocationLayer(
                  style: LocationMarkerStyle(
                    marker: DefaultLocationMarker(
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.white,
                      ),
                    ),
                    markerSize: Size(35,35),
                    markerDirection: MarkerDirection.heading
                  ),
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(controller.currentRouteSegment.value.fromPoint!.latitude!, controller.currentRouteSegment.value.fromPoint!.longitude!), 
                      width: 35,
                      height: 35,
                      child: Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.blueAccent,
                      )
                    ),
                    Marker(
                      point: LatLng(controller.currentRouteSegment.value.toPoint!.latitude!, controller.currentRouteSegment.value.toPoint!.longitude!), 
                      width: 35,
                      height: 35,
                      child: Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.blueAccent,
                      )
                    ),
                  ]
                ),
                PolylineLayer(
                  polylines: [Polyline(points: controller.routeFromTo, strokeWidth: 5, color: Colors.red)]
                )
              ]
            ),
            // ================= HEADER + PANEL INFERIOR =================
            Column(
              children: [
                _buildHeader(topPadding),
                const Spacer(),
                _buildBottomPanel(),
              ],
            ),
  
            // ================= BOTONES FLOTANTES =================
            Positioned(
              top: topPadding,
              right: 12,
              child: Column(
                children: [
                  // SOS (reactivo: sendingSos)
                  Obx(
                    () => _FloatingActionBox(
                      color: AppColors.sos,
                      title: 'SOS',
                      label: 'PÁNICO',
                      loading: controller.sendingSos.value,
                      onTap: _confirmSos,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FloatingActionBox(
                    color: AppColors.warn,
                    icon: Icons.report_problem_rounded,
                    label: 'Incidencia',
                    onTap: _openIncidentSheet,
                  ),
                ],
              ),
            ),
          ],
        );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF151A30),
      body: container,
    );
  }
 
  // ---------------------------------------------------------
  // HEADER verde (reactivo: routeName)
  // ---------------------------------------------------------
  Widget _buildHeader(double topPadding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 14),
      color: AppColors.safe,
      child: Row(
        children: [
          InkWell(
            onTap: () => controller.goBack(),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: AppColors.safe,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Ruta activa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Text(
                    controller.currentTransportAssignment.value.route!.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          // Espacio a la derecha (queda detrás de los botones flotantes)
          const SizedBox(width: 32),
        ],
      ),
    );
  }
 
  // ---------------------------------------------------------
  // PANEL INFERIOR: próximo punto, progreso, stats y finalizar
  // ---------------------------------------------------------
  Widget _buildBottomPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNextStop(),
            const SizedBox(height: 14),
            _buildProgress(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(height: 1, color: Color(0xFFE5E7EB)),
            ),
            _buildStats(),
            const SizedBox(height: 16),
            _buildFinishButton(),
          ],
        ),
      ),
    );
  }
 
  // Próximo punto (reactivo: nextStop + nextStopEta)
  Widget _buildNextStop() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.navy.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.flag_outlined, color: AppColors.navy, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Próximo punto',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Obx(
                () => Text(
                  controller.currentRouteSegment.value.toPoint!.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.safe.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${controller.currentRouteSegment.value.toPoint!.estimatedArrivalMinutes} min',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.safe,
              ),
            ),
          ),
        ),
      ],
    );
  }
 
  // Progreso (reactivo: completedStops + totalStops)
  Widget _buildProgress() {
    return Obx(() {
      final done = controller.completedStops.value;
      final total = controller.totalStops.value;
      final value = total <= 0 ? 0.0 : (done / total).clamp(0.0, 1.0);
 
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso del recorrido',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              Text(
                '$done / $total puntos',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.safe),
            ),
          ),
        ],
      );
    });
  }
 
  // Estadísticas (reactivo: speed, elapsed, distance)
  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Obx(
          () => _statColumn(
            label: 'Velocidad',
            value: controller.speed.value.toString(),
            unit: 'km/h',
          ),
        ),
        Obx(
          () => _statColumn(
            label: 'Tiempo de viaje',
            value: controller.elapsed.value.toString(),
            valueSize: 22,
          ),
        ),
        Obx(
          () => _statColumn(
            label: 'Distancia',
            value: controller.distance.value.toString(),
            unit: 'km',
          ),
        ),
      ],
    );
  }
 
  Widget _statColumn({
    required String label,
    required String value,
    String? unit,
    double valueSize = 24,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: valueSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        if (unit != null) ...[
          const SizedBox(height: 2),
          Text(
            unit,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ] else
          const SizedBox(height: 14),
      ],
    );
  }
 
  // Botón finalizar (reactivo: finishing)
  Widget _buildFinishButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: controller.finishing.value ? null : _confirmFinish,
          icon: controller.finishing.value
              ? const SizedBox.shrink()
              : const Icon(Icons.stop_circle_outlined,
                  color: Colors.white, size: 20),
          label: controller.finishing.value
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  'FINALIZAR RECORRIDO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
 
  // =========================================================
  // DIÁLOGOS DE CONFIRMACIÓN
  // =========================================================
  void _confirmSos() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.sos.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.sos, color: AppColors.sos, size: 30),
        ),
        title: const Text(
          '¿Enviar alerta SOS?',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Se notificará a tu supervisor y contactos de emergencia '
          'con tu ubicación actual.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.sendSos();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sos,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'ENVIAR SOS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  void _confirmFinish() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '¿Finalizar recorrido?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Se cerrará la ruta activa y se guardará el recorrido realizado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.finishRoute();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'FINALIZAR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  // =========================================================
  // NUEVA INCIDENCIA (bottom sheet)
  // =========================================================
  void _openIncidentSheet() {
    Get.bottomSheet(
      Builder(
        builder: (context) => _buildIncidentSheet(context),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
 
  Widget _buildIncidentSheet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
 
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.warn.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.report_problem_rounded,
                        color: AppColors.warn, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nueva incidencia',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          'Se adjuntará tu ubicación actual',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
 
              _sheetLabel('TIPO DE INCIDENCIA'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int i = 0; i < controller.incidentTypes.length; i++)
                    _buildTypeChip(i, controller.incidentTypes[i].name!),
                ],
              ),
              const SizedBox(height: 20),
 
              _sheetLabel('DESCRIPCIÓN'),
              const SizedBox(height: 10),
              TextField(
                controller: controller.lastIncident,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Describe brevemente lo ocurrido (opcional)',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
 
              // Foto (reactivo: incidentPhotoCount)
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => controller.addIncidentPhoto(),
                    icon: const Icon(Icons.photo_camera_outlined,
                        size: 18, color: AppColors.navy),
                    label: const Text(
                      'Agregar foto',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.navy),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() {
                    final n = controller.incidentPhotoCount.value;
                    return Text(
                      n == 0 ? 'Sin fotos' : '$n foto(s) adjunta(s)',
                      style: TextStyle(
                        fontSize: 12,
                        color: n == 0 ? Colors.grey.shade500 : AppColors.safe,
                        fontWeight: n == 0 ? FontWeight.normal : FontWeight.w600,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 22),
 
              // Botón registrar (reactivo: selectedIncidentType + sendingIncident)
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: (controller.selectedIncidentType.value >= 0 &&
                            !controller.sendingIncident.value)
                        ? () => controller.submitIncident()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warn,
                      disabledBackgroundColor:
                          AppColors.warn.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.sendingIncident.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'REGISTRAR INCIDENCIA',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  // Chip de tipo (reactivo: selectedIncidentType)
  Widget _buildTypeChip(int index, String label) {
    return Obx(() {
      final selected = controller.selectedIncidentType.value == index;
 
      return ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
        selected: selected,
        showCheckmark: false,
        selectedColor: AppColors.warn,
        backgroundColor: const Color(0xFFF3F4F6),
        side: BorderSide.none,
        onSelected: (_) => controller.selectIncidentType(index),
      );
    });
  }
 
  Widget _sheetLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
        letterSpacing: 0.5,
      ),
    );
  }
}
 
// ==========================================================
// Botón flotante cuadrado (SOS / Incidencia)
// ==========================================================
class _FloatingActionBox extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final String? title;
  final String label;
  final bool loading;
  final VoidCallback onTap;
 
  const _FloatingActionBox({
    required this.color,
    required this.label,
    required this.onTap,
    this.icon,
    this.title,
    this.loading = false,
  });
 
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: loading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) Icon(icon, color: Colors.white, size: 22),
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
 
// // ==========================================================
// // Mapa oscuro de ejemplo: cuadrícula + ruta + posición actual
// // ==========================================================
// class _MapPlaceholderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawRect(
//       Offset.zero & size,
//       Paint()..color = const Color(0xFF151A30),
//     );
 
//     final thin = Paint()
//       ..color = const Color(0xFF1F2540)
//       ..strokeWidth = 3;
//     final thick = Paint()
//       ..color = const Color(0xFF232A47)
//       ..strokeWidth = 5;
 
//     for (final x in [0.2, 0.5, 0.85]) {
//       canvas.drawLine(Offset(size.width * x, 0),
//           Offset(size.width * x, size.height), thick);
//     }
//     for (final y in [0.25, 0.55, 0.75]) {
//       canvas.drawLine(Offset(0, size.height * y),
//           Offset(size.width, size.height * y), thin);
//     }
 
//     final start = Offset(size.width * 0.22, size.height * 0.36);
//     final path = Path()
//       ..moveTo(start.dx, start.dy)
//       ..cubicTo(
//         size.width * 0.25, size.height * 0.22,
//         size.width * 0.35, size.height * 0.15,
//         size.width * 0.45, size.height * 0.05,
//       )
//       ..lineTo(size.width * 0.55, 0);
 
//     canvas.drawPath(
//       path,
//       Paint()
//         ..color = const Color(0xFF3B82F6).withValues(alpha: 0.35)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 8
//         ..strokeCap = StrokeCap.round,
//     );
//     canvas.drawPath(
//       path,
//       Paint()
//         ..color = const Color(0xFF4F7DF3)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 4
//         ..strokeCap = StrokeCap.round,
//     );
 
//     canvas.drawCircle(start, 10,
//         Paint()..color = const Color(0xFF3B82F6).withValues(alpha: 0.3));
//     canvas.drawCircle(start, 6, Paint()..color = Colors.white);
//     canvas.drawCircle(start, 4, Paint()..color = const Color(0xFF3B82F6));
//   }
 
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }