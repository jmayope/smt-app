import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class TransportLog {

  const TransportLog({
    this.id,
    this.assignmentId,
    this.routePointId,
    this.timestamp,
    this.location,
    this.eventType,
    this.latitude,
    this.longitude,
    this.notes,
    this.createdAt,
    this.hasIssue,
    this.isVerified,
  });

  final String? id;
  final String? assignmentId;
  final String? routePointId;
  final DateTime? timestamp;
  final String? location;
  final String? eventType;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final DateTime? createdAt;
  final bool? hasIssue;
  final bool? isVerified;

  factory TransportLog.fromJson(Map<String,dynamic> json) => TransportLog(
    id: json['id']?.toString(),
    assignmentId: json['assignment_id']?.toString(),
    routePointId: json['route_point_id']?.toString(),
    timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
    location: json['location']?.toString(),
    eventType: json['event_type']?.toString(),
    latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
    longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    notes: json['notes']?.toString(),
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    hasIssue: json['has_issue'] != null ? json['has_issue'] as bool : null,
    isVerified: json['is_verified'] != null ? json['is_verified'] as bool : null
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'assignment_id': assignmentId,
    'route_point_id': routePointId,
    'timestamp': timestamp?.toIso8601String(),
    'location': location,
    'event_type': eventType,
    'latitude': latitude,
    'longitude': longitude,
    'notes': notes,
    'created_at': createdAt?.toIso8601String(),
    'has_issue': hasIssue,
    'is_verified': isVerified
  };

  TransportLog clone() => TransportLog(
    id: id,
    assignmentId: assignmentId,
    routePointId: routePointId,
    timestamp: timestamp,
    location: location,
    eventType: eventType,
    latitude: latitude,
    longitude: longitude,
    notes: notes,
    createdAt: createdAt,
    hasIssue: hasIssue,
    isVerified: isVerified
  );


  TransportLog copyWith({
    Optional<String?>? id,
    Optional<String?>? assignmentId,
    Optional<String?>? routePointId,
    Optional<DateTime?>? timestamp,
    Optional<String?>? location,
    Optional<String?>? eventType,
    Optional<double?>? latitude,
    Optional<double?>? longitude,
    Optional<String?>? notes,
    Optional<DateTime?>? createdAt,
    Optional<bool?>? hasIssue,
    Optional<bool?>? isVerified
  }) => TransportLog(
    id: checkOptional(id, () => this.id),
    assignmentId: checkOptional(assignmentId, () => this.assignmentId),
    routePointId: checkOptional(routePointId, () => this.routePointId),
    timestamp: checkOptional(timestamp, () => this.timestamp),
    location: checkOptional(location, () => this.location),
    eventType: checkOptional(eventType, () => this.eventType),
    latitude: checkOptional(latitude, () => this.latitude),
    longitude: checkOptional(longitude, () => this.longitude),
    notes: checkOptional(notes, () => this.notes),
    createdAt: checkOptional(createdAt, () => this.createdAt),
    hasIssue: checkOptional(hasIssue, () => this.hasIssue),
    isVerified: checkOptional(isVerified, () => this.isVerified),
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is TransportLog && id == other.id && assignmentId == other.assignmentId && routePointId == other.routePointId && timestamp == other.timestamp && location == other.location && eventType == other.eventType && latitude == other.latitude && longitude == other.longitude && notes == other.notes && createdAt == other.createdAt && hasIssue == other.hasIssue && isVerified == other.isVerified;

  @override
  int get hashCode => id.hashCode ^ assignmentId.hashCode ^ routePointId.hashCode ^ timestamp.hashCode ^ location.hashCode ^ eventType.hashCode ^ latitude.hashCode ^ longitude.hashCode ^ notes.hashCode ^ createdAt.hashCode ^ hasIssue.hashCode ^ isVerified.hashCode;
}
