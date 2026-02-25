import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart';
import 'config/routes/app_routes.dart';
import 'config/theme/app_theme.dart';
import 'features/location/presentation/bloc/location_bloc.dart';
import 'features/attendance/presentation/bloc/attendance/attendance_bloc.dart';
import 'features/attendance/presentation/pages/attendance_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocationBloc>()),
        BlocProvider(create: (_) => getIt<AttendanceBloc>()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: '/',
        home: const AttendanceScreen(),
      ),
    );
  }
}
