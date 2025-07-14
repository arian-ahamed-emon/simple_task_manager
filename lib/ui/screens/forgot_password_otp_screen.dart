import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_task_manager/data/models/network_response.dart';
import 'package:new_task_manager/data/service/network_caller.dart';
import 'package:new_task_manager/data/utils/urls.dart';
import 'package:new_task_manager/ui/screens/reset_password_screen.dart';
import 'package:new_task_manager/ui/screens/sign_in_screen.dart';
import 'package:new_task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:new_task_manager/ui/widgets/snack_bar_message.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpScreen({super.key, required this.email});

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  TextEditingController _otpController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _otpController.clear();
  }

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
                  'PIN Verification',
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
          child: PinCodeTextField(
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter otp first';
              }
              return null;
            },
            controller: _otpController,
            length: 6,
            obscureText: false,
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 40,
              fieldWidth: 30,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              return true;
            },
            onChanged: (value) {
              print('Change:$value');
            },
            onCompleted: (value) {
              print('Complete: $value');
            },
            appContext: context,
          ),
        ),
        const SizedBox(height: 30),
        Visibility(
          visible: !_inProgress,
          replacement: CenterdCircularProgressIndicator(),
          child: ElevatedButton(
            onPressed: _onTapNextButton,
            child: const Text('Verify'),
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (_) => false,
                );
              },
          ),
        ],
      ),
    );
  }

  void _onTapNextButton() {
    if(!_formKey.currentState!.validate()){
      return ;
    }
    return _verifyOtp();
  }

  void _verifyOtp() async {
    _inProgress = true;
    setState(() {});
    final String otp = _otpController.text.trim();
    final String email = widget.email;
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: "${Urls.verifyOtp}$email/$otp",
    );
    _inProgress = false;
    setState(() {});
    if (response.isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  ResetPasswordScreen(email: widget.email)),
      );
    } else {
      showSnackBarMessage(BuildContext, context, response.errorMessage);
    }
  }
}
