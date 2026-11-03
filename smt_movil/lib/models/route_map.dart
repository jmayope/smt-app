import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class RouteMap {

  const RouteMap({
    this.id,
    this.companyId,
    this.name,
    this.startLocation,
    this.endLocation,
    this.distanceKm,
    this.estimatedDurationHours,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.isPriority,
    this.progressText,
  });

  final String? id;
  final String? companyId;
  final String? name;
  final String? startLocation;
  final String? endLocation;
  final String? distanceKm;
  final String? estimatedDurationHours;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  final bool? isActive;
  final bool? isPriority;
  final String? progressText;

  factory RouteMap.fromJson(Map<String,dynamic> json) => RouteMap(
    id: json['id']?.toString(),
    companyId: json['company_id']?.toString(),
    name: json['name']?.toString(),
    startLocation: json['start_location']?.toString(),
    endLocation: json['end_location']?.toString(),
    distanceKm: json['distance_km']?.toString(),
    estimatedDurationHours: json['estimated_duration_hours']?.toString(),
    description: json['description']?.toString(),
    createdAt: json['created_at']?.toString(),
    updatedAt: json['updated_at']?.toString(),
    isActive: json['is_active'] != null ? json['is_active'] as bool : null,
    isPriority: json['is_priority'] != null ? json['is_priority'] as bool : null,
    progressText: json['progress_text']?.toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'company_id': companyId,
    'name': name,
    'start_location': startLocation,
    'end_location': endLocation,
    'distance_km': distanceKm,
    'estimated_duration_hours': estimatedDurationHours,
    'description': description,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'is_active': isActive,
    'is_priority': isPriority,
    'progress_text': progressText
  };

  RouteMap clone() => RouteMap(
    id: id,
    companyId: companyId,
    name: name,
    startLocation: startLocation,
    endLocation: endLocation,
    distanceKm: distanceKm,
    estimatedDurationHours: estimatedDurationHours,
    description: description,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isActive: isActive,
    isPriority: isPriority,
    progressText: progressText
  );


  RouteMap copyWith({
    Optional<String?>? id,
    Optional<String?>? companyId,
    Optional<String?>? name,
    Optional<String?>? startLocation,
    Optional<String?>? endLocation,
    Optional<String?>? distanceKm,
    Optional<String?>? estimatedDurationHours,
    Optional<String?>? description,
    Optional<String?>? createdAt,
    Optional<String?>? updatedAt,
    Optional<bool?>? isActive,
    Optional<bool?>? isPriority,
    Optional<String?>? progressText
  }) => RouteMap(
    id: checkOptional(id, () => this.id),
    companyId: checkOptional(companyId, () => this.companyId),
    name: checkOptional(name, () => this.name),
    startLocation: checkOptional(startLocation, () => this.startLocation),
    endLocation: checkOptional(endLocation, () => this.endLocation),
    distanceKm: checkOptional(distanceKm, () => this.distanceKm),
    estimatedDurationHours: checkOptional(estimatedDurationHours, () => this.estimatedDurationHours),
    description: checkOptional(description, () => this.description),
    createdAt: checkOptional(createdAt, () => this.createdAt),
    updatedAt: checkOptional(updatedAt, () => this.updatedAt),
    isActive: checkOptional(isActive, () => this.isActive),
    isPriority: checkOptional(isPriority, () => this.isPriority),
    progressText: checkOptional(progressText, () => this.progressText),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is RouteMap && id == other.id && companyId == other.companyId && name == other.name && startLocation == other.startLocation && endLocation == other.endLocation && distanceKm == other.distanceKm && estimatedDurationHours == other.estimatedDurationHours && description == other.description && createdAt == other.createdAt && updatedAt == other.updatedAt && isActive == other.isActive && isPriority == other.isPriority && progressText == other.progressText;

  @override
  int get hashCode => id.hashCode ^ companyId.hashCode ^ name.hashCode ^ startLocation.hashCode ^ endLocation.hashCode ^ distanceKm.hashCode ^ estimatedDurationHours.hashCode ^ description.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ isActive.hashCode ^ isPriority.hashCode ^ progressText.hashCode;
}
