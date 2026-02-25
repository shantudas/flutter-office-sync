import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/geo_constants.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_state.dart';

class DistanceIndicator extends StatefulWidget {
  const DistanceIndicator({super.key});

  @override
  State<DistanceIndicator> createState() => _DistanceIndicatorState();
}

class _DistanceIndicatorState extends State<DistanceIndicator> {
  double _currentDistance = 0;
  bool _currentIsWithinRange = false;
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is LocationValidated) {
          // Update values when new data arrives
          _hasData = true;
          _currentDistance = state.distance;
          _currentIsWithinRange = state.isWithinRange;
        }

        if (!_hasData) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Getting your location...',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final percentage = (_currentDistance / GeoConstants.officeRadiusMeters)
            .clamp(0.0, 1.0)
            .toDouble();

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Apple AirTag-inspired circular distance indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer circle - represents max range
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  // Progress indicator with smooth animation
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey(_currentDistance),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 1 - percentage,
                        end: 1 - percentage,
                      ),
                      builder: (context, value, child) {
                        return CircularProgressIndicator(
                          value: value,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _currentIsWithinRange
                                ? Colors.green
                                : Colors.orange,
                          ),
                        );
                      },
                    ),
                  ),
                  // Center content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          _currentIsWithinRange
                              ? Icons.check_circle
                              : Icons.location_on,
                          key: ValueKey(_currentIsWithinRange),
                          size: 60,
                          color: _currentIsWithinRange
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          DistanceCalculator.formatDistance(_currentDistance),
                          key: ValueKey(_currentDistance),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _currentIsWithinRange
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                      Text(
                        'from office',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Status message with animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _currentIsWithinRange
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _currentIsWithinRange
                        ? Colors.green.withOpacity(0.3)
                        : Colors.orange.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _currentIsWithinRange
                            ? Icons.check_circle
                            : Icons.info_outline,
                        key: ValueKey(_currentIsWithinRange),
                        color: _currentIsWithinRange
                            ? Colors.green
                            : Colors.orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _currentIsWithinRange
                            ? 'Within office range'
                            : 'Move closer to mark attendance',
                        key: ValueKey(_currentIsWithinRange),
                        style: TextStyle(
                          color: _currentIsWithinRange
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!_currentIsWithinRange) ...[
                const SizedBox(height: 8),
                Text(
                  'Required: Within ${GeoConstants.officeRadiusMeters.toInt()}m',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
