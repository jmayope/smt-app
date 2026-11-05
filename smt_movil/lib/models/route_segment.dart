import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class RouteSegment {

  const RouteSegment({
    this.id,
    this.routeId,
    this.fromPointId,
    this.fromPoint,
    this.toPointId,
    this.toPoint,
    this.segmentOrder,
    this.distanceKm,
    this.estimatedTimeMinutes,
    this.createdAt,
    this.hasRestriction,
  });

  final String? id;
  final String? routeId;
  final String? fromPointId;
  final RoutePoint? fromPoint;
  final String? toPointId;
  final RoutePoint? toPoint;
  final int? segmentOrder;
  final String? distanceKm;
  final int? estimatedTimeMinutes;
  final String? createdAt;
  final bool? hasRestriction;

  factory RouteSegment.fromJson(Map<String,dynamic> json) => RouteSegment(
    id: json['id']?.toString(),
    routeId: json['route_id']?.toString(),
    fromPointId: json['from_point_id']?.toString(),
    fromPoint: json['from_point'] != null ? RoutePoint.fromJson(json['from_point'] as Map<String, dynamic>) : null,
    toPointId: json['to_point_id']?.toString(),
    toPoint: json['to_point'] != null ? RoutePoint.fromJson(json['to_point'] as Map<String, dynamic>) : null,
    segmentOrder: json['segment_order'] != null ? json['segment_order'] as int : null,
    distanceKm: json['distance_km']?.toString(),
    estimatedTimeMinutes: json['estimated_time_minutes'] != null ? json['estimated_time_minutes'] as int : null,
    createdAt: json['created_at']?.toString(),
    hasRestriction: json['has_restriction'] != null ? json['has_restriction'] as bool : null
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'route_id': routeId,
    'from_point_id': fromPointId,
    'from_point': fromPoint?.toJson(),
    'to_point_id': toPointId,
    'to_point': toPoint?.toJson(),
    'segment_order': segmentOrder,
    'distance_km': distanceKm,
    'estimated_time_minutes': estimatedTimeMinutes,
    'created_at': createdAt,
    'has_restriction': hasRestriction
  };

  RouteSegment clone() => RouteSegment(
    id: id,
    routeId: routeId,
    fromPointId: fromPointId,
    fromPoint: fromPoint?.clone(),
    toPointId: toPointId,
    toPoint: toPoint?.clone(),
    segmentOrder: segmentOrder,
    distanceKm: distanceKm,
    estimatedTimeMinutes: estimatedTimeMinutes,
    createdAt: createdAt,
    hasRestriction: hasRestriction
  );


  RouteSegment copyWith({
    Optional<String?>? id,
    Optional<String?>? routeId,
    Optional<String?>? fromPointId,
    Optional<RoutePoint?>? fromPoint,
    Optional<String?>? toPointId,
    Optional<RoutePoint?>? toPoint,
    Optional<int?>? segmentOrder,
    Optional<String?>? distanceKm,
    Optional<int?>? estimatedTimeMinutes,
    Optional<String?>? createdAt,
    Optional<bool?>? hasRestriction
  }) => RouteSegment(
    id: checkOptional(id, () => this.id),
    routeId: checkOptional(routeId, () => this.routeId),
    fromPointId: checkOptional(fromPointId, () => this.fromPointId),
    fromPoint: checkOptional(fromPoint, () => this.fromPoint),
    toPointId: checkOptional(toPointId, () => this.toPointId),
    toPoint: checkOptional(toPoint, () => this.toPoint),
    segmentOrder: checkOptional(segmentOrder, () => this.segmentOrder),
    distanceKm: checkOptional(distanceKm, () => this.distanceKm),
    estimatedTimeMinutes: checkOptional(estimatedTimeMinutes, () => this.estimatedTimeMinutes),
    createdAt: checkOptional(createdAt, () => this.createdAt),
    hasRestriction: checkOptional(hasRestriction, () => this.hasRestriction),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is RouteSegment && id == other.id && routeId == other.routeId && fromPointId == other.fromPointId && fromPoint == other.fromPoint && toPointId == other.toPointId && toPoint == other.toPoint && segmentOrder == other.segmentOrder && distanceKm == other.distanceKm && estimatedTimeMinutes == other.estimatedTimeMinutes && createdAt == other.createdAt && hasRestriction == other.hasRestriction;

  @override
  int get hashCode => id.hashCode ^ routeId.hashCode ^ fromPointId.hashCode ^ fromPoint.hashCode ^ toPointId.hashCode ^ toPoint.hashCode ^ segmentOrder.hashCode ^ distanceKm.hashCode ^ estimatedTimeMinutes.hashCode ^ createdAt.hashCode ^ hasRestriction.hashCode;
}
