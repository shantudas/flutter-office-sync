import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/geo_constants.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../location/presentation/bloc/location_event.dart';
import '../../../location/presentation/bloc/location_state.dart';
import '../bloc/attendance/attendance_bloc.dart';
import '../bloc/attendance/attendance_state.dart';
import '../../../location/presentation/widgets/permission_request_widget.dart';
import '../../../location/presentation/widgets/setup_location_widget.dart';
import '../../../location/presentation/widgets/distance_indicator.dart';
import '../widgets/attendance_button.dart';
import '../widgets/loading_indicator.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Check permissions first, then load office location
    _initializeScreen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    context.read<LocationBloc>().add(StopLocationTrackingEvent());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When app comes back to foreground (e.g., after opening settings)
    if (state == AppLifecycleState.resumed) {
      // Re-check permissions and location service
      context.read<LocationBloc>().add(CheckPermissionsEvent());
    }
  }

  void _initializeScreen() {
    // Check permissions and location service
    context.read<LocationBloc>().add(CheckPermissionsEvent());
    // Try to load office location
    context.read<LocationBloc>().add(LoadOfficeLocationEvent());
  }

  void _startLocationTracking() {
    context.read<LocationBloc>().add(StartLocationTrackingEvent());
  }

  void _stopLocationTracking() {
    context.read<LocationBloc>().add(StopLocationTrackingEvent());
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Office Location?'),
        content: const Text(
          'This will clear your current office location. You will need to set it again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<LocationBloc>().add(ResetOfficeLocationEvent());
              Navigator.pop(ctx);
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Office Sync'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Attendance History',
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
          BlocBuilder<LocationBloc, LocationState>(
            buildWhen: (previous, current) =>
                current is OfficeLocationLoadedState ||
                current is LocationValidated,
            builder: (context, state) {
              if (state is OfficeLocationLoadedState ||
                  state is LocationValidated) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset Office Location',
                  onPressed: _showResetDialog,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocListener<LocationBloc, LocationState>(
        listenWhen: (previous, current) =>
            current is CurrentLocationLoaded ||
            current is OfficeLocationSaved ||
            current is OfficeLocationReset ||
            current is LocationError,
        listener: (context, state) {
          if (state is CurrentLocationLoaded) {
            // Auto-save the location as office location
            context.read<LocationBloc>().add(
              SaveOfficeLocationEvent(
                latitude: state.latitude,
                longitude: state.longitude,
                radius: GeoConstants.officeRadiusMeters,
              ),
            );
          } else if (state is OfficeLocationSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Office location saved successfully!'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            // Start live distance tracking
            _startLocationTracking();
          } else if (state is OfficeLocationReset) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Office location reset'),
                  ],
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            // Reload to show setup screen
            _stopLocationTracking();
            context.read<LocationBloc>().add(LoadOfficeLocationEvent());
          } else if (state is LocationError) {
            if (!state.message.contains('not found')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          }
        },
        child: BlocListener<AttendanceBloc, AttendanceState>(
          listenWhen: (previous, current) =>
              current is AttendanceMarked || current is AttendanceError,
          listener: (context, state) {
            if (state is AttendanceMarked) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Attendance marked successfully!'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              // Refresh location after marking attendance
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  context.read<LocationBloc>().add(ValidateGeoFenceEvent());
                }
              });
            } else if (state is AttendanceError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          child: _buildBody(),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    return BlocBuilder<LocationBloc, LocationState>(
      buildWhen: (previous, current) {
        // Rebuild only when state actually changes
        return current is LocationLoading ||
            current is LocationPermissionDenied ||
            current is LocationServiceDisabled ||
            current is LocationError ||
            current is OfficeLocationLoadedState ||
            current is LocationValidated ||
            current is LocationInitial;
      },
      builder: (context, state) {
        // Handle loading state
        if (state is LocationLoading) {
          return const LoadingIndicator(message: 'Loading...');
        }

        // Handle permission denied
        if (state is LocationPermissionDenied) {
          return const PermissionRequestWidget();
        }

        // Handle GPS disabled
        if (state is LocationServiceDisabled) {
          return const PermissionRequestWidget();
        }

        // Handle location validation (live tracking)
        if (state is LocationValidated) {
          return Column(
            children: [
              const Expanded(child: DistanceIndicator()),
              const SizedBox(height: 100), // Space for FAB
            ],
          );
        }

        // Handle office location loaded but not yet validated
        if (state is OfficeLocationLoadedState) {
          // Auto-trigger tracking to start live updates
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _startLocationTracking();
            }
          });
          // Show distance indicator while loading first location
          return Column(
            children: [
              const Expanded(child: DistanceIndicator()),
              const SizedBox(height: 100),
            ],
          );
        }

        // Handle no office location (setup phase)
        if (state is LocationError && state.message.contains('not found')) {
          _stopLocationTracking();
          return const SetupLocationWidget();
        }

        // Default: Show setup
        _stopLocationTracking();
        return const SetupLocationWidget();
      },
    );
  }

  Widget? _buildFloatingActionButton() {
    return BlocBuilder<LocationBloc, LocationState>(
      buildWhen: (previous, current) => current is LocationValidated,
      builder: (context, state) {
        if (state is LocationValidated) {
          return const AttendanceButton();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
