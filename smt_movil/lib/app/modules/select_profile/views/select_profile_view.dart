import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smt_movil/app/data/constants.dart';
import 'package:smt_movil/app/theme/app_colors.dart';
import 'package:smt_movil/models/index.dart';

import '../controllers/select_profile_controller.dart';

class SelectProfileView extends GetView<SelectProfileController> {
  const SelectProfileView({super.key});
  @override
  Widget build(BuildContext context) {

    final container = Obx(() {
      return controller.loading.value ?
        Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              Text("Cargando información del usuario")
            ],
          ),
        )
      :
        Stack(
          children: [
            Positioned.fill(child: _buildBackground()),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Expanded(child: _buildHeader()),
                      _buildSheet(constraints.maxHeight * 0.62),
                    ],
                  );
                },
              ),
            ),
          ],
        )
      ;

    });

    return Scaffold(
      backgroundColor: AppColors.navyDark,
      body: container,
    );
  }
 
  // ---------------------------------------------------------
  // FONDO
  // ---------------------------------------------------------
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/imgs/minertrans_background.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.navyDark.withValues(alpha: 0.85),
              AppColors.navy.withValues(alpha: 0.55),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
 
  // ---------------------------------------------------------
  // HEADER: botón volver + marca + compañía elegida
  // ---------------------------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => controller.goBack(),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined, // TODO: tu logo
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Minertrans',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Chip con la compañía elegida (reactivo: companyName)
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.business_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            controller.userLoged.value.currentCompany!.name!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
  // PANEL INFERIOR: título + lista + botón continuar
  // ---------------------------------------------------------
  Widget _buildSheet(double height) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona tu perfil',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Elige cómo deseas ingresar',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),
 
          // Lista (reactivo: loading + profiles)
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = controller.userLoged.value.currentCompany!.roles;
              if (items!.isEmpty) {
                return Center(
                  child: Text(
                    'No tienes perfiles en esta compañía.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                );
              }
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _buildProfileTile(index, items[index]),
              );
            }),
          ),
          const SizedBox(height: 12),
 
          // Botón continuar (reactivo: selectedIndex + loading)
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (controller.selectedIndex.value >= 0 &&
                        !controller.loading.value)
                    ? () => controller.continueNext()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  disabledBackgroundColor:
                      AppColors.navy.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'INGRESAR',
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
    );
  }
 
  // ---------------------------------------------------------
  // ITEM de perfil (reactivo: selectedIndex)
  // ---------------------------------------------------------
  Widget _buildProfileTile(int index, UserCompanyRole profile) {
    final color = profileColors[index % profileColors.length];
 
    return Obx(() {
      final selected = controller.selectedIndex.value == index;
 
      return InkWell(
        onTap: () => controller.selectProfile(index),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.06) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? color : Colors.grey.shade200,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.badge_outlined, // TODO: icono según tipo de perfil
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.role}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: selected ? AppColors.safe : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      );
    });
  }
}
 