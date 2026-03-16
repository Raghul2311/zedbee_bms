import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zedbee_bms/data_folder/auth_services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await authService.login(
        event.email,
        event.password,
      );
      // CHECK THE USER DETAILS ....

      if (user.login == true) {
        emit(AuthSuccess(user));
      } else {
        emit(const AuthFailure("Invalid email or password"));

      }
    } catch (e) {
      emit(const AuthFailure("Invalid email or password"));
    }
  }
}
