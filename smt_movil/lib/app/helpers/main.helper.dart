import 'package:flutter/material.dart';
import 'package:smt_movil/app/theme/app_colors.dart';

String val(dynamic v) {
  if (v == null) return '-';
  final s = '$v'.trim();
  return s.isEmpty ? '-' : s;
}

String getfullName(dynamic u) {
  if (u == null) return '-';
  final name = '${u.firstName ?? ''} ${u.lastName ?? ''}'.trim();
  return name.isEmpty ? '-' : name;
}

String initials(dynamic u) {
  if (u == null) return '?';
  final f = '${u.firstName ?? ''}'.trim();
  final l = '${u.lastName ?? ''}'.trim();
  final res = '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}';
  return res.isEmpty ? '?' : res.toUpperCase();
}

String roleLabel(dynamic role) {
  switch ('$role') {
    case 'admin':
      return 'Administrador';
    case 'admin_entity':
      return 'Admin. de entidad';
    case 'supervisor':
      return 'Supervisor';
    case 'driver':
      return 'Conductor';
    default:
      return '-';
  }
}

Color packageColor(String name) {
  switch (name) {
    case 'VIP':
      return AppColors.warn;
    case 'REGULAR':
      return AppColors.safe;
    default: // BASICO
      return AppColors.navyLight;
  }
}

String two(int n) => n.toString().padLeft(2, '0');

String fmtDate(DateTime d) => '${two(d.day)}/${two(d.month)}/${d.year}';

String fmtDateTime(DateTime? d) {
  if (d == null) return '-';
  final l = d.toLocal();
  return '${fmtDate(l)} ${two(l.hour)}:${two(l.minute)}';
}