import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/widgets/phone_auth_unsupported_view.dart';
import 'package:bli/features/auth/widgets/country_code_picker.dart';
import 'package:bli/core/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  (String, String, String) _selectedCountry = CountryCodePicker.countries[0];

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _sendVerificationCode() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        PhoneSignInRequested(_formattedPhoneNumber()),
      );
    }
  }

  void _verifyCode(String verificationId) {
    if (_codeController.text.length == 6) {
      context.read<AuthBloc>().add(
        PhoneCodeVerified(verificationId, _codeController.text.trim()),
      );
    }
  }

  String? _validatePhone(String? value) {
    final digitsOnly = value?.replaceAll(RegExp(r'\s+'), '') ?? '';
    if (digitsOnly.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!_selectedCountry.$2.startsWith('+')) {
      return 'Select a valid country code';
    }
    if (digitsOnly.length < 6) {
      return 'Please enter at least 6 digits';
    }
    return null;
  }

  String _formattedPhoneNumber() {
    final digitsOnly = _phoneController.text.replaceAll(RegExp(r'\s+'), '');
    return '${_selectedCountry.$2}$digitsOnly';
  }

  void _navigateToMap() {
    NavigationService.navigateToMap(context, replace: true);
  }

  bool get _isDesktopPlatform {
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isDesktopPlatform
          ? PhoneAuthUnsupportedView(
              onBackPressed: () => Navigator.of(context).pop(),
            )
          : BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  previous.isAuthenticated != current.isAuthenticated ||
                  previous.error != current.error,
              listener: (context, state) {
                if (state.isAuthenticated) {
                  _navigateToMap();
                }
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state.phoneVerificationId != null) {
                        return _buildCodeInputView(state);
                      }
                      return _buildPhoneInputView(state);
                    },
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPhoneInputView(AuthState state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Sign in with Phone',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll send you a verification code via SMS.',
            style: TextStyle(fontSize: 16, color: AppColors.greyMedium),
          ),
          const SizedBox(height: 32),
          Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppColors.primary,
                selectionColor: AppColors.primary.withOpacity(0.3),
                selectionHandleColor: AppColors.primary,
              ),
            ),
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autocorrect: false,
              validator: _validatePhone,
              decoration: InputDecoration(
                labelText: 'Phone number',
                labelStyle: TextStyle(color: AppColors.greyMedium),
                floatingLabelStyle: TextStyle(color: AppColors.primary),
                hintText: '176 12345678',
                prefixIcon: CountryCodePicker(
                  selectedCountry: _selectedCountry,
                  onChanged: (value) {
                    setState(() => _selectedCountry = value);
                  },
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.greyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.error),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _sendVerificationCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : const Text(
                      'Send Verification Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInputView(AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Enter verification code',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a 6-digit code to ${_formattedPhoneNumber()}',
          style: TextStyle(fontSize: 16, color: AppColors.greyMedium),
        ),
        const SizedBox(height: 32),
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.primary,
              selectionColor: AppColors.primary.withOpacity(0.3),
              selectionHandleColor: AppColors.primary,
            ),
          ),
          child: TextFormField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '000000',
              hintStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: AppColors.greyLight,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.greyLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.length == 6) {
                _verifyCode(state.phoneVerificationId!);
              }
            },
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () => _verifyCode(state.phoneVerificationId!),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  )
                : const Text(
                    'Verify Code',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Use a different phone number',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
