import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class Company {

  const Company({
    this.id,
    this.name,
    this.businessType,
    this.ruc,
    this.phone,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.roles,
  });

  final String? id;
  final String? name;
  final String? businessType;
  final String? ruc;
  final String? phone;
  final String? address;
  final String? createdAt;
  final String? updatedAt;
  final bool? isActive;
  final List<UserCompanyRole>? roles;

  factory Company.fromJson(Map<String,dynamic> json) => Company(
    id: json['id']?.toString(),
    name: json['name']?.toString(),
    businessType: json['business_type']?.toString(),
    ruc: json['ruc']?.toString(),
    phone: json['phone']?.toString(),
    address: json['address']?.toString(),
    createdAt: json['created_at']?.toString(),
    updatedAt: json['updated_at']?.toString(),
    isActive: json['is_active'] != null ? json['is_active'] as bool : null,
    roles: json['roles'] != null ? (json['roles'] as List? ?? []).map((e) => UserCompanyRole.fromJson(e as Map<String, dynamic>)).toList() : null
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'business_type': businessType,
    'ruc': ruc,
    'phone': phone,
    'address': address,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'is_active': isActive,
    'roles': roles?.map((e) => e.toJson()).toList()
  };

  Company clone() => Company(
    id: id,
    name: name,
    businessType: businessType,
    ruc: ruc,
    phone: phone,
    address: address,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isActive: isActive,
    roles: roles?.map((e) => e.clone()).toList()
  );


  Company copyWith({
    Optional<String?>? id,
    Optional<String?>? name,
    Optional<String?>? businessType,
    Optional<String?>? ruc,
    Optional<String?>? phone,
    Optional<String?>? address,
    Optional<String?>? createdAt,
    Optional<String?>? updatedAt,
    Optional<bool?>? isActive,
    Optional<List<UserCompanyRole>?>? roles
  }) => Company(
    id: checkOptional(id, () => this.id),
    name: checkOptional(name, () => this.name),
    businessType: checkOptional(businessType, () => this.businessType),
    ruc: checkOptional(ruc, () => this.ruc),
    phone: checkOptional(phone, () => this.phone),
    address: checkOptional(address, () => this.address),
    createdAt: checkOptional(createdAt, () => this.createdAt),
    updatedAt: checkOptional(updatedAt, () => this.updatedAt),
    isActive: checkOptional(isActive, () => this.isActive),
    roles: checkOptional(roles, () => this.roles),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is Company && id == other.id && name == other.name && businessType == other.businessType && ruc == other.ruc && phone == other.phone && address == other.address && createdAt == other.createdAt && updatedAt == other.updatedAt && isActive == other.isActive && roles == other.roles;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ businessType.hashCode ^ ruc.hashCode ^ phone.hashCode ^ address.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ isActive.hashCode ^ roles.hashCode;
}
