import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/route_active/bindings/route_active_binding.dart';
import '../modules/route_active/views/route_active_view.dart';
import '../modules/select_company/bindings/select_company_binding.dart';
import '../modules/select_company/views/select_company_view.dart';
import '../modules/select_profile/bindings/select_profile_binding.dart';
import '../modules/select_profile/views/select_profile_view.dart';
import '../modules/user_profile/bindings/user_profile_binding.dart';
import '../modules/user_profile/views/user_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_PROFILE,
      page: () => const SelectProfileView(),
      binding: SelectProfileBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_COMPANY,
      page: () => const SelectCompanyView(),
      binding: SelectCompanyBinding(),
    ),
    GetPage(
      name: _Paths.ROUTE_ACTIVE,
      page: () => const RouteActiveView(),
      binding: RouteActiveBinding(),
    ),
    GetPage(
      name: _Paths.USER_PROFILE,
      page: () => const UserProfileView(),
      binding: UserProfileBinding(),
    ),
  ];
}
