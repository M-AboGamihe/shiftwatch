import 'package:equatable/equatable.dart';

class ProfileDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileDetailsEvent extends ProfileDetailsEvent {
  final String username;
  final String employeeName;

  LoadProfileDetailsEvent({
    required this.username,
    required this.employeeName,
  });

  @override
  List<Object?> get props => [username, employeeName];
}
