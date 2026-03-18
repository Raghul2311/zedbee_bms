import 'package:flutter/material.dart';

class FormatDynamicvalue {
  // ================= PUBLIC API =================

  static String format(
    String fieldName,
    dynamic rawValue, {
    String? equipmentName,
  }) {
    if (rawValue == null) return '--';

    final key = fieldName.toLowerCase().trim();
    final value = rawValue.toString().trim();

    switch (key) {
      case 'fls':
        return _filterStatus(value);
      case 'trp':
        return _tripStatus(value);
      case 'pam':
        return _pamStatus(value);
      case 'vfs':
      case 'vfc':
      case 'vas':
      case 'status':
      case 'command':
      case 'tripstatus':
      case 'crs':
      case 'contactor':
      case 'prun':
      case 'efls':
      case 'ast':
      case 'afb':
      case 'flow':
        return _onOffStatus(value);
      case 'v1s':
        return _ahuSource(value);
      case 'scs':
        return _scheduleStatus(value);
      case 'mod':
        return _modeStatus(value, equipmentName: equipmentName);
      case 'v2s':
        return _vavSourceStatus(value);
      case 'frs':
        return _fireStatus(value);
      case 'pir':
        return _pirStatus(value);
      case 'sts':
        return _setTempSource(value);
      case 'level':
        return _levelSwitch(value);
      case 'chs':
        return _chillerStatus(value);
      case 'hoas':
        return _hoaStatus(value);
      default:
        return value;
    }
  }

  static Color color(
    BuildContext context,
    String fieldName,
    dynamic rawValue, {
    String? equipmentName,
  }) {
    if (rawValue == null) return Colors.black;

    final key = fieldName.toLowerCase().trim();
    final value = rawValue.toString().trim();

    switch (key) {
      case 'trp':
        return value == '0' ? Colors.green : Colors.red;
      case 'vfs':
      case 'vfc':
      case 'vas':
      case 'status':
      case 'command':
      case 'tripstatus':
      case 'crs':
      case 'contactor':
      case 'prun':
      case 'efls':
      case 'ast':
      case 'afb':
      case 'flow':
        return value == '1' ? Colors.green : Colors.red;
      case 'pam':
      case 'hoas':
        return _pamColor(value, context);
      case 'v1s':
        return _ahuSourceColor(value, context);
      case 'v2s':
        return _vavSourceColor(value, context);
      case 'fls':
      case 'frs':
      case 'scs':
      case 'chs':
        return value == '0' ? Theme.of(context).primaryColor : Colors.red;
      case 'mod':
        return _modeColor(value, context);
      case 'pir':
        return _pirStatusColor(value, context);
      case 'sts':
        return _setTempSourceColor(value, context);
      case 'level':
        return _levelSwitchColor(value, context);
      default:
        return Theme.of(context).primaryColor;
    }
  }

  // ================= BASIC STATUS =================

  static String _onOffStatus(String value) => value == '1'
      ? 'ON'
      : value == '0'
      ? 'OFF'
      : 'N/A';

  static String _filterStatus(String value) => value == '0'
      ? 'Clean'
      : value == '1'
      ? 'Dirty'
      : 'N/A';

  static String _tripStatus(String value) => value == '0'
      ? 'Healthy'
      : value == '1'
      ? 'Tripped'
      : 'N/A';

  static String _chillerStatus(String value) => value == '1'
      ? 'Start'
      : value == '0'
      ? 'Stop'
      : 'N/A';

  static String _scheduleStatus(String value) => value == '1'
      ? 'ScheduleOn'
      : value == '0'
      ? 'ScheduleOff'
      : 'N/A';

  static String _fireStatus(String value) => value == '0'
      ? 'NoFire'
      : value == '1'
      ? 'Fire Event'
      : 'N/A';

  // ================= PAM =================

  static String _pamStatus(String value) {
    switch (value) {
      case '0':
        return 'OFF';
      case '1':
        return 'Auto';
      case '2':
        return 'Manual';
      default:
        return 'N/A';
    }
  }

