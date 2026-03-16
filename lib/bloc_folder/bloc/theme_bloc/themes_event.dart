
import 'package:zedbee_bms/utils/app_themes.dart';

abstract class ThemeEvent {}
class ThemeChanged extends ThemeEvent {
  final AppTheme theme;
  ThemeChanged(this.theme);
}