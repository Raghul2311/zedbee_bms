import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/building_bloc/building_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/equipment_list/equipmentlist_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/floor_bloc/floor_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/roomlist_bloc/roomlist_bloc.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'package:zedbee_bms/utils/app_routes.dart';
import 'package:zedbee_bms/utils/local_storage.dart';
import 'bloc_folder/bloc/login_bloc/auth_bloc.dart';
import 'bloc_folder/bloc/theme_bloc/themes_bloc.dart';
import 'bloc_folder/bloc/theme_bloc/themes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyRoot());
}

// ORIENTATION CONTROLLER ....
class MyRoot extends StatelessWidget {
  const MyRoot({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortestSide = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        const tabletBreakpoint = 600;

        if (shortestSide < tabletBreakpoint) {
          //  MOBILE → Portrait only
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        } else {
          //  TABLET → Landscape only
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        }
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthService>(create: (_) => AuthService()),
            RepositoryProvider<LocalStorage>(create: (_) => LocalStorage()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(context.read<AuthService>()),
              ),
              BlocProvider<BuildingBloc>(
                create: (context) => BuildingBloc(
                  context.read<AuthService>(),
                  context.read<LocalStorage>(),
                ),
              ),
              BlocProvider<FloorBloc>(
                create: (context) => FloorBloc(context.read<AuthService>()),
              ),
              BlocProvider<EquipmentBloc>(
                create: (context) => EquipmentBloc(context.read<AuthService>()),
              ),
              BlocProvider<RoomListBloc>(
                create: (context) => RoomListBloc(context.read<AuthService>()),
              ),
            ],
            child: const MyApp(),
          ),
        );
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Zedbee BMS',
              theme: state.themeData,
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRoutes.onGenerateRoute,
              routes: AppRoutes.routes,
              home: child,
            );
          },
        );
      },
      child: const SizedBox(),
    );
  }
}
