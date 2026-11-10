import 'dart:math';
import 'package:smt_movil/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  const months = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
  ];
  return '${date.day} de ${months[date.month - 1]} de ${date.year}';
}

const List<Color> profileColors = [
  AppColors.navy,
  AppColors.safe,
  AppColors.warn,
  AppColors.navyLight,
];



String formatDateToYYYYMMDD(DateTime date) {
  return date.toIso8601String().split('T')[0];
}

String formatDateToISOWithTimezone(DateTime date) {
  return date.toIso8601String();
}

String capitalizeWords(String text) {
  return text
      .split(' ')
      .map((word) => word.isEmpty
          ? word
          : word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = dateTime.difference(now);

  final isFuture = difference.isNegative == false;
  final duration = difference.abs();

  if (duration.inSeconds < 60) {
    return isFuture ? 'En unos momentos' : 'Hace unos momentos';
  }

  if (duration.inMinutes < 60) {
    final minutes = duration.inMinutes;
    return isFuture ? 'En ${minutes} min' : 'Hace ${minutes} min';
  }

  if (duration.inHours < 24) {
    final hours = duration.inHours;
    return isFuture ? 'En ${hours} h' : 'Hace ${hours} h';
  }

  if (duration.inDays == 1) {
    return isFuture ? 'Mañana' : 'Ayer';
  }

  if (duration.inDays < 7) {
    final days = duration.inDays;
    return isFuture ? 'En ${days} días' : 'Hace ${days} días';
  }

  if (duration.inDays < 30) {
    final weeks = (duration.inDays / 7).floor();
    return isFuture ? 'En ${weeks} sem.' : 'Hace ${weeks} sem.';
  }

  if (duration.inDays < 365) {
    final months = (duration.inDays / 30).floor();
    return isFuture ? 'En ${months} meses' : 'Hace ${months} meses';
  }

  final years = (duration.inDays / 365).floor();
  return isFuture ? 'En ${years} años' : 'Hace ${years} años';
}

Color getRandomColor() {
  final random = Random();

  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

const String TOKEN_NAME = "smt_token";

const String STATUS_PENDING = 'pending';
const String STATUS_IN_PROGRESS = 'in_progress';
const String STATUS_COMPLETED = 'completed';
const String STATUS_CANCELLED = 'cancelled';
const String STATUS_DELAYED = 'delayed';

const String STATUS_DEPARTURE = 'departure';
const String STATUS_ARRIVAL = 'arrival';

const String COMPANIES = 'companies';
const String USERS = 'users';
const String SUBSCRIPTION_PACKAGES = 'subscription_packages';
const String COMPANY_SUBSCRIPTIONS = 'company_subscriptions';
const String VEHICLES = 'vehicles';
const String VEHICLE_DOCUMENTS = 'vehicle_documents';
const String ROUTES = 'routes';
const String ROUTE_POINTS = 'route_points';
const String ROUTE_SEGMENTS = 'route_segments';
const String TRANSPORT_ASSIGNMENTS = 'transport_assignments';
const String TRANSPORT_LOGS = 'transport_logs';
const String TRANSPORT_DELIVERIES = 'transport_deliveries';
const String MAINTENANCE_RECORDS = 'maintenance_records';
const String USER_COMPANY_ROLES = 'user_company_roles';
const String COMPANY_SETTINGS = 'company_settings';
const String COMPANY_MODULES = 'company_modules';
const String AUDIT_LOGS = 'audit_logs';
const String SESSION_LOGS = 'session_logs';
const String INCIDENTS = 'incidents';
const String NOTIFICATIONS = 'notifications';
const String DAILY_REPORTS = 'daily_reports';
const String VEHICLE_USAGE_STATS = 'vehicle_usage_stats';
const String MENUS = 'menus';
const String MENU_BY_ROLES = 'menu_by_roles';
