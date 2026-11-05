import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class Vehicle {

  const Vehicle({
    this.id,
    this.companyId,
    this.licensePlate,
    this.brand,
    this.model,
    this.year,
    this.vehicleType,
    this.capacityTons,
    this.materialType,
    this.color,
    this.vin,
    this.insuranceNumber,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.hasMaintenanceScheduled,
    this.isAvailable,
  });

  final String? id;
  final String? companyId;
  final String? licensePlate;
  final String? brand;
  final String? model;
  final int? year;
  final String? vehicleType;
  final int? capacityTons;
  final String? materialType;
  final String? color;
  final String? vin;
  final String? insuranceNumber;
  final String? createdAt;
  final String? updatedAt;
  final bool? isActive;
  final bool? hasMaintenanceScheduled;
  final bool? isAvailable;

  factory Vehicle.fromJson(Map<String,dynamic> json) => Vehicle(
    id: json['id']?.toString(),
    companyId: json['company_id']?.toString(),
    licensePlate: json['license_plate']?.toString(),
    brand: json['brand']?.toString(),
    model: json['model']?.toString(),
    year: json['year'] != null ? json['year'] as int : null,
    vehicleType: json['vehicle_type']?.toString(),
    capacityTons: json['capacity_tons'] != null ? json['capacity_tons'] as int : null,
    materialType: json['material_type']?.toString(),
    color: json['color']?.toString(),
    vin: json['vin']?.toString(),
    insuranceNumber: json['insurance_number']?.toString(),
    createdAt: json['created_at']?.toString(),
    updatedAt: json['updated_at']?.toString(),
    isActive: json['is_active'] != null ? json['is_active'] as bool : null,
    hasMaintenanceScheduled: json['has_maintenance_scheduled'] != null ? json['has_maintenance_scheduled'] as bool : null,
    isAvailable: json['is_available'] != null ? json['is_available'] as bool : null
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'company_id': companyId,
    'license_plate': licensePlate,
    'brand': brand,
    'model': model,
    'year': year,
    'vehicle_type': vehicleType,
    'capacity_tons': capacityTons,
    'material_type': materialType,
    'color': color,
    'vin': vin,
    'insurance_number': insuranceNumber,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'is_active': isActive,
    'has_maintenance_scheduled': hasMaintenanceScheduled,
    'is_available': isAvailable
  };

  Vehicle clone() => Vehicle(
    id: id,
    companyId: companyId,
    licensePlate: licensePlate,
    brand: brand,
    model: model,
    year: year,
    vehicleType: vehicleType,
    capacityTons: capacityTons,
    materialType: materialType,
    color: color,
    vin: vin,
    insuranceNumber: insuranceNumber,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isActive: isActive,
    hasMaintenanceScheduled: hasMaintenanceScheduled,
    isAvailable: isAvailable
  );


  Vehicle copyWith({
    Optional<String?>? id,
    Optional<String?>? companyId,
    Optional<String?>? licensePlate,
    Optional<String?>? brand,
    Optional<String?>? model,
    Optional<int?>? year,
    Optional<String?>? vehicleType,
    Optional<int?>? capacityTons,
    Optional<String?>? materialType,
    Optional<String?>? color,
    Optional<String?>? vin,
    Optional<String?>? insuranceNumber,
    Optional<String?>? createdAt,
    Optional<String?>? updatedAt,
    Optional<bool?>? isActive,
    Optional<bool?>? hasMaintenanceScheduled,
    Optional<bool?>? isAvailable
  }) => Vehicle(
    id: checkOptional(id, () => this.id),
    companyId: checkOptional(companyId, () => this.companyId),
    licensePlate: checkOptional(licensePlate, () => this.licensePlate),
    brand: checkOptional(brand, () => this.brand),
    model: checkOptional(model, () => this.model),
    year: checkOptional(year, () => this.year),
    vehicleType: checkOptional(vehicleType, () => this.vehicleType),
    capacityTons: checkOptional(capacityTons, () => this.capacityTons),
    materialType: checkOptional(materialType, () => this.materialType),
    color: checkOptional(color, () => this.color),
    vin: checkOptional(vin, () => this.vin),
    insuranceNumber: checkOptional(insuranceNumber, () => this.insuranceNumber),
    createdAt: checkOptional(createdAt, () => this.createdAt),
    updatedAt: checkOptional(updatedAt, () => this.updatedAt),
    isActive: checkOptional(isActive, () => this.isActive),
    hasMaintenanceScheduled: checkOptional(hasMaintenanceScheduled, () => this.hasMaintenanceScheduled),
    isAvailable: checkOptional(isAvailable, () => this.isAvailable),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is Vehicle && id == other.id && companyId == other.companyId && licensePlate == other.licensePlate && brand == other.brand && model == other.model && year == other.year && vehicleType == other.vehicleType && capacityTons == other.capacityTons && materialType == other.materialType && color == other.color && vin == other.vin && insuranceNumber == other.insuranceNumber && createdAt == other.createdAt && updatedAt == other.updatedAt && isActive == other.isActive && hasMaintenanceScheduled == other.hasMaintenanceScheduled && isAvailable == other.isAvailable;

  @override
  int get hashCode => id.hashCode ^ companyId.hashCode ^ licensePlate.hashCode ^ brand.hashCode ^ model.hashCode ^ year.hashCode ^ vehicleType.hashCode ^ capacityTons.hashCode ^ materialType.hashCode ^ color.hashCode ^ vin.hashCode ^ insuranceNumber.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ isActive.hashCode ^ hasMaintenanceScheduled.hashCode ^ isAvailable.hashCode;
}
