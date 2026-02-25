import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';

class PermissionRequestWidget extends StatelessWidget {
  const PermissionRequestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      buildWhen: (previous, current) =>
          current is LocationPermissionDenied ||
          current is LocationServiceDisabled,
      builder: (context, state) {
        String message = 'Checking permissions...';
        IconData icon = Icons.check_circle;
        Color iconColor = Colors.orange;
        VoidCallback? action;

        if (state is LocationPermissionDenied) {
          message = 'Location permission required';
          icon = Icons.location_off;
          iconColor = Colors.red;
          action = () {
            context.read<LocationBloc>().add(RequestPermissionsEvent());
          };
        } else if (state is LocationServiceDisabled) {
          message = 'Please enable GPS/Location services';
          icon = Icons.gps_off;
          iconColor = Colors.orange;
          action = () {
            // Open location settings
            context.read<LocationBloc>().add(OpenLocationSettingsEvent());
          };
        }

        return Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange[200]!, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 80, color: iconColor),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (action != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: action,
                  icon: const Icon(Icons.settings),
                  label: Text(
                    state is LocationServiceDisabled
                        ? 'Enable GPS'
                        : 'Grant Permission',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
