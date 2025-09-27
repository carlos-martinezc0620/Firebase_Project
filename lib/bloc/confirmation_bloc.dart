import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'confirmation_event.dart';
import 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  ConfirmationBloc() : super(Confirmationinital()) {
    on<SendConfirmationEvent>((event, emit) async {
      emit(ConfirmationSent());

      await FirebaseFirestore.instance.collection('confirmations').add({
        'userId': event.userId,
        'appointmentId': event.appointmentId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      emit(ConfirmationSent());
    });
  }
}
