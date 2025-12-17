import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/phone_number_service.dart';

part 'phone_verification_event.dart';
part 'phone_verification_state.dart';

class PhoneVerificationBloc
    extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  PhoneVerificationBloc(this._phoneNumberService)
    : super(const PhoneVerificationState()) {
    on<PhoneVerificationStarted>(_onStarted);
    on<PhoneVerificationConfirmed>(_onConfirmed);
    on<PhoneVerificationReset>(_onReset);
  }

  final PhoneNumberService _phoneNumberService;

  Future<void> _onStarted(
    PhoneVerificationStarted event,
    Emitter<PhoneVerificationState> emit,
  ) async {
    emit(state.copyWith(status: PhoneVerificationStatus.loading));
    try {
      final verified = await _phoneNumberService.fetchVerifiedPhoneNumber();
      emit(
        state.copyWith(
          status: PhoneVerificationStatus.ready,
          phoneNumber: verified.phoneNumber,
          token: verified.token,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PhoneVerificationStatus.error,
          errorMessage: 'Error retrieving phone number: $e',
        ),
      );
    }
  }

  void _onConfirmed(
    PhoneVerificationConfirmed event,
    Emitter<PhoneVerificationState> emit,
  ) {
    if (state.phoneNumber == null) return;
    emit(state.copyWith(status: PhoneVerificationStatus.verified));
  }

  void _onReset(
    PhoneVerificationReset event,
    Emitter<PhoneVerificationState> emit,
  ) {
    emit(const PhoneVerificationState());
  }
}
