import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/phone_number_service.dart';
import 'features/onboarding/application/phone_verification_bloc.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PhoneVerificationBloc(PhoneNumberService()),
        ),
      ],
      child: MaterialApp(
        title: 'Phone Verification',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
