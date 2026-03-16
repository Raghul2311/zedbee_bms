import 'package:flutter/material.dart';

enum DeviceStatus { reporting, notReporting, unknown }

class DeviceStatusHelper {
  /// lastReportingTs must be epoch milliseconds as STRING
  static DeviceStatus getStatusFromLastReporting({
    required String lastReportingTs,
    Duration threshold = const Duration(hours: 2),
  }) {
    try {
      final int lastReportingMillis = int.parse(lastReportingTs);

      final DateTime lastReportingTime = DateTime.fromMillisecondsSinceEpoch(
        lastReportingMillis,
      ).toLocal();

      final DateTime thresholdTime = DateTime.now().subtract(threshold);

      return lastReportingTime.isBefore(thresholdTime)
          ? DeviceStatus.notReporting
          : DeviceStatus.reporting;
    } catch (e) {
      // If timestamp is invalid → treat as NOT REPORTING
      return DeviceStatus.notReporting;
    }
  }

  static String statusText(DeviceStatus status) {
    return status == DeviceStatus.reporting ? "Reporting" : "Not Reporting";
  }

  static Color statusColor(DeviceStatus status) {
    return status == DeviceStatus.reporting
        ? Colors.green
        : Colors.red;
  }

  static Color containerColor(DeviceStatus status) {
    return status == DeviceStatus.reporting
        ? Colors.green.withOpacity(0.2)
        : Colors.red.withOpacity(0.2);
  }
}
