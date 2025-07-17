import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_task_manager/data/models/network_response.dart';
import 'package:new_task_manager/data/service/network_caller.dart';
import 'package:new_task_manager/data/utils/urls.dart';
import 'package:new_task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:new_task_manager/ui/widgets/snack_bar_message.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';
import 'forgot_password_otp_screen.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  TextEditingController _emailTEController = TextEditingController();
  bool _inProgress = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  'Your Email Address',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'A 6 digit verification pin will send to your email address',
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
    return Column(
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 30),
        Visibility(
          visible: !_inProgress,
          replacement: CenterdCircularProgressIndicator(),
          child: ElevatedButton(
            onPressed: _onTapNextButton,
            child: const Icon(Icons.arrow_circle_right),
          ),
        ),
      ],
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

  void _onTapNextButton() {
    if(!_formKey.currentState!.validate()){
      return;
    }
    return _verifyEmail();
  }

  void _verifyEmail() async {
    _inProgress = true;
    setState(() {});

      final String email =  _emailTEController.text.trim();

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: "${Urls.verifyEmail}$email"
    );
    _inProgress = false;
    setState(() {});
    if (response.isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordOtpScreen(email:_emailTEController.text.trim()),
        ),
      );
    } else {
      showSnackBarMessage(context, response.errorMessage,isError: true);
    }
  }
}
