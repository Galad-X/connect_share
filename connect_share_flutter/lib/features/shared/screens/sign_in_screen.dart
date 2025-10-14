// SignInScreen.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart'
    show UserInfo, ServerpodClientException;
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import '../../../src/serverpod_client.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets.dart';

enum AuthFlowStep {
  signIn, // Show sign-in form
  register, // Show registration form
  verifyEmail, // Show email verification code input
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _roleController = TextEditingController(text: 'consumer');
  final _verificationCodeController = TextEditingController();

  String? _errorMessage;
  AuthFlowStep _currentStep = AuthFlowStep.signIn;
  bool _isLoading = false;

  // Store data between steps
  String _emailForVerification = '';
  String _passwordForRegistration = ''; // To use for final sign-in
  String _usernameForProfile = '';
  String _roleForProfile = '';

  late EmailAuthController _emailAuthController;

  @override
  void initState() {
    super.initState();
    _emailAuthController = EmailAuthController(client.modules.auth);
  }

  void _setStep(AuthFlowStep step) {
    setState(() {
      _currentStep = step;
      _errorMessage = null;
      _isLoading = false;
      // Clear fields that are not relevant for the new step
      if (step == AuthFlowStep.signIn || step == AuthFlowStep.register) {
        _verificationCodeController.clear();
      }
      if (step == AuthFlowStep.signIn) {
        _usernameController.clear();
        // _roleController.text = 'consumer'; // Reset role if needed
      }
    });
  }

