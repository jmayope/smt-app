import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class UserCompanyRole {

  const UserCompanyRole({
    this.id,
    this.userId,
    this.companyId,
    this.role,
    this.assignedAt,
    this.isActive,
    this.hasAccessAll,
  });

  final String? id;
  final String? userId;
  final String? companyId;
  final String? role;
  final String? assignedAt;
  final bool? isActive;
  final bool? hasAccessAll;

  factory UserCompanyRole.fromJson(Map<String,dynamic> json) => UserCompanyRole(
    id: json['id']?.toString(),
    userId: json['user_id']?.toString(),
    companyId: json['company_id']?.toString(),
    role: json['role']?.toString(),
    assignedAt: json['assigned_at']?.toString(),
    isActive: json['is_active'] != null ? json['is_active'] as bool : null,
    hasAccessAll: json['has_access_all'] != null ? json['has_access_all'] as bool : null
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'company_id': companyId,
    'role': role,
    'assigned_at': assignedAt,
    'is_active': isActive,
    'has_access_all': hasAccessAll
  };

  UserCompanyRole clone() => UserCompanyRole(
    id: id,
    userId: userId,
    companyId: companyId,
    role: role,
    assignedAt: assignedAt,
    isActive: isActive,
    hasAccessAll: hasAccessAll
  );


  UserCompanyRole copyWith({
    Optional<String?>? id,
    Optional<String?>? userId,
    Optional<String?>? companyId,
    Optional<String?>? role,
    Optional<String?>? assignedAt,
    Optional<bool?>? isActive,
    Optional<bool?>? hasAccessAll
  }) => UserCompanyRole(
    id: checkOptional(id, () => this.id),
    userId: checkOptional(userId, () => this.userId),
    companyId: checkOptional(companyId, () => this.companyId),
    role: checkOptional(role, () => this.role),
    assignedAt: checkOptional(assignedAt, () => this.assignedAt),
    isActive: checkOptional(isActive, () => this.isActive),
    hasAccessAll: checkOptional(hasAccessAll, () => this.hasAccessAll),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is UserCompanyRole && id == other.id && userId == other.userId && companyId == other.companyId && role == other.role && assignedAt == other.assignedAt && isActive == other.isActive && hasAccessAll == other.hasAccessAll;

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ companyId.hashCode ^ role.hashCode ^ assignedAt.hashCode ^ isActive.hashCode ^ hasAccessAll.hashCode;
}
