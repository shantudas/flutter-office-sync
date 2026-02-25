import 'package:equatable/equatable.dart';
import '../../../domain/entities/attendance_record.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceMarkingInProgress extends AttendanceState {}

class AttendanceHistoryLoading extends AttendanceState {}

class AttendanceMarked extends AttendanceState {
  final AttendanceRecord record;

  const AttendanceMarked(this.record);

  @override
  List<Object?> get props => [record];
}

class AttendanceHistoryLoaded extends AttendanceState {
  final List<AttendanceRecord> records;

  const AttendanceHistoryLoaded(this.records);

  @override
  List<Object?> get props => [records];
}

class AttendanceDeleted extends AttendanceState {}

class AttendanceCleared extends AttendanceState {}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
