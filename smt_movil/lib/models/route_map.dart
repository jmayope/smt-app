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
    this.points,
    this.currentSegment,
    this.segments,
  });

  final String? id;
  final String? companyId;
  final String? name;
  final String? startLocation;
  final String? endLocation;
  final double? distanceKm;
  final String? estimatedDurationHours;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final bool? isPriority;
  final String? progressText;
  final List<RoutePoint>? points;
  final RouteSegment? currentSegment;
  final List<RouteSegment>? segments;

  factory RouteMap.fromJson(Map<String,dynamic> json) => RouteMap(
    id: json['id']?.toString(),
    companyId: json['company_id']?.toString(),
    name: json['name']?.toString(),
    startLocation: json['start_location']?.toString(),
    endLocation: json['end_location']?.toString(),
    distanceKm: json['distance_km'] != null ? (json['distance_km'] as num).toDouble() : null,
    estimatedDurationHours: json['estimated_duration_hours']?.toString(),
    description: json['description']?.toString(),
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    isActive: json['is_active'] != null ? json['is_active'] as bool : null,
    isPriority: json['is_priority'] != null ? json['is_priority'] as bool : null,
    progressText: json['progress_text']?.toString(),
    points: json['points'] != null ? (json['points'] as List? ?? []).map((e) => RoutePoint.fromJson(e as Map<String, dynamic>)).toList() : null,
    currentSegment: json['current_segment'] != null ? RouteSegment.fromJson(json['current_segment'] as Map<String, dynamic>) : null,
    segments: json['segments'] != null ? (json['segments'] as List? ?? []).map((e) => RouteSegment.fromJson(e as Map<String, dynamic>)).toList() : null
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
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'is_active': isActive,
    'is_priority': isPriority,
    'progress_text': progressText,
    'points': points?.map((e) => e.toJson()).toList(),
    'current_segment': currentSegment?.toJson(),
    'segments': segments?.map((e) => e.toJson()).toList()
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
    progressText: progressText,
    points: points?.map((e) => e.clone()).toList(),
    currentSegment: currentSegment?.clone(),
    segments: segments?.map((e) => e.clone()).toList()
  );


  RouteMap copyWith({
    Optional<String?>? id,
    Optional<String?>? companyId,
    Optional<String?>? name,
    Optional<String?>? startLocation,
    Optional<String?>? endLocation,
    Optional<double?>? distanceKm,
    Optional<String?>? estimatedDurationHours,
    Optional<String?>? description,
    Optional<DateTime?>? createdAt,
    Optional<DateTime?>? updatedAt,
    Optional<bool?>? isActive,
    Optional<bool?>? isPriority,
    Optional<String?>? progressText,
    Optional<List<RoutePoint>?>? points,
    Optional<RouteSegment?>? currentSegment,
    Optional<List<RouteSegment>?>? segments
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
    points: checkOptional(points, () => this.points),
    currentSegment: checkOptional(currentSegment, () => this.currentSegment),
    segments: checkOptional(segments, () => this.segments),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is RouteMap && id == other.id && companyId == other.companyId && name == other.name && startLocation == other.startLocation && endLocation == other.endLocation && distanceKm == other.distanceKm && estimatedDurationHours == other.estimatedDurationHours && description == other.description && createdAt == other.createdAt && updatedAt == other.updatedAt && isActive == other.isActive && isPriority == other.isPriority && progressText == other.progressText && points == other.points && currentSegment == other.currentSegment && segments == other.segments;

  @override
  int get hashCode => id.hashCode ^ companyId.hashCode ^ name.hashCode ^ startLocation.hashCode ^ endLocation.hashCode ^ distanceKm.hashCode ^ estimatedDurationHours.hashCode ^ description.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ isActive.hashCode ^ isPriority.hashCode ^ progressText.hashCode ^ points.hashCode ^ currentSegment.hashCode ^ segments.hashCode;
}
