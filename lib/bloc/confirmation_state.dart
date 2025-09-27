import 'package:equatable/equatable.dart';

abstract class ConfirmationState extends Equatable {
  const ConfirmationState();

  @override
  List<Object> get props => [];
}

class Confirmationinital extends ConfirmationState {}

class ConfirmationSending extends ConfirmationState {}

class ConfirmationSent extends ConfirmationState {}
