import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class User {

  const User({
    this.id,
    this.companyId,
    this.email,
    this.passwordHash,
    this.firstName,
    this.lastName,
    this.documentId,
    this.phone,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.isActive,
    this.has2fa,
    this.currentCompany,
    this.currentRole,
    this.companies,
  });

  final String? id;
  final String? companyId;
  final String? email;
  final String? passwordHash;
  final String? firstName;
  final String? lastName;
  final String? documentId;
  final String? phone;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;
  final bool? isActive;
  final bool? has2fa;
  final Company? currentCompany;
  final UserCompanyRole? currentRole;
  final List<Company>? companies;

  factory User.fromJson(Map<String,dynamic> json) => User(
    id: json['id']?.toString(),
    companyId: json['company_id']?.toString(),
    email: json['email']?.toString(),
    passwordHash: json['password_hash']?.toString(),
    firstName: json['first_name']?.toString(),
    lastName: json['last_name']?.toString(),
    documentId: json['document_id']?.toString(),
    phone: json['phone']?.toString(),
    role: json['role']?.toString(),
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login'] as String) : null,
    isActive: json['is_active'] != null ? json['is_active'] as bool : null,
    has2fa: json['has_2fa'] != null ? json['has_2fa'] as bool : null,
    currentCompany: json['currentCompany'] != null ? Company.fromJson(json['currentCompany'] as Map<String, dynamic>) : null,
    currentRole: json['currentRole'] != null ? UserCompanyRole.fromJson(json['currentRole'] as Map<String, dynamic>) : null,
    companies: json['companies'] != null ? (json['companies'] as List? ?? []).map((e) => Company.fromJson(e as Map<String, dynamic>)).toList() : null
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'company_id': companyId,
    'email': email,
    'password_hash': passwordHash,
    'first_name': firstName,
    'last_name': lastName,
    'document_id': documentId,
    'phone': phone,
    'role': role,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'last_login': lastLogin?.toIso8601String(),
    'is_active': isActive,
    'has_2fa': has2fa,
    'currentCompany': currentCompany?.toJson(),
    'currentRole': currentRole?.toJson(),
    'companies': companies?.map((e) => e.toJson()).toList()
  };

  User clone() => User(
    id: id,
    companyId: companyId,
    email: email,
    passwordHash: passwordHash,
    firstName: firstName,
    lastName: lastName,
    documentId: documentId,
    phone: phone,
    role: role,
    createdAt: createdAt,
    updatedAt: updatedAt,
    lastLogin: lastLogin,
    isActive: isActive,
    has2fa: has2fa,
    currentCompany: currentCompany?.clone(),
    currentRole: currentRole?.clone(),
    companies: companies?.map((e) => e.clone()).toList()
  );


  User copyWith({
    Optional<String?>? id,
    Optional<String?>? companyId,
    Optional<String?>? email,
    Optional<String?>? passwordHash,
    Optional<String?>? firstName,
    Optional<String?>? lastName,
    Optional<String?>? documentId,
    Optional<String?>? phone,
    Optional<String?>? role,
    Optional<DateTime?>? createdAt,
    Optional<DateTime?>? updatedAt,
    Optional<DateTime?>? lastLogin,
    Optional<bool?>? isActive,
    Optional<bool?>? has2fa,
    Optional<Company?>? currentCompany,
    Optional<UserCompanyRole?>? currentRole,
    Optional<List<Company>?>? companies
  }) => User(
    id: checkOptional(id, () => this.id),
    companyId: checkOptional(companyId, () => this.companyId),
    email: checkOptional(email, () => this.email),
    passwordHash: checkOptional(passwordHash, () => this.passwordHash),
    firstName: checkOptional(firstName, () => this.firstName),
    lastName: checkOptional(lastName, () => this.lastName),
    documentId: checkOptional(documentId, () => this.documentId),
    phone: checkOptional(phone, () => this.phone),
    role: checkOptional(role, () => this.role),
    createdAt: checkOptional(createdAt, () => this.createdAt),
    updatedAt: checkOptional(updatedAt, () => this.updatedAt),
    lastLogin: checkOptional(lastLogin, () => this.lastLogin),
    isActive: checkOptional(isActive, () => this.isActive),
    has2fa: checkOptional(has2fa, () => this.has2fa),
    currentCompany: checkOptional(currentCompany, () => this.currentCompany),
    currentRole: checkOptional(currentRole, () => this.currentRole),
    companies: checkOptional(companies, () => this.companies),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is User && id == other.id && companyId == other.companyId && email == other.email && passwordHash == other.passwordHash && firstName == other.firstName && lastName == other.lastName && documentId == other.documentId && phone == other.phone && role == other.role && createdAt == other.createdAt && updatedAt == other.updatedAt && lastLogin == other.lastLogin && isActive == other.isActive && has2fa == other.has2fa && currentCompany == other.currentCompany && currentRole == other.currentRole && companies == other.companies;

  @override
  int get hashCode => id.hashCode ^ companyId.hashCode ^ email.hashCode ^ passwordHash.hashCode ^ firstName.hashCode ^ lastName.hashCode ^ documentId.hashCode ^ phone.hashCode ^ role.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ lastLogin.hashCode ^ isActive.hashCode ^ has2fa.hashCode ^ currentCompany.hashCode ^ currentRole.hashCode ^ companies.hashCode;
}
