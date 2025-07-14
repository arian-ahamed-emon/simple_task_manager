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

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _passwordTEController = TextEditingController();
  TextEditingController _confirmPasswordTEController = TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;

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
                  'Minimum length password 8 character with letter and number combination',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSignEmailForm(),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [_buildSignInSection()],
                  ),
                ),
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
              if (value!.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _confirmPasswordTEController,
            keyboardType: TextInputType.visiblePassword,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Confirm your password';
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
      if (_passwordTEController.text != _confirmPasswordTEController.text) {
        showSnackBarMessage(BuildContext, context, 'Passwords do not match', true);
        return;
      }
      _onResetPassword();
    }
  }

  void _onResetPassword() async {
    _inProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      'email': widget.email,
      'password': _passwordTEController.text,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.resetPassword,
      body: requestBody,
    );

    if (response.isSuccess) {
      showSnackBarMessage(BuildContext, context, 'Password reset successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } else {
      showSnackBarMessage(BuildContext, context, response.errorMessage);
    }
    _inProgress = false;
    setState(() {});
  }
  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();

  }
}
