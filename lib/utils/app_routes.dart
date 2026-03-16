import 'package:flutter/material.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/equipment_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/floor_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/admin_drawer/app_user.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/admin_drawer/equipment_history.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/admin_drawer/equipment_management.dart';
import 'package:zedbee_bms/pages_folder/home_drawer/reports.dart';
import 'package:zedbee_bms/pages_folder/screens/building_list.dart';
import 'package:zedbee_bms/pages_folder/screens/device_monitor.dart';
import 'package:zedbee_bms/pages_folder/screens/floor_list.dart';
import 'package:zedbee_bms/pages_folder/screens/location_list.dart';
import 'package:zedbee_bms/pages_folder/screens/login_screen.dart';
import 'package:zedbee_bms/pages_folder/screens/splash_screen.dart';


class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String locationList = '/locationList';
  static const String buildinglist = '/buildinglist';
  static const String floorlist = '/floorlist';
  static const String devicemonitor = '/devicemonitor';
  static const String reports = '/reports';
  static const String appuser = '/appuser';
  static const String equipmentlist = '/equipmentlist';
  static const String equipmenthistory = '/equipmenthistory';
  static const String energysummary = '/energysummary';

  // Routes WITHOUT arguments
  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    reports: (_) => const Reports(),
  };

  // Routes WITH arguments
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case locationList:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => LocationList(
            userModel: args['user'] as UserModel,
          ),
        );

      case buildinglist:
        final args = settings.arguments as Map<String, dynamic>;
        final building = args['building'] as BuildingModel;
        final user = args['user'] as UserModel;

        return MaterialPageRoute(
          builder: (_) =>
              BuildingList(buildingModel: building, userModel: user),
        );

      case floorlist:
        if (args == null || args['building'] == null || args['user'] == null) {
          return _errorRoute();
        }

        return MaterialPageRoute(
          builder: (_) => FloorList(
            buildingModel: args['building'] as BuildingModel,
            userModel: args['user'] as UserModel,
          ),
        );

      case devicemonitor:
        if (args == null ||
            args['floor'] == null ||
            args['building'] == null ||
            args['user'] == null) {
          return _errorRoute();
        }

        return MaterialPageRoute(
          builder: (_) => DeviceMonitor(
            userModel: args['user'] as UserModel,
            floorModel: args['floor'] as FloorModel,
            buildingModel: args['building'] as BuildingModel,
            // equipmentModel: args['equipment'] as EquipmentModel,
          ),
        );

      case appuser:
        if (args == null) return _errorRoute();

        return MaterialPageRoute(
          builder: (_) => AppUser(userModel: args['user'] as UserModel),
        );

      case equipmentlist:
        if (args == null || args['user'] == null || args['building'] == null) {
          return _errorRoute();
        }

        return MaterialPageRoute(
          builder: (_) => EquipmentScreen(
            userModel: args['user'] as UserModel,
            buildingModel: args['building'] as BuildingModel,
          ),
        );

      case equipmenthistory:
        if (args == null ||
            args['user'] == null ||
            args['building'] == null ||
            args['equpiment'] == null) {
          return _errorRoute();
        }

        return MaterialPageRoute(
          builder: (_) => EquipmentHistory(
            userModel: args['user'] as UserModel,
            buildingModel: args['building'] as BuildingModel,
            equipmentModel: args['equpiment'] as EquipmentModel,
          ),
        );

      default:
        return _errorRoute();
    }
  }

  // Fallback route to avoid crashes
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) => const SplashScreen());
  }
}
