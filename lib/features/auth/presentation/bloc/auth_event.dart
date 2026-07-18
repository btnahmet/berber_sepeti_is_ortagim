part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginRequestedEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequestedEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String shopName;

  const RegisterRequestedEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.shopName,
  });

  @override
  List<Object?> get props => [email, password, name, phone, shopName];
}

class LogoutRequestedEvent extends AuthEvent {}
