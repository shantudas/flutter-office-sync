import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../location/presentation/bloc/location_state.dart';
import '../bloc/attendance/attendance_bloc.dart';
import '../bloc/attendance/attendance_event.dart';
import '../bloc/attendance/attendance_state.dart';

class AttendanceButton extends StatelessWidget {
  const AttendanceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      buildWhen: (previous, current) => current is LocationValidated,
      builder: (context, locationState) {
        if (locationState is! LocationValidated) {
          return const SizedBox.shrink();
        }

        final isWithinRange = locationState.isWithinRange;
        final distance = locationState.distance;
        final officeLocation = locationState.officeLocation;

        return BlocBuilder<AttendanceBloc, AttendanceState>(
          buildWhen: (previous, current) =>
              current is AttendanceMarkingInProgress ||
              current is AttendanceMarked ||
              current is AttendanceError ||
              current is AttendanceInitial,
          builder: (context, attendanceState) {
            final isLoading = attendanceState is AttendanceMarkingInProgress;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                onPressed: isWithinRange && !isLoading
                    ? () {
                        context.read<AttendanceBloc>().add(
                          MarkAttendanceEvent(
                            latitude: officeLocation.latitude,
                            longitude: officeLocation.longitude,
                            distanceFromOffice: distance,
                            type: 'check-in',
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isWithinRange ? Colors.green : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: isWithinRange ? 8 : 2,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    else
                      const Icon(Icons.check_circle, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      isLoading ? 'Marking...' : 'Mark Attendance',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
