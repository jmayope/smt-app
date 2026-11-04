import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smt_movil/app/helpers/main.helper.dart';
import 'package:smt_movil/app/theme/app_colors.dart';
import '../controllers/user_profile_controller.dart';

class UserProfileView extends GetView<UserProfileController> {
  const UserProfileView({super.key});
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
              Text("Cargando Información del Usuario")
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
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPersonalCard(),
                        const SizedBox(height: 20),
                        _buildSectionTitle('EMPRESA'),
                        const SizedBox(height: 10),
                        _buildCompanyCard(),
                        const SizedBox(height: 20),
                        _buildSectionTitle('MI PAQUETE'),
                        const SizedBox(height: 10),
                        _buildSubscriptionCard(),
                        const SizedBox(height: 20),
                        _buildSectionTitle('CUENTA'),
                        const SizedBox(height: 10),
                        _buildActionsCard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: container,
    );
  }
 
  // ---------------------------------------------------------
  // HEADER: avatar, nombre, correo y rol (reactivo: user)
  // ---------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
 
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 48),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _headerButton(Icons.arrow_back_ios_new, () => controller.goBack()),
              const Text(
                'Perfil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 36), // equilibra el botón izquierdo
            ],
          ),
          const SizedBox(height: 20),
          Obx(() {
            final u = controller.userLoged.value;
            final fullName = getfullName(u);
 
            return Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      initials(u),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  u == null ? '-' : '${u.email}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    u.currentRole!.role!.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
 
  Widget _headerButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
 
  // ---------------------------------------------------------
  // INFORMACIÓN PERSONAL (reactivo: user)
  // ---------------------------------------------------------
  Widget _buildPersonalCard() {
    return Obx(() {
      final u = controller.userLoged.value;
 
      return _card(
        child: Column(
          children: [
            _infoRow(Icons.badge_outlined, 'Documento', val(u?.documentId)),
            _divider(),
            _infoRow(Icons.phone_outlined, 'Teléfono', val(u?.phone)),
            _divider(),
            _infoRow(Icons.mail_outline, 'Correo electrónico', val(u?.email)),
            _divider(),
            u.lastLogin == null ? 
              Container() 
            :
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(
                    Icons.access_time,
                    'Último acceso',
                    fmtDateTime(u.lastLogin!),
                  ),
                  _divider(),
                ],
              )
            ,
            _infoRow(
              Icons.verified_user_outlined,
              'Verificación en 2 pasos',
              (u?.has2fa == true) ? 'Activada' : 'Desactivada',
              valueColor: (u?.has2fa == true) ? AppColors.safe : Colors.grey,
            ),
          ],
        ),
      );
    });
  }
 
  // ---------------------------------------------------------
  // EMPRESA (reactivo: company)
  // ---------------------------------------------------------
  Widget _buildCompanyCard() {
    return Obx(() {
      final c = controller.userLoged.value.currentCompany;
 
      return _card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Row(
                children: [
                  _iconBox(Icons.business_outlined, AppColors.navy, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      val(c?.name),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _divider(),
            _infoRow(Icons.category_outlined, 'Giro de negocio',
                val(c?.businessType)),
            _divider(),
            _infoRow(Icons.numbers, 'RUC', val(c?.ruc)),
            _divider(),
            _infoRow(Icons.phone_outlined, 'Teléfono', val(c?.phone)),
            _divider(),
            _infoRow(Icons.location_on_outlined, 'Dirección', val(c?.address)),
          ],
        ),
      );
    });
  }
 
  // ---------------------------------------------------------
  // PAQUETE SUSCRITO (reactivo: subscription + loading)
  // ---------------------------------------------------------
  Widget _buildSubscriptionCard() {
    return Obx(() {
      if (controller.loading.value && controller.subscriptionPackage.value.id == null) {
        return _card(
          child: const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }
 
      final s = controller.subscriptionPackage.value;
      if (s.id == null) {
        return _card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _iconBox(Icons.card_membership, AppColors.warn),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Tu empresa no tiene un paquete activo.',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        );
      }
 
      final pkg = s.package;
      final name = '${pkg!.name}'.toUpperCase();
      final color = packageColor(name);
 
      final DateTime start = s.startDate!;
      final DateTime? end = s.endDate;
      final int? daysLeft = end?.difference(DateTime.now()).inDays;
      final bool expiringSoon = daysLeft != null && daysLeft <= 7;
 
      double? progress;
      if (end != null) {
        final total = end.difference(start).inSeconds;
        final elapsed = DateTime.now().difference(start).inSeconds;
        progress = total <= 0 ? 1.0 : (elapsed / total).clamp(0.0, 1.0);
      }
 
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.75)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre + precio
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.workspace_premium,
                    color: Colors.white, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paquete $name',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (pkg.description != null &&
                          '${pkg.description}'.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${pkg.description}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (pkg.price != null)
                  Text(
                    'S/. ${pkg.price}', // TODO: agrega símbolo de moneda (S/, $, etc.)
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
 
            // Badges: estado y prueba
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _pill(s.isActive == true ? 'ACTIVO' : 'INACTIVO'),
                if (s.isTrial == true) _pill('PERIODO DE PRUEBA'),
              ],
            ),
            const SizedBox(height: 16),
 
            // Límites del paquete (2 x 2)
            Row(
              children: [
                Expanded(
                  child: _limitBox(
                      Icons.people_outline, 'Usuarios', '${pkg.maxUsers}'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _limitBox(Icons.supervisor_account_outlined,
                      'Supervisores', '${pkg.maxSupervisors}'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _limitBox(Icons.airline_seat_recline_normal,
                      'Conductores', '${pkg.maxDrivers}'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _limitBox(Icons.local_shipping_outlined, 'Vehículos',
                      '${pkg.maxVehicles}'),
                ),
              ],
            ),
            const SizedBox(height: 16),
 
            // Vigencia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Desde ${fmtDate(start)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  end == null ? 'Sin vencimiento' : 'Hasta ${fmtDate(end)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            if (progress != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    expiringSoon ? const Color(0xFFFFD166) : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                daysLeft! < 0
                    ? 'Tu paquete venció hace ${-daysLeft} día(s)'
                    : daysLeft == 0
                        ? 'Tu paquete vence hoy'
                        : 'Te quedan $daysLeft día(s)',
                style: TextStyle(
                  color: expiringSoon ? const Color(0xFFFFD166) : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
 
  Widget _limitBox(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
 
  // ---------------------------------------------------------
  // ACCIONES DE CUENTA
  // ---------------------------------------------------------
  Widget _buildActionsCard() {
    return _card(
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.changePassword(),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  _iconBox(Icons.lock_outline, AppColors.navy),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Cambiar contraseña',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey.shade400),
                ],
              ),
            ),
          ),
          _divider(),
          InkWell(
            onTap: () => controller.logout(),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  _iconBox(Icons.logout, AppColors.danger),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  // ---------------------------------------------------------
  // Helpers de UI
  // ---------------------------------------------------------
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
        letterSpacing: 0.5,
      ),
    );
  }
 
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
 
  Widget _divider() => const Divider(height: 1, color: Color(0xFFE5E7EB));
 
  Widget _iconBox(IconData icon, Color color, {double size = 36}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
 
  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    Color valueColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _iconBox(icon, AppColors.navy),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 