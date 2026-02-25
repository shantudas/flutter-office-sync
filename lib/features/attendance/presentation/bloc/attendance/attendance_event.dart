import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class MarkAttendanceEvent extends AttendanceEvent {
  final double latitude;
  final double longitude;
  final double distanceFromOffice;
  final String type;

  const MarkAttendanceEvent({
    required this.latitude,
    required this.longitude,
    required this.distanceFromOffice,
    required this.type,
  });

  @override
  List<Object?> get props => [latitude, longitude, distanceFromOffice, type];
}

class LoadAttendanceHistoryEvent extends AttendanceEvent {}

class DeleteAttendanceEvent extends AttendanceEvent {
  final String id;

  const DeleteAttendanceEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearAllAttendanceEvent extends AttendanceEvent {}
