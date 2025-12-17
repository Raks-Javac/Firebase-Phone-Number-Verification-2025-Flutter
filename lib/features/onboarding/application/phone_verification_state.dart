part of 'phone_verification_bloc.dart';

enum PhoneVerificationStatus { initial, loading, ready, error, verified }

class PhoneVerificationState extends Equatable {
  const PhoneVerificationState({
    this.status = PhoneVerificationStatus.initial,
    this.phoneNumber,
    this.errorMessage,
    this.token,
  });

  final PhoneVerificationStatus status;
  final String? phoneNumber;
  final String? errorMessage;
  final String? token;

  bool get isLoading => status == PhoneVerificationStatus.loading;

  PhoneVerificationState copyWith({
    PhoneVerificationStatus? status,
    String? phoneNumber,
    String? errorMessage,
    String? token,
  }) {
    return PhoneVerificationState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: errorMessage,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [status, phoneNumber, errorMessage, token];
}
