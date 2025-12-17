import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../application/phone_verification_bloc.dart';
import '../widgets/phone_number_bottom_sheet.dart';
import '../widgets/verification_success_dialog.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _successDialogVisible = false;
  bool _bottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleProceed() {
    final bloc = context.read<PhoneVerificationBloc>();
    bloc.add(const PhoneVerificationReset());
    bloc.add(const PhoneVerificationStarted());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<PhoneVerificationBloc, PhoneVerificationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == PhoneVerificationStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!, style: GoogleFonts.poppins()),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.status == PhoneVerificationStatus.ready &&
            state.phoneNumber != null &&
            !_bottomSheetOpen) {
          _bottomSheetOpen = true;
          _animationController.forward();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => PhoneNumberBottomSheet(
              phoneNumber: state.phoneNumber!,
              onConfirm: () {
                _animationController.reverse();
                Navigator.pop(context);
                context.read<PhoneVerificationBloc>().add(
                  const PhoneVerificationConfirmed(),
                );
              },
            ),
          ).whenComplete(() {
            _bottomSheetOpen = false;
            _animationController.reverse();
          });
        }

        if (state.status == PhoneVerificationStatus.verified &&
            !_successDialogVisible) {
          _successDialogVisible = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.7),
            builder: (context) => const VerificationSuccessDialog(),
          ).whenComplete(() {
            _successDialogVisible = false;
          });
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple.shade400,
                Colors.deepPurple.shade700,
                Colors.purple.shade900,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: size.width * 0.6,
                    height: size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.phone_android,
                      size: size.width * 0.3,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Phone Verification',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'We\'ll use the phone number from your SIM card for verification. Click proceed to continue.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 - (_animationController.value * 0.05),
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child:
                          BlocBuilder<
                            PhoneVerificationBloc,
                            PhoneVerificationState
                          >(
                            builder: (context, state) {
                              final isLoading = state.isLoading;
                              return ElevatedButton(
                                onPressed: isLoading ? null : _handleProceed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.deepPurple,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.deepPurple,
                                        ),
                                      )
                                    : Text(
                                        'Proceed',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              );
                            },
                          ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
