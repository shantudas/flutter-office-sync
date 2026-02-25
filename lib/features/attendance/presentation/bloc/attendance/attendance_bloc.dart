import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/clear_all_attendance.dart';
import '../../../domain/usecases/delete_attendance.dart';
import '../../../domain/usecases/get_attendance_history.dart';
import '../../../domain/usecases/mark_attendance.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final MarkAttendance markAttendance;
  final GetAttendanceHistory getAttendanceHistory;
  final DeleteAttendance deleteAttendance;
  final ClearAllAttendance clearAllAttendance;

  AttendanceBloc({
    required this.markAttendance,
    required this.getAttendanceHistory,
    required this.deleteAttendance,
    required this.clearAllAttendance,
  }) : super(AttendanceInitial()) {
    on<MarkAttendanceEvent>(_onMarkAttendance);
    on<LoadAttendanceHistoryEvent>(_onLoadAttendanceHistory);
  }

  Future<void> _onMarkAttendance(
    MarkAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceMarkingInProgress());
    final result = await markAttendance(
      MarkAttendanceParams(
        latitude: event.latitude,
        longitude: event.longitude,
        distanceFromOffice: event.distanceFromOffice,
        type: event.type,
      ),
    );
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (record) => emit(AttendanceMarked(record)),
    );
  }

  Future<void> _onLoadAttendanceHistory(
    LoadAttendanceHistoryEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceHistoryLoading());
    final result = await getAttendanceHistory(NoParams());
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (records) => emit(AttendanceHistoryLoaded(records)),
    );
  }
}
