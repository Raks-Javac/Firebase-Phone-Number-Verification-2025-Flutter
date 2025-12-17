import 'package:flutter/services.dart';

class PhoneVerificationResult {
  PhoneVerificationResult({required this.phoneNumber, this.token});

  final String phoneNumber;
  final String? token;
}

/// Service responsible for retrieving the verified phone number via platform code.
class PhoneNumberService {
  static const _channel = MethodChannel('com.example.flutter_firebase_pnv/pnv');

  Future<PhoneVerificationResult> fetchVerifiedPhoneNumber() async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'getVerifiedPhoneNumber',
    );
    if (result == null) {
      throw PlatformException(
        code: 'NO_RESULT',
        message: 'No data returned from native verification',
      );
    }
    final phone = result['phoneNumber'] as String?;
    final token = result['token'] as String?;
    if (phone == null || phone.isEmpty) {
      throw PlatformException(
        code: 'NO_PHONE',
        message: 'Phone number missing from verification result',
      );
    }
    return PhoneVerificationResult(phoneNumber: phone, token: token);
  }
}
