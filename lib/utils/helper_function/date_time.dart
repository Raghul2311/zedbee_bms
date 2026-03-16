  // date and time formate of IST
  import 'package:intl/intl.dart';

String formatToIST(dynamic ts) {
    if (ts == null) return "";

    try {
      int timestamp = ts is String ? int.parse(ts) : ts as int;

      DateTime utc = DateTime.fromMillisecondsSinceEpoch(
        timestamp,
        isUtc: true,
      );
      DateTime ist = utc.add(const Duration(hours: 5, minutes: 30));

      return DateFormat("dd/MM/yyyy hh:mm a").format(ist);
    } catch (_) {
      return "";
    }
  }