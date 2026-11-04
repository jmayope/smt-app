import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class CompanySubscription {

  const CompanySubscription({
    this.id,
    this.companyId,
    this.packageId,
    this.package,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.isTrial,
  });

  final String? id;
  final String? companyId;
  final String? packageId;
  final SubscriptionPackage? package;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final bool? isTrial;

  factory CompanySubscription.fromJson(Map<String,dynamic> json) => CompanySubscription(
    id: json['id']?.toString(),
    companyId: json['company_id']?.toString(),
    packageId: json['package_id']?.toString(),
    package: json['package'] != null ? SubscriptionPackage.fromJson(json['package'] as Map<String, dynamic>) : null,
    startDate: json['start_date'] != null ? DateTime.parse(json['start_date'] as String) : null,
    endDate: json['end_date'] != null ? DateTime.parse(json['end_date'] as String) : null,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    isActive: json['is_active'] != null ? json['is_active'] as bool : null,
    isTrial: json['is_trial'] != null ? json['is_trial'] as bool : null
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'company_id': companyId,
    'package_id': packageId,
    'package': package?.toJson(),
    'start_date': startDate?.toIso8601String(),
    'end_date': endDate?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'is_active': isActive,
    'is_trial': isTrial
  };

  CompanySubscription clone() => CompanySubscription(
    id: id,
    companyId: companyId,
    packageId: packageId,
    package: package?.clone(),
    startDate: startDate,
    endDate: endDate,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isActive: isActive,
    isTrial: isTrial
  );


  CompanySubscription copyWith({
    Optional<String?>? id,
    Optional<String?>? companyId,
    Optional<String?>? packageId,
    Optional<SubscriptionPackage?>? package,
    Optional<DateTime?>? startDate,
    Optional<DateTime?>? endDate,
    Optional<DateTime?>? createdAt,
    Optional<DateTime?>? updatedAt,
    Optional<bool?>? isActive,
    Optional<bool?>? isTrial
  }) => CompanySubscription(
    id: checkOptional(id, () => this.id),
    companyId: checkOptional(companyId, () => this.companyId),
    packageId: checkOptional(packageId, () => this.packageId),
    package: checkOptional(package, () => this.package),
    startDate: checkOptional(startDate, () => this.startDate),
    endDate: checkOptional(endDate, () => this.endDate),
    createdAt: checkOptional(createdAt, () => this.createdAt),
    updatedAt: checkOptional(updatedAt, () => this.updatedAt),
    isActive: checkOptional(isActive, () => this.isActive),
    isTrial: checkOptional(isTrial, () => this.isTrial),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is CompanySubscription && id == other.id && companyId == other.companyId && packageId == other.packageId && package == other.package && startDate == other.startDate && endDate == other.endDate && createdAt == other.createdAt && updatedAt == other.updatedAt && isActive == other.isActive && isTrial == other.isTrial;

  @override
  int get hashCode => id.hashCode ^ companyId.hashCode ^ packageId.hashCode ^ package.hashCode ^ startDate.hashCode ^ endDate.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ isActive.hashCode ^ isTrial.hashCode;
}
