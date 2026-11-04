export 'company_subscription.dart';
export 'table_type.dart';
export 'subscription_package.dart';
export 'user_company_role.dart';
export 'user.dart';
export 'company.dart';
export 'route_map.dart';
import 'package:quiver/core.dart';

T? checkOptional<T>(Optional<T?>? optional, T? Function()? def) {
  // No value given, just take default value
  if (optional == null) return def?.call();

  // We have an input value
  if (optional.isPresent) return optional.value;

  // We have a null inside the optional
  return null;
}