  static Color _pamColor(String value, BuildContext context) {
    switch (value) {
      case '0':
        return Colors.red;
      case '1':
        return Colors.green;
      case '2':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  // ================= MODE =================

  static String _modeStatus(String value, {String? equipmentName}) {
    final eq = equipmentName?.toLowerCase() ?? '';

    if (eq.contains('vav')) {
      switch (value) {
        case '0':
          return 'Auto';
        case '1':
          return 'Manual / Calibration';
        case '2':
          return 'Cooling';
        case '3':
          return 'Moderate Cooling';
        case '4':
          return 'Rapid Cooling';
        default:
          return 'N/A';
      }
    }

    // AHU / default
    switch (value) {
      case '0':
        return 'Auto';
      case '1':
        return 'Manual';
      case '2':
        return 'Auto_Switch';
      case '3':
        return 'BMS';
      default:
        return 'N/A';
    }
  }

  // ONE COMMON MODE COLOR
  static Color _modeColor(String value, BuildContext context) {
    switch (value) {
      case '0':
        return Theme.of(context).primaryColor;
      case '1':
        return Colors.red;
      case '2':
        return Colors.blue;
      case '3':
        return Colors.lightBlue;
      case '4':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  /// ================= AHU SOURCE =================

  static String _ahuSource(String value) {
    const map = {
      '0': 'Status ON',
      '1': 'PS',
      '2': 'SWS',
      '3': 'PS + SWS',
      '4': 'BS',
      '5': 'PS + BS',
      '6': 'SWS + BS',
      '7': 'PS + SWS + BS',
      '8': 'SCHS',
      '9': 'SCHS + PS',
      '10': 'SCHS + SWS',
      '11': 'SCHS + SWS + PS',
      '12': 'SCHS + BS',
      '13': 'SCHS + BS + PS',
      '14': 'SCHS + BS + SWS',
      '15': 'SCHS + BS + SWS + PS',
      '16': 'Trip',
      '17': 'Auto / Manual',
    };
    return map[value] ?? 'N/A';
  }

  static Color _ahuSourceColor(String value, BuildContext context) {
    final v = int.tryParse(value);
    if (v == null) return Colors.black;
    if (v == 16) return Colors.red;
    if (v == 17) return Colors.orange;
    if (v == 0) return Theme.of(context).primaryColor;
    return Colors.black54;
  }

  /// ================= VAV SOURCE =================

  static String _vavSourceStatus(String value) {
    const map = {
      '0': 'ON By Power ON',
      '1': 'OFF By Remote',
      '2': 'ON By Remote',
      '3': 'OFF By Button',
      '4': 'ON By Button',
      '5': 'OFF By BMS',
      '6': 'ON By BMS',
      '7': 'OFF By PIR',
      '8': 'ON By PIR',
      '9': 'Motor Issue',
      '10': 'VFD Communication Issue',
      '11': 'Thermostat Communication Issue',
      '12': 'ADC Motor Feedback Issue',
      '13': 'ADC M1 Voltage Issue',
      '14': 'ADC M2 Voltage Issue',
      '15': 'Ambient Temp Issue',
      '16': 'Set Temp Issue',
      '17': 'Flash R/W Issue',
      '18': 'Thermostat CRC Issue',
      '19': 'VFD RX Data Issue',
    };
    return map[value] ?? 'N/A';
  }

  static Color _vavSourceColor(String value, BuildContext context) {
    final v = int.tryParse(value);
    if (v == null) return Colors.black;
    if ([0, 2, 4, 6, 8].contains(v)) return Theme.of(context).primaryColor;
    if ([1, 3, 5, 7].contains(v)) return Colors.red;
    if (v >= 9) return Colors.orange;
    return Colors.black;
  }

  /// ================= PIR =================

  static String _pirStatus(String value) {
    switch (value) {
      case '0':
        return 'PIR Enable - Not Occupied';
      case '1':
        return 'PIR Enable - Occupied';
      case '2':
        return 'PIR Disable - Occupied';
      case '3':
        return 'PIR Disable - Not Occupied';
      default:
        return 'N/A';
    }
  }

  static Color _pirStatusColor(String value, BuildContext context) {
    switch (value) {
      case '1':
        return Theme.of(context).primaryColor;
      case '2':
        return Colors.red;
      case '0':
        return Colors.black54;
      default:
        return Colors.black;
    }
  }

  /// ================= SET TEMP SOURCE =================

  static String _setTempSource(String value) {
    switch (value) {
      case '0':
        return 'No Input';
      case '1':
        return 'Set By Remote';
      case '2':
        return 'Set By Button';
      case '3':
        return 'Set By BMS';
      default:
        return 'N/A';
    }
  }

  static Color _setTempSourceColor(String value, BuildContext context) {
    switch (value) {
      case '1':
        return Colors.blue;
      case '2':
        return Theme.of(context).primaryColor;
      case '3':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  // ================= UTIL =================

  static String _levelSwitch(String value) {
    switch (value) {
      case '0':
        return 'Low';
      case '1':
        return 'Normal';
      case '2':
        return 'High';
      default:
        return 'N/A';
    }
  }

  static Color _levelSwitchColor(String value, BuildContext context) {
    switch (value) {
      case '0':
        return Colors.orange;
      case '1':
        return Theme.of(context).primaryColor;
      case '2':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  static String _hoaStatus(String value) {
    switch (value) {
      case '0':
        return 'OFF';
      case '1':
        return 'Hand';
      case '2':
        return 'Manual';
      default:
        return 'N/A';
    }
  }
}
