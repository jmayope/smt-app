import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smt_movil/app/data/constants.dart';
import 'package:smt_movil/app/theme/app_colors.dart';
import 'package:smt_movil/models/index.dart';

import '../controllers/select_company_controller.dart';

class SelectCompanyView extends GetView<SelectCompanyController> {
  const SelectCompanyView({super.key});
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
              Text(
                "Cargando formulario"
              )
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
        );
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
          image: AssetImage('assets/imgs/background.jpeg'),
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
  // HEADER: botón salir + marca + saludo
  // ---------------------------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => controller.logout(),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.logout, color: Colors.white, size: 18),
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
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      'Hola, ${controller.userLoged.value.firstName!}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
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
            'Selecciona tu compañía',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Elige con cuál deseas trabajar',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),
 
          // Lista (reactivo: loading + companies)
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = controller.userLoged.value.companies!;
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'No tienes compañías asignadas.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                );
              }
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _buildCompanyTile(index, items[index]),
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
                  'CONTINUAR',
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
  // ITEM de compañía (reactivo: selectedIndex)
  // ---------------------------------------------------------
  Widget _buildCompanyTile(int index, Company company) {
    return Obx(() {
      final selected = controller.selectedIndex.value == index;
 
      return InkWell(
        onTap: () => controller.selectCompany(index),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.navy.withValues(alpha: 0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.navy : Colors.grey.shade200,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business_outlined, // TODO: logo de la compañía
                  color: AppColors.navy,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${company.name}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${capitalizeWords(company.businessType!)} · ${company.roles!.length} perfil(es)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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
 