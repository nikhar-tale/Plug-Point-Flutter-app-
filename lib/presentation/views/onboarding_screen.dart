// lib/presentation/views/onboarding_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'charger_discovery_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _verificationId;
  String? _errorMessage;
  bool _isVerifying = false;
  bool _otpSent = false;

  // Initiate phone verification.
  void _verifyPhone() async {
    if (_phoneController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a valid phone number";
        return;
      });
    } else {
      String codenumber = '+91' + _phoneController.text;
      _phoneController.text = codenumber;
    }
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically sign in the user.
          await FirebaseAuth.instance.signInWithCredential(credential);
          _navigateToDiscovery();
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _errorMessage = e.message ?? "Phone verification failed";
            _isVerifying = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _otpSent = true;
            _isVerifying = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // You can handle auto-retrieval timeout if needed.
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
        _isVerifying = false;
      });
    }
  }

  // Submit OTP entered by user.
  void _submitOTP() async {
    if (_verificationId == null) return;
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: _otpController.text);
      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToDiscovery();
    } catch (e) {
      setState(() {
        _errorMessage = "Invalid OTP or error occurred";
        _isVerifying = false;
      });
    }
  }

  // Navigate to the Charger Discovery screen.
  void _navigateToDiscovery() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ChargerDiscoveryScreen(),
      ),
    );
  }

  // Skip phone authentication and proceed.
  void _skipAuth() {
    _navigateToDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Welcome to EV Charging",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!_otpSent)
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        prefixText: "+91",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  if (_otpSent)
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Enter OTP",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  if (_errorMessage != null) const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _isVerifying
                        ? null
                        : _otpSent
                            ? _submitOTP
                            : _verifyPhone,
                    child: _isVerifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(_otpSent ? "Submit OTP" : "Verify Phone"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _skipAuth,
                    child: const Text("Skip Authentication"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
