import 'package:equatable/equatable.dart';

abstract class ConfirmationEvent extends Equatable {
  const ConfirmationEvent();
}

class SendConfirmationEvent extends ConfirmationEvent {
  final String userId;
  final String appointmentId;

  const SendConfirmationEvent({
    required this.userId,
    required this.appointmentId,
  });

  @override
  List<Object> get props => [userId, appointmentId];
}
