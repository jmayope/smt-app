import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class SubscriptionPackage {

  const SubscriptionPackage({
    this.id,
    this.name,
    this.description,
    this.maxUsers,
    this.maxSupervisors,
    this.maxDrivers,
    this.maxVehicles,
    this.price,
    this.createdAt,
    this.isActive,
    this.durationInDays,
  });

  final String? id;
  final String? name;
  final String? description;
  final int? maxUsers;
  final int? maxSupervisors;
  final int? maxDrivers;
  final int? maxVehicles;
  final double? price;
  final DateTime? createdAt;
  final bool? isActive;
  final int? durationInDays;

  factory SubscriptionPackage.fromJson(Map<String,dynamic> json) => SubscriptionPackage(
    id: json['id']?.toString(),
    name: json['name']?.toString(),
    description: json['description']?.toString(),
    maxUsers: json['max_users'] != null ? json['max_users'] as int : null,
    maxSupervisors: json['max_supervisors'] != null ? json['max_supervisors'] as int : null,
    maxDrivers: json['max_drivers'] != null ? json['max_drivers'] as int : null,
    maxVehicles: json['max_vehicles'] != null ? json['max_vehicles'] as int : null,
    price: json['price'] != null ? (json['price'] as num).toDouble() : null,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    isActive: json['is_active'] != null ? json['is_active'] as bool : null,
    durationInDays: json['duration_in_days'] != null ? json['duration_in_days'] as int : null
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'max_users': maxUsers,
    'max_supervisors': maxSupervisors,
    'max_drivers': maxDrivers,
    'max_vehicles': maxVehicles,
    'price': price,
    'created_at': createdAt?.toIso8601String(),
    'is_active': isActive,
    'duration_in_days': durationInDays
  };

  SubscriptionPackage clone() => SubscriptionPackage(
    id: id,
    name: name,
    description: description,
    maxUsers: maxUsers,
    maxSupervisors: maxSupervisors,
    maxDrivers: maxDrivers,
    maxVehicles: maxVehicles,
    price: price,
    createdAt: createdAt,
    isActive: isActive,
    durationInDays: durationInDays
  );


  SubscriptionPackage copyWith({
    Optional<String?>? id,
    Optional<String?>? name,
    Optional<String?>? description,
    Optional<int?>? maxUsers,
    Optional<int?>? maxSupervisors,
    Optional<int?>? maxDrivers,
    Optional<int?>? maxVehicles,
    Optional<double?>? price,
    Optional<DateTime?>? createdAt,
    Optional<bool?>? isActive,
    Optional<int?>? durationInDays
  }) => SubscriptionPackage(
    id: checkOptional(id, () => this.id),
    name: checkOptional(name, () => this.name),
    description: checkOptional(description, () => this.description),
    maxUsers: checkOptional(maxUsers, () => this.maxUsers),
    maxSupervisors: checkOptional(maxSupervisors, () => this.maxSupervisors),
    maxDrivers: checkOptional(maxDrivers, () => this.maxDrivers),
    maxVehicles: checkOptional(maxVehicles, () => this.maxVehicles),
    price: checkOptional(price, () => this.price),
    createdAt: checkOptional(createdAt, () => this.createdAt),
    isActive: checkOptional(isActive, () => this.isActive),
    durationInDays: checkOptional(durationInDays, () => this.durationInDays),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is SubscriptionPackage && id == other.id && name == other.name && description == other.description && maxUsers == other.maxUsers && maxSupervisors == other.maxSupervisors && maxDrivers == other.maxDrivers && maxVehicles == other.maxVehicles && price == other.price && createdAt == other.createdAt && isActive == other.isActive && durationInDays == other.durationInDays;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode ^ maxUsers.hashCode ^ maxSupervisors.hashCode ^ maxDrivers.hashCode ^ maxVehicles.hashCode ^ price.hashCode ^ createdAt.hashCode ^ isActive.hashCode ^ durationInDays.hashCode;
}
