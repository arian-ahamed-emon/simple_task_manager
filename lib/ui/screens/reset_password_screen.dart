import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_task_manager/data/models/network_response.dart';
import 'package:new_task_manager/data/service/network_caller.dart';
import 'package:new_task_manager/data/utils/urls.dart';
import 'package:new_task_manager/ui/screens/sign_in_screen.dart';
import 'package:new_task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:new_task_manager/ui/widgets/snack_bar_message.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Set Password',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Minimum password length is 8 characters with letters and numbers',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSignEmailForm(),
                const SizedBox(height: 20),
                Center(child: _buildSignInSection()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordTEController,
            keyboardType: TextInputType.visiblePassword,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Please input password';
              }
              if (value!.length < 8) {
                return "Password must be at least 8 characters";
              }
              return null;
            },
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          const SizedBox(height: 8,),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _confirmPasswordTEController,
            keyboardType: TextInputType.visiblePassword,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Confirm your password';
              }
              if (value != _passwordTEController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            decoration: const InputDecoration(hintText: 'Confirm Password'),
          ),
          const SizedBox(height: 30),
          Visibility(
            visible: !_inProgress,
            replacement: CenterdCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTapConfirmButton,
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
        text: "Have an account? ",
        children: [
          TextSpan(
            text: "Sign in",
            style: const TextStyle(color: AppColors.themecolor),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context);
              },
          ),
        ],
      ),
    );
  }

  void _onTapConfirmButton() {
    if (_formKey.currentState!.validate()) {
      _onResetPassword();
    }
  }

  void _onResetPassword() async {
    _inProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      'email': widget.email,
      'OTP': widget.otp,
      'password': _passwordTEController.text,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.resetPassword,
      body: requestBody,
    );

    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {
      showSnackBarMessage(context, 'Password reset successfully', isError: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    } else {
      showSnackBarMessage(context, response.errorMessage, isError: true);
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