  Future<void> _handleSignIn() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _errorMessage = 'A valid email is required.';
        _isLoading = false;
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Password is required.';
        _isLoading = false;
      });
      return;
    }

    try {
      final UserInfo? userInfo =
          await _emailAuthController.signIn(email, password);
      debugPrint('Sign-in attempt result: $userInfo');
      if (userInfo != null) {
       
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password, or email not verified.';
          _isLoading = false;
        });
      }
    } on ServerpodClientException catch (e) {
      setState(() {
        _errorMessage = "Server error: ${e.message}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An unexpected error: ${e.toString()}";
        _isLoading = false;
      });
    }
    // No explicit setState({_isLoading = false}) here if successful,
    // as navigation should occur. If error, it's set above.
    if (mounted && _errorMessage != null) {
      // Ensure _isLoading is reset on error
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRegistrationRequest() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _usernameForProfile = _usernameController.text.trim();
    _emailForVerification = _emailController.text.trim();
    _passwordForRegistration = _passwordController.text.trim();
    _roleForProfile = _roleController.text.trim();

    // Basic client-side validation
    if (_usernameForProfile.isEmpty) {
      setState(() {
        _errorMessage = 'Username is required.';
        _isLoading = false;
      });
      return;
    }
    if (_emailForVerification.isEmpty ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailForVerification)) {
      setState(() {
        _errorMessage = 'A valid email is required.';
        _isLoading = false;
      });
      return;
    }
    if (_passwordForRegistration.length < 8) {
      // Example minimum
      setState(() {
        _errorMessage = 'Password must be at least 8 characters.';
        _isLoading = false;
      });
      return;
    }

    debugPrint(
        'Attempting createAccountRequest for email: $_emailForVerification, user: $_usernameForProfile');
    try {
      // This uses the standard Serverpod auth flow, which will trigger your sendValidationEmail callback
      bool success = await _emailAuthController.createAccountRequest(
        _usernameForProfile, // Serverpod auth uses this for UserInfo.userName
        _emailForVerification,
        _passwordForRegistration,
      );
      debugPrint('createAccountRequest success: $success');

      if (success) {
        _setStep(AuthFlowStep.verifyEmail);
      } else {
        // This often means the email is already associated with an existing UserInfo
        setState(() {
          _errorMessage =
              'Failed to initiate registration. The email might already be in use.';
          _isLoading = false;
        });
      }
    } on ServerpodClientException catch (e) {
      setState(() {
        _errorMessage = "Server error: ${e.message}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An unexpected error: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  Future<void> _handleVerifyEmailAndComplete() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final verificationCode = _verificationCodeController.text.trim();
    if (verificationCode.isEmpty) {
      setState(() {
        _errorMessage = 'Verification code is required.';
        _isLoading = false;
      });
      return;
    }

    try {
      debugPrint(
          'Attempting validateAccount for email: $_emailForVerification with code: $verificationCode');
      // Step 1: Validate account - Serverpod auth creates UserInfo here
      UserInfo? basicUserInfo = await _emailAuthController.validateAccount(
        _emailForVerification,
        verificationCode,
      );
      debugPrint('validateAccount result: $basicUserInfo');

      if (basicUserInfo != null && basicUserInfo.id != null) {
        // Step 2: Call your custom endpoint to set role & create UserProfile
        debugPrint(
            'Attempting completeUserSetupAndProfile for userId: ${basicUserInfo.id}, role: $_roleForProfile');
        UserInfo? fullySetupUserInfo =
            await client.auth.completeUserSetupAndProfile(
          basicUserInfo.id!,
          _usernameForProfile, // Pass the original username for UserProfile.displayName
          _roleForProfile,
        );
        debugPrint('completeUserSetupAndProfile result: $fullySetupUserInfo');

        if (fullySetupUserInfo != null) {
          // Step 3: Sign in the user to establish session
          debugPrint(
              'Attempting final signIn for email: $_emailForVerification');
          UserInfo? signedInUserInfo = await _emailAuthController.signIn(
            _emailForVerification,
            _passwordForRegistration, // Use the originally stored password
          );
          debugPrint('Final signIn result: $signedInUserInfo');

          if (signedInUserInfo != null) {
            // Successfully registered, verified, and signed in.
            // SessionManager listener will navigate.
          } else {
            setState(() {
              _errorMessage =
                  'Account verified and setup, but auto sign-in failed. Please try signing in manually.';
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _errorMessage =
                'Failed to complete user setup with role after verification. Please contact support.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid verification code or email.';
          _isLoading = false;
        });
      }
    } on ServerpodClientException catch (e) {
      setState(() {
        _errorMessage = "Server error: ${e.message}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An error during verification: ${e.toString()}";
        _isLoading = false;
      });
    }
    if (mounted && _errorMessage != null) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _usernameController.dispose();
    _roleController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Key? key, // Add key for AnimatedSwitcher
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextField(
        controller: controller,
        labelText: labelText,
        prefixIcon: icon,
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }

  // --- UI Building Helper Methods ---
  Widget _buildRegistrationFormFields() {
    return Column(
      key: const ValueKey<String>('register_form'), // Key for AnimatedSwitcher
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTextField(
          controller: _usernameController,
          labelText: 'Username',
          icon: Icons.person_outline,
        ),
        _buildTextField(
          controller: _emailController,
          labelText: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildTextField(
          controller: _passwordController,
          labelText: 'Password',
          icon: Icons.lock_outline,
          obscureText: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.glassBackgroundColor.withAlpha(128),
              border: Border.all(color: AppColors.glassBorderColor, width: 1.5),
            ),
            child: DropdownButtonFormField<String>(
              value: _roleController.text,
              decoration: InputDecoration(
                labelText: 'Role',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                prefixIcon:
                    Icon(Icons.work_outline, color: AppColors.textSecondary),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              ),
              borderRadius: BorderRadius.circular(12),
              dropdownColor: AppColors.matchaVeryLight,
              items: const [
                DropdownMenuItem(value: 'consumer', child: Text('Consumer')),
                DropdownMenuItem(value: 'provider', child: Text('Provider')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (value) {
                setState(() {
                  _roleController.text = value ?? 'consumer';
                });
              },
              style: TextStyle(color: AppColors.textPrimary),
              iconEnabledColor: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInFields() {
    return Column(
      key: const ValueKey('signin_fields'),
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTextField(
            controller: _emailController,
            labelText: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress),
        _buildTextField(
            controller: _passwordController,
            labelText: 'Password',
            icon: Icons.lock_outline,
            obscureText: true),
      ],
    );
  }

  Widget _buildVerifyEmailFields() {
    return Column(
      key: const ValueKey('verify_fields'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'A verification code was sent to $_emailForVerification. Please enter it below.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        _buildTextField(
            controller: _verificationCodeController,
            labelText: 'Verification Code',
            icon: Icons.pin_outlined,
            keyboardType: TextInputType.number),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    Widget currentFormFields;
    String pageTitle;
    String submitButtonText;
    VoidCallback onSubmitAction;
    String? toggleButtonText;
    VoidCallback? onToggleAction;

    switch (_currentStep) {
      case AuthFlowStep.signIn:
        pageTitle = 'Welcome back!';
        currentFormFields = _buildSignInFields();
        submitButtonText = 'Sign In';
        onSubmitAction = _handleSignIn;
        toggleButtonText = "Don't have an account? Sign Up";
        onToggleAction = () => _setStep(AuthFlowStep.register);
        break;
      case AuthFlowStep.register:
        pageTitle = 'Create your account';
        currentFormFields = _buildRegistrationFormFields();
        submitButtonText = 'Register'; // Changed from "Register & Verify Email"
        onSubmitAction = _handleRegistrationRequest;
        toggleButtonText = 'Already have an account? Sign In';
        onToggleAction = () => _setStep(AuthFlowStep.signIn);
        break;
      case AuthFlowStep.verifyEmail:
        pageTitle = 'Verify Your Email';
        currentFormFields = _buildVerifyEmailFields();
        submitButtonText = 'Verify & Complete Registration';
        onSubmitAction = _handleVerifyEmailAndComplete;
        // Optional: Allow user to go back if they made a mistake or didn't get the code
        toggleButtonText = 'Back to Sign In'; // Or 'Resend Code' (more complex)
        onToggleAction = () => _setStep(AuthFlowStep.signIn);
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background, // Fallback background
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.matcha.withAlpha(152), // Darker Matcha variant
                  AppColors.background, // Your existing background color
                  AppColors.matchaVeryLight.withAlpha(104), // Lighter variant
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Decorative Blurred Shapes (Optional, for enhanced glassmorphism)
          Positioned(
            top: screenHeight * 0.1,
            left: screenWidth * -0.2,
            child: _buildBlurredCircle(
                AppColors.matchaVeryLight.withAlpha(52), 200),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            right: screenWidth * -0.15,
            child: _buildBlurredCircle(AppColors.matcha.withAlpha(77), 250),
          ),
          Positioned(
            top: screenHeight * 0.4,
            right: screenWidth * 0.1,
            child: _buildBlurredCircle(AppColors.white.withAlpha(26), 150),
          ),

          // Main Content Area
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: AppColors.glassBackgroundColor,
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                              color: AppColors.glassBorderColor, width: 1.5),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                            children: [
                            Text(
                              'ConnectShare',
                              style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pageTitle,
                              style: TextStyle(
                                color: AppColors.textTertiary, fontSize: 16),
                            ),
                            const SizedBox(height: 24),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                                ),
                              );
                              },
                              child:
                                currentFormFields, // This will switch based on _authStep
                            ),
                            if (_errorMessage != null)
                              Padding(
                              padding: const EdgeInsets.only(
                                top: 16.0, bottom: 8.0),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                color: AppColors.error.withAlpha(39),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.error.withAlpha(128)),
                                ),
                                child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                                ),
                              ),
                              )
                            else
                              const SizedBox(height: 24),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.matcha,
                                foregroundColor: Colors.white,
                                padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              ),
                              onPressed: _isLoading ? null : onSubmitAction,
                              child: _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white),
                                  )
                                : Text(submitButtonText),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: _isLoading ? null : onToggleAction,
                              child: Text(
                              toggleButtonText,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for decorative blurred circles
  Widget _buildBlurredCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      //
    );
  }
}