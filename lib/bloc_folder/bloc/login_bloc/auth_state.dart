import 'package:equatable/equatable.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel userModel;

  const AuthSuccess(this.userModel);

  @override
  List<Object?> get props => [userModel];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
