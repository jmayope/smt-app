import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smt_movil/app/theme/app_colors.dart';
import 'package:smt_movil/app/validations/main.validation.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {

    final container = Obx(() {
      return controller.loading.value ? 
        Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              Text(
                "Cargando formulario de Inicio"
              )
            ],
          ),
        ) 
      :
        Stack(
        children: [
          Positioned.fill(child: _buildBackground()),
          // Sin Obx global: solo los widgets reactivos usan Obx
          SafeArea(child: _buildContent()),
        ],
      );
    });

    return  Scaffold(
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
  // CONTENIDO: marca arriba, formulario abajo
  // ---------------------------------------------------------
  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  _buildBrand(),
                  const Spacer(),
                  _buildCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
 
  Widget _buildBrand() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.local_shipping_outlined, // TODO: tu logo
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Minertrans',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Transporte minero seguro', // TODO: tu lema
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
 
  // ---------------------------------------------------------
  // TARJETA DEL FORMULARIO
  // ---------------------------------------------------------
  Widget _buildCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ),
            const SizedBox(height: 18),
         
            // Correo (no reactivo)
         
            // Contraseña (reactivo: showPassword)
            Obx(
              () {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: controller.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        hint: 'Correo electrónico',
                        icon: Icons.mail_outline,
                      ),
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: controller.password,
                      obscureText: !controller.showPassword.value,
                      decoration: _inputDecoration(
                        hint: 'Contraseña',
                        icon: Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                            controller.showPassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => controller.showPassword.toggle(),
                        ),
                      ),
                      validator: validatePassword,
                    )
                  ],
                );
              }),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: olvidaste tu contraseña
                },
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(color: AppColors.navy),
                ),
              ),
            ),
            const SizedBox(height: 8),
         
            // Botón iniciar sesión (reactivo: logging)
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      controller.logging.value ? null : () => controller.login(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.logging.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'INICIAR SESIÓN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 18),
         
            // Registrarse
            Center(
              child: InkWell(
                onTap: () => controller.register(),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                    children: [
                      TextSpan(text: '¿No tienes cuenta? '),
                      TextSpan(
                        text: 'Regístrate',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}