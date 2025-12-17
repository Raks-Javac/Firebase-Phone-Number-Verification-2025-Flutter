part of 'phone_verification_bloc.dart';

abstract class PhoneVerificationEvent extends Equatable {
  const PhoneVerificationEvent();

  @override
  List<Object?> get props => [];
}

class PhoneVerificationStarted extends PhoneVerificationEvent {
  const PhoneVerificationStarted();
}

class PhoneVerificationConfirmed extends PhoneVerificationEvent {
  const PhoneVerificationConfirmed();
}

class PhoneVerificationReset extends PhoneVerificationEvent {
  const PhoneVerificationReset();
}
