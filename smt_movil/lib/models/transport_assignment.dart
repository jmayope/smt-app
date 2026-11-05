import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class TransportAssignment {

  const TransportAssignment({
    this.id,
    this.companyId,
    this.routeId,
    this.route,
    this.vehicleId,
    this.vehicle,
    this.driverId,
    this.driver,
    this.supervisorId,
    this.supervisor,
    this.assignmentDate,
    this.startTime,
    this.endTime,
    this.estimatedStartTime,
    this.estimatedEndTime,
    this.status,
    this.loadWeightTons,
    this.materialType,
    this.createdAt,
    this.updatedAt,
    this.hasDelayed,
    this.isCompleted,
    this.hasIncident,
  });

  final String? id;
  final String? companyId;
  final String? routeId;
  final RouteMap? route;
  final String? vehicleId;
  final Vehicle? vehicle;
  final String? driverId;
  final User? driver;
  final String? supervisorId;
  final User? supervisor;
  final DateTime? assignmentDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? estimatedStartTime;
  final DateTime? estimatedEndTime;
  final String? status;
  final double? loadWeightTons;
  final String? materialType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? hasDelayed;
  final bool? isCompleted;
  final bool? hasIncident;

  factory TransportAssignment.fromJson(Map<String,dynamic> json) => TransportAssignment(
    id: json['id']?.toString(),
    companyId: json['company_id']?.toString(),
    routeId: json['route_id']?.toString(),
    route: json['route'] != null ? RouteMap.fromJson(json['route'] as Map<String, dynamic>) : null,
    vehicleId: json['vehicle_id']?.toString(),
    vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>) : null,
    driverId: json['driver_id']?.toString(),
    driver: json['driver'] != null ? User.fromJson(json['driver'] as Map<String, dynamic>) : null,
    supervisorId: json['supervisor_id']?.toString(),
    supervisor: json['supervisor'] != null ? User.fromJson(json['supervisor'] as Map<String, dynamic>) : null,
    assignmentDate: json['assignment_date'] != null ? DateTime.parse(json['assignment_date'] as String) : null,
    startTime: json['start_time'] != null ? DateTime.parse(json['start_time'] as String) : null,
    endTime: json['end_time'] != null ? DateTime.parse(json['end_time'] as String) : null,
    estimatedStartTime: json['estimated_start_time'] != null ? DateTime.parse(json['estimated_start_time'] as String) : null,
    estimatedEndTime: json['estimated_end_time'] != null ? DateTime.parse(json['estimated_end_time'] as String) : null,
    status: json['status']?.toString(),
    loadWeightTons: json['load_weight_tons'] != null ? (json['load_weight_tons'] as num).toDouble() : null,
    materialType: json['material_type']?.toString(),
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    hasDelayed: json['has_delayed'] != null ? json['has_delayed'] as bool : null,
    isCompleted: json['is_completed'] != null ? json['is_completed'] as bool : null,
    hasIncident: json['has_incident'] != null ? json['has_incident'] as bool : null
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'company_id': companyId,
    'route_id': routeId,
    'route': route?.toJson(),
    'vehicle_id': vehicleId,
    'vehicle': vehicle?.toJson(),
    'driver_id': driverId,
    'driver': driver?.toJson(),
    'supervisor_id': supervisorId,
    'supervisor': supervisor?.toJson(),
    'assignment_date': assignmentDate?.toIso8601String(),
    'start_time': startTime?.toIso8601String(),
    'end_time': endTime?.toIso8601String(),
    'estimated_start_time': estimatedStartTime?.toIso8601String(),
    'estimated_end_time': estimatedEndTime?.toIso8601String(),
    'status': status,
    'load_weight_tons': loadWeightTons,
    'material_type': materialType,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'has_delayed': hasDelayed,
    'is_completed': isCompleted,
    'has_incident': hasIncident
  };

  TransportAssignment clone() => TransportAssignment(
    id: id,
    companyId: companyId,
    routeId: routeId,
    route: route?.clone(),
    vehicleId: vehicleId,
    vehicle: vehicle?.clone(),
    driverId: driverId,
    driver: driver?.clone(),
    supervisorId: supervisorId,
    supervisor: supervisor?.clone(),
    assignmentDate: assignmentDate,
    startTime: startTime,
    endTime: endTime,
    estimatedStartTime: estimatedStartTime,
    estimatedEndTime: estimatedEndTime,
    status: status,
    loadWeightTons: loadWeightTons,
    materialType: materialType,
    createdAt: createdAt,
    updatedAt: updatedAt,
    hasDelayed: hasDelayed,
    isCompleted: isCompleted,
    hasIncident: hasIncident
  );


  TransportAssignment copyWith({
    Optional<String?>? id,
    Optional<String?>? companyId,
    Optional<String?>? routeId,
    Optional<RouteMap?>? route,
    Optional<String?>? vehicleId,
    Optional<Vehicle?>? vehicle,
    Optional<String?>? driverId,
    Optional<User?>? driver,
    Optional<String?>? supervisorId,
    Optional<User?>? supervisor,
    Optional<DateTime?>? assignmentDate,
    Optional<DateTime?>? startTime,
    Optional<DateTime?>? endTime,
    Optional<DateTime?>? estimatedStartTime,
    Optional<DateTime?>? estimatedEndTime,
    Optional<String?>? status,
    Optional<double?>? loadWeightTons,
    Optional<String?>? materialType,
    Optional<DateTime?>? createdAt,
    Optional<DateTime?>? updatedAt,
    Optional<bool?>? hasDelayed,
    Optional<bool?>? isCompleted,
    Optional<bool?>? hasIncident
  }) => TransportAssignment(
    id: checkOptional(id, () => this.id),
    companyId: checkOptional(companyId, () => this.companyId),
    routeId: checkOptional(routeId, () => this.routeId),
    route: checkOptional(route, () => this.route),
    vehicleId: checkOptional(vehicleId, () => this.vehicleId),
    vehicle: checkOptional(vehicle, () => this.vehicle),
    driverId: checkOptional(driverId, () => this.driverId),
    driver: checkOptional(driver, () => this.driver),
    supervisorId: checkOptional(supervisorId, () => this.supervisorId),
    supervisor: checkOptional(supervisor, () => this.supervisor),
    assignmentDate: checkOptional(assignmentDate, () => this.assignmentDate),
    startTime: checkOptional(startTime, () => this.startTime),
    endTime: checkOptional(endTime, () => this.endTime),
    estimatedStartTime: checkOptional(estimatedStartTime, () => this.estimatedStartTime),
    estimatedEndTime: checkOptional(estimatedEndTime, () => this.estimatedEndTime),
    status: checkOptional(status, () => this.status),
    loadWeightTons: checkOptional(loadWeightTons, () => this.loadWeightTons),
    materialType: checkOptional(materialType, () => this.materialType),
    createdAt: checkOptional(createdAt, () => this.createdAt),
    updatedAt: checkOptional(updatedAt, () => this.updatedAt),
    hasDelayed: checkOptional(hasDelayed, () => this.hasDelayed),
    isCompleted: checkOptional(isCompleted, () => this.isCompleted),
    hasIncident: checkOptional(hasIncident, () => this.hasIncident),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is TransportAssignment && id == other.id && companyId == other.companyId && routeId == other.routeId && route == other.route && vehicleId == other.vehicleId && vehicle == other.vehicle && driverId == other.driverId && driver == other.driver && supervisorId == other.supervisorId && supervisor == other.supervisor && assignmentDate == other.assignmentDate && startTime == other.startTime && endTime == other.endTime && estimatedStartTime == other.estimatedStartTime && estimatedEndTime == other.estimatedEndTime && status == other.status && loadWeightTons == other.loadWeightTons && materialType == other.materialType && createdAt == other.createdAt && updatedAt == other.updatedAt && hasDelayed == other.hasDelayed && isCompleted == other.isCompleted && hasIncident == other.hasIncident;

  @override
  int get hashCode => id.hashCode ^ companyId.hashCode ^ routeId.hashCode ^ route.hashCode ^ vehicleId.hashCode ^ vehicle.hashCode ^ driverId.hashCode ^ driver.hashCode ^ supervisorId.hashCode ^ supervisor.hashCode ^ assignmentDate.hashCode ^ startTime.hashCode ^ endTime.hashCode ^ estimatedStartTime.hashCode ^ estimatedEndTime.hashCode ^ status.hashCode ^ loadWeightTons.hashCode ^ materialType.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ hasDelayed.hashCode ^ isCompleted.hashCode ^ hasIncident.hashCode;
}
