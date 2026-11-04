import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smt_movil/app/data/constants.dart';
import 'package:smt_movil/app/helpers/main.helper.dart';
import 'package:smt_movil/app/theme/app_colors.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {

    final container = Obx(() {
      return controller.loading.value ? 
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Cargando información")
            ],
          ),
        )
      :
        RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context),
                _buildContent(context),
              ],
            ),
          ),
        )
        ;
    });

    return Scaffold(
      backgroundColor: AppColors.navyDark,
      body: container,
    );
  }
 
  // ---------------------------------------------------------
  // HEADER: usuario, compañía/perfil, estado y estadísticas
  // ---------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
 
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.navyDark,
            AppColors.navy,
            AppColors.navyLight,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Obx(
                () => InkWell(
                  onTap: () {
                    controller.goToProfile();
                  },
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        initials(controller.userLoged.value),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bienvenido de vuelta,',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Obx(
                      () => Text(
                        controller.userLoged.value.email!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _headerButton(
                Icons.notifications_none,
                () => controller.goToNotifications(),
              ),
              const SizedBox(width: 8),
              _headerButton(
                Icons.logout,
                () => controller.logout(),
                iconColor: const Color(0xFFFF8A8A),
                bgColor: AppColors.danger.withValues(alpha: 0.25),
              ),
            ],
          ),
          const SizedBox(height: 14),
 
          // Chip compañía · perfil + estado de conexión
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => controller.changeProfile(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.business_outlined,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Obx(
                            () => Text(
                              '${capitalizeWords(controller.userLoged.value.currentCompany!.name!)} · ${capitalizeWords(controller.userLoged.value.currentRole!.role!)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.swap_horiz,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Obx(() {
                final online = controller.isOnline.value;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: online ? AppColors.safeLight : AppColors.warn,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        online ? 'En línea' : 'Sin conexión',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 18),
 
          // Estadísticas
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _buildStatCard(
                    controller.assignedCount.value.toString(),
                    'Rutas hoy',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(
                  () => _buildStatCard(
                    controller.completedCount.value.toString(),
                    'Completadas',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(
                  () => _buildStatCard(
                    controller.kmTotal.value.toString(),
                    'Km recorridos',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
 
  Widget _headerButton(
    IconData icon,
    VoidCallback onTap, {
    Color iconColor = Colors.white,
    Color? bgColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
 
  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
 
  // ---------------------------------------------------------
  // CONTENIDO
  // ---------------------------------------------------------
  Widget _buildContent(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActiveRouteCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('ACCESO RÁPIDO'),
            const SizedBox(height: 12),
            _buildQuickAccessGrid(),
            const SizedBox(height: 24),
            _buildSectionTitle(
              'RUTAS DE HOY',
              actionLabel: 'Ver todas',
              onAction: () => controller.goToRoutes(),
            ),
            const SizedBox(height: 12),
            _buildTodayRoutes(),
          ],
        ),
      ),
    );
  }
 
  // Tarjeta de recorrido en progreso / iniciar recorrido (reactivo: activeRoute)
  Widget _buildActiveRouteCard() {
    return Obx(() {
      final route = controller.activeRoute.value;
      final hasActive = route != null;
 
      return InkWell(
        onTap: () =>
            hasActive ? controller.openActiveRoute() : controller.startRoute(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: hasActive ? AppColors.navy : AppColors.safe,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                hasActive ? Icons.route : Icons.play_circle_outline,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasActive ? '${route.name}' : 'Iniciar recorrido',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasActive
                          ? '${route.progressText}'
                          : 'No tienes un recorrido en curso',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white, size: 26),
            ],
          ),
        ),
      );
    });
  }
 
  Widget _buildSectionTitle(
    String title, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            letterSpacing: 0.5,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
      ],
    );
  }
 
  // ---------------------------------------------------------
  // ACCESO RÁPIDO (3 x 2)
  // ---------------------------------------------------------
  Widget _buildQuickAccessGrid() {
    final items = <_QuickItem>[
      _QuickItem(
        icon: Icons.alt_route,
        label: 'Mis rutas',
        color: AppColors.navy,
        bg: const Color(0xFFEFF2FB),
        onTap: () => controller.goToRoutes(),
      ),
      _QuickItem(
        icon: Icons.navigation,
        label: 'Iniciar recorrido',
        color: AppColors.safe,
        bg: const Color(0xFFEAF9EE),
        onTap: () => controller.startRoute(),
      ),
      _QuickItem(
        icon: Icons.map_outlined,
        label: 'Mapa',
        color: AppColors.navyLight,
        bg: const Color(0xFFEDF1FA),
        onTap: () => controller.goToMap(),
      ),
      _QuickItem(
        icon: Icons.warning_amber_rounded,
        label: 'Incidencias',
        color: AppColors.warn,
        bg: const Color(0xFFFDF0E6),
        onTap: () => controller.goToIncidents(),
      ),
      _QuickItem(
        icon: Icons.access_time,
        label: 'Historial',
        color: Colors.blueGrey,
        bg: const Color(0xFFEFF4F7),
        onTap: () => controller.goToHistory(),
      ),
      _QuickItem(
        icon: Icons.phone_in_talk_outlined,
        label: 'Pánico SOS',
        color: AppColors.sos,
        bg: const Color(0xFFFDECEC),
        onTap: () => controller.sos(),
      ),
    ];
 
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.05,
      children: items.map(_buildQuickCard).toList(),
    );
  }
 
  Widget _buildQuickCard(_QuickItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: item.bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: item.color, size: 24),
            const SizedBox(height: 6),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: item.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  // ---------------------------------------------------------
  // RUTAS DE HOY (reactivo: loading + todayRoutes)
  // ---------------------------------------------------------
  Widget _buildTodayRoutes() {
    return Obx(() {
      if (controller.loading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        );
      }
 
      final items = controller.todayRoutes;
      if (items.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              'No tienes rutas asignadas hoy.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        );
      }
 
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) => _buildRouteItem(index, items[index]),
      );
    });
  }
 
  Widget _buildRouteItem(int index, dynamic route) {
    final status = '${route.status}';
    late final Color color;
    late final String label;
    late final IconData icon;
 
    switch (status) {
      case 'in_progress':
        color = AppColors.safe;
        label = 'EN CURSO';
        icon = Icons.navigation_outlined;
        break;
      case 'completed':
        color = Colors.grey;
        label = 'COMPLETADA';
        icon = Icons.check;
        break;
      default:
        color = AppColors.warn;
        label = 'PENDIENTE';
        icon = Icons.schedule;
    }
 
    return InkWell(
      onTap: () => controller.openRoute(index),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${route.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${route.schedule} · ${route.distance}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
class _QuickItem {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
 
  const _QuickItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
  });
}
 