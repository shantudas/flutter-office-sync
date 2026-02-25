import 'package:flutter/material.dart';
import '../../features/attendance/presentation/pages/attendance_screen.dart';
import '../../features/attendance/presentation/pages/attendance_history_screen.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());
      case '/history':
        return MaterialPageRoute(
          builder: (_) => const AttendanceHistoryScreen(),
        );
      default:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());
    }
  }
}
