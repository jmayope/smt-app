import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class RoutePoint {

  const RoutePoint({
    this.id,
    this.routeId,
    this.pointCode,
    this.pointType,
    this.name,
    this.latitude,
    this.longitude,
    this.address,
    this.sequenceOrder,
    this.createdAt,
    this.estimatedArrivalMinutes,
  });

  final String? id;
  final String? routeId;
  final String? pointCode;
  final String? pointType;
  final String? name;
  final double? latitude;
  final double? longitude;
  final String? address;
  final int? sequenceOrder;
  final DateTime? createdAt;
  final int? estimatedArrivalMinutes;

  factory RoutePoint.fromJson(Map<String,dynamic> json) => RoutePoint(
    id: json['id']?.toString(),
    routeId: json['route_id']?.toString(),
    pointCode: json['point_code']?.toString(),
    pointType: json['point_type']?.toString(),
    name: json['name']?.toString(),
    latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
    longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    address: json['address']?.toString(),
    sequenceOrder: json['sequence_order'] != null ? json['sequence_order'] as int : null,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    estimatedArrivalMinutes: json['estimated_arrival_minutes'] != null ? json['estimated_arrival_minutes'] as int : null
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'route_id': routeId,
    'point_code': pointCode,
    'point_type': pointType,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'sequence_order': sequenceOrder,
    'created_at': createdAt?.toIso8601String(),
    'estimated_arrival_minutes': estimatedArrivalMinutes
  };

  RoutePoint clone() => RoutePoint(
    id: id,
    routeId: routeId,
    pointCode: pointCode,
    pointType: pointType,
    name: name,
    latitude: latitude,
    longitude: longitude,
    address: address,
    sequenceOrder: sequenceOrder,
    createdAt: createdAt,
    estimatedArrivalMinutes: estimatedArrivalMinutes
  );


  RoutePoint copyWith({
    Optional<String?>? id,
    Optional<String?>? routeId,
    Optional<String?>? pointCode,
    Optional<String?>? pointType,
    Optional<String?>? name,
    Optional<double?>? latitude,
    Optional<double?>? longitude,
    Optional<String?>? address,
    Optional<int?>? sequenceOrder,
    Optional<DateTime?>? createdAt,
    Optional<int?>? estimatedArrivalMinutes
  }) => RoutePoint(
    id: checkOptional(id, () => this.id),
    routeId: checkOptional(routeId, () => this.routeId),
    pointCode: checkOptional(pointCode, () => this.pointCode),
    pointType: checkOptional(pointType, () => this.pointType),
    name: checkOptional(name, () => this.name),
    latitude: checkOptional(latitude, () => this.latitude),
    longitude: checkOptional(longitude, () => this.longitude),
    address: checkOptional(address, () => this.address),
    sequenceOrder: checkOptional(sequenceOrder, () => this.sequenceOrder),
    createdAt: checkOptional(createdAt, () => this.createdAt),
    estimatedArrivalMinutes: checkOptional(estimatedArrivalMinutes, () => this.estimatedArrivalMinutes),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is RoutePoint && id == other.id && routeId == other.routeId && pointCode == other.pointCode && pointType == other.pointType && name == other.name && latitude == other.latitude && longitude == other.longitude && address == other.address && sequenceOrder == other.sequenceOrder && createdAt == other.createdAt && estimatedArrivalMinutes == other.estimatedArrivalMinutes;

  @override
  int get hashCode => id.hashCode ^ routeId.hashCode ^ pointCode.hashCode ^ pointType.hashCode ^ name.hashCode ^ latitude.hashCode ^ longitude.hashCode ^ address.hashCode ^ sequenceOrder.hashCode ^ createdAt.hashCode ^ estimatedArrivalMinutes.hashCode;
}
