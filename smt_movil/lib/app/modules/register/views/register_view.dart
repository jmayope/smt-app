import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smt_movil/app/theme/app_colors.dart';
import 'package:smt_movil/app/theme/app_dropdown_field.dart';
import 'package:smt_movil/app/validations/main.validation.dart';
import 'package:smt_movil/models/index.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.navyDark,
      body: Stack(
        children: [
          Positioned.fill(child: _buildBackground()),
          SafeArea(child: _buildContent(context)),
        ],
      )
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
  // CONTENIDO
  // ---------------------------------------------------------
  Widget _buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  _buildBrand(context),
                  const SizedBox(height: 20),
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
 
  Widget _buildBrand(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => controller.goToLogin(),
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
          const SizedBox(height: 4),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.local_shipping_outlined, // TODO: tu logo
              color: Colors.white,
              size: 30,
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
        color: Colors.white.withValues(alpha: 0.92),
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
                'Crear cuenta',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Completa tus datos para comenzar',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
            const SizedBox(height: 18),
         
            // Campos no reactivos
            TextFormField(
              controller: controller.ruc,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              maxLength: 11,
              decoration: _inputDecoration(
                hint: 'RUC de la Empresa',
                icon: Icons.person_outline,
                suffix: IconButton(
                  onPressed: () => controller.validateEntity(), 
                  icon: Icon(Icons.search)
                )
              ),
              validator: validateRuc,
            ),
            Obx(() {
              return controller.isNewCompany.value ? 
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      "Datos de la Empresa",
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.businessName,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      enabled: controller.isValid.value,
                      decoration: _inputDecoration(
                        hint: 'Razon Social',
                        icon: Icons.card_membership,
                      ),
                      validator: validateBusinessName,
                    ),
                    const SizedBox(height: 12),
                    AppDropdown<TableType>(
                      hint: 'Tipo de Empresa',
                      icon: Icons.badge_outlined,
                      value: controller.businessTypeSelected.value,
                      items: controller.businessTypes.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text(c.name!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.businessTypeSelected.value = value!;
                      },
                    ),
                    TextFormField(
                      controller: controller.businessAddress,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      enabled: controller.isValid.value,
                      decoration: _inputDecoration(
                        hint: 'Dirección',
                        icon: Icons.home,
                      ),
                      validator: validateAddress,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.businessPhone,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      enabled: controller.isValid.value,
                      maxLength: 9,
                      decoration: _inputDecoration(
                        hint: 'Telefono',
                        icon: Icons.phone,
                      ),
                      validator: validatePhone,
                    ),
                    const SizedBox(height: 12),
                    
                  ],
                )
              :
                Container()
                ;
            })
            ,
            Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isNewCompany.value ? "Datos del Representante Legal" : "Datos del Colaborador",
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.documentNumber,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.words,
                    enabled: controller.isValid.value,
                    maxLength: 8,
                    decoration: _inputDecoration(
                      hint: 'Número de Documento',
                      icon: Icons.card_membership,
                      suffix: IconButton(
                        onPressed: () => controller.validateUser(), 
                        icon: Icon(Icons.search)
                      )
                    ),
                    validator: validateDocumentNumber,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.firstName,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    enabled: controller.isValid.value && controller.canContinue.value,
                    decoration: _inputDecoration(
                      hint: 'Nombres',
                      icon: Icons.person_outline,
                    ),
                    validator: validateFirstName,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.lastName,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    enabled: controller.isValid.value  && controller.canContinue.value,
                    decoration: _inputDecoration(
                      hint: 'Apellidos',
                      icon: Icons.person_outline,
                    ),
                    validator: validateLastName,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.email,
                    keyboardType: TextInputType.emailAddress,
                    enabled: controller.isValid.value && controller.canContinue.value,
                    decoration: _inputDecoration(
                      hint: 'Correo electrónico',
                      icon: Icons.mail_outline,
                    ),
                    validator: validateEmail,
                  ),
                  controller.canContinue.value ? 
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: controller.phone,
                          keyboardType: TextInputType.phone,
                          enabled: controller.isValid.value,
                          maxLength: 9,
                          decoration: _inputDecoration(
                            hint: 'Teléfono',
                            icon: Icons.phone_outlined,
                          ),
                          validator: validatePhone,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: controller.password,
                          obscureText: !controller.showPassword.value,
                          enabled: controller.isValid.value,
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
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: controller.confirmPassword,
                          obscureText: !controller.showPassword.value,
                          enabled: controller.isValid.value,
                          decoration: _inputDecoration(
                            hint: 'Confirmar contraseña',
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
                          validator: validateConfirmPassword,
                        ),
                        const SizedBox(height: 12),
                      ],
                    )
                  :
                    Container()
                  ,
                  controller.isNewCompany.value ? 
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "Elige tu Paquete de Subscripción",
                          style: TextStyle(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 275,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(5),
                              itemCount: controller.subscriptionPackages.length,
                              itemBuilder: (context, index) {
                                final plan = controller.subscriptionPackages.reversed.elementAt(index);
                                return Obx(() => PlanCard(
                                  plan: plan,
                                  isSelected:
                                      controller.subscriptionPackageSelectedId.value == plan.id,
                                  onTap: () => controller.selectPlan(plan.id!),
                                ));
                              }
                            ),
                          ),
                        )
                      ],
                    )
                  :
                    Container()
                ],
              );
            }),
            // Términos (reactivo: acceptTerms)
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Obx(
                    () => Checkbox(
                      value: controller.acceptTerms.value,
                      activeColor: AppColors.navy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: !controller.isValid.value ? null :  (value) =>
                          controller.acceptTerms.value = value ?? false,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // TODO: abrir términos y condiciones
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black87, fontSize: 12.5),
                        children: [
                          TextSpan(text: 'Acepto los '),
                          TextSpan(
                            text: 'Términos y condiciones',
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
            const SizedBox(height: 20),
         
            // Botón crear cuenta (reactivo: acceptTerms + registering)
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (controller.acceptTerms.value &&
                          !controller.registering.value)
                      ? () => controller.register()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    disabledBackgroundColor:
                        AppColors.navy.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.registering.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'CREAR CUENTA',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
         
            // Ya tienes cuenta
            Center(
              child: InkWell(
                onTap: () => controller.goToLogin(),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                    children: [
                      TextSpan(text: '¿Ya tienes cuenta? '),
                      TextSpan(
                        text: 'Inicia sesión',
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
 
class PlanCard extends StatelessWidget {
  final SubscriptionPackage plan;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 260,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.navyDark : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.navyDark.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge "Más popular"
            if (plan.durationInDays != -1)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.navyLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Más popular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Nombre
            Text(
              plan.name!,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            // Precio
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                plan.price! == 0 ?
                  Container()
                :
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      "S/. ${plan.price!}",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyDark,
                      ),
                    ),
                  )
                ,
                Text(
                  plan.durationInDays != -1 ? '${plan.durationInDays} dias' : 'Mensual',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 1),
            const SizedBox(height: 5,),
            Row(
              children: [
                Icon(Icons.bookmark_add_outlined),
                SizedBox(width: 5,),
                Text("${(plan.maxUsers! - plan.maxSupervisors! - plan.maxDrivers!) == 0 ? plan.maxSupervisors! : (plan.maxUsers! - plan.maxSupervisors! - plan.maxDrivers!)} Administradores")
              ],
            ),
            Row(
              children: [
                Icon(Icons.account_box),
                SizedBox(width: 5,),
                Text("${plan.maxSupervisors!} Supervisores")
              ],
            ),
            Row(
              children: [
                Icon(Icons.directions_bus_filled_outlined),
                SizedBox(width: 5,),
                Text("${plan.maxDrivers!} Conductores")
              ],
            ),
            Row(
              children: [
                Icon(Icons.car_repair),
                SizedBox(width: 5,),
                Text("${plan.maxVehicles!} Vehículos")
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isSelected ? AppColors.navyDark : Colors.grey.shade400,
                ),
                onPressed: onTap,
                child: Text(isSelected ? 'Seleccionado' : 'Elegir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}