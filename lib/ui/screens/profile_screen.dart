import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_task_manager/ui/controller/auth_controller.dart';
import 'package:new_task_manager/ui/widgets/center_circular_progress_indicator.dart';
import '../../data/models/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/tm_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _emailTEController = TextEditingController();
  TextEditingController _firstNameTEController = TextEditingController();
  TextEditingController _lastNameTEController = TextEditingController();
  TextEditingController _mobileTEController = TextEditingController();
  TextEditingController _passwordTEController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _setData();
  }
  void _setData() {
    _emailTEController.text = AuthController.userData?.email?? '';
    _firstNameTEController.text = AuthController.userData?.firstName?? '';
    _lastNameTEController.text = AuthController.userData?.lastName?? '';
    _mobileTEController.text = AuthController.userData?.mobile?? '';
  }
 bool _UpdateProfileInProgress = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TMAppBar(isProfileScreenOpen: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 45),
                  Text(
                    'Update Profile',
                    style: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 32),
                  buildPhotoPicker(),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: false,
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      return 'Enter a valid name';
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      return 'Enter a valid name';
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration:  InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if(value?.trim().isEmpty ?? true) {
                        return 'Enter a valid password';
                      }
                      return null;
                    },

                  ),
                  const SizedBox(height: 18),
                  Visibility(
                    visible: !_UpdateProfileInProgress,
                    replacement: CenterdCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapUpdateButton,
                      child: const Icon(Icons.arrow_circle_right),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Container buildPhotoPicker() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 100,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(_getSelectedPhotoTitle()),
        ],
      ),
    );
  }
  String _getSelectedPhotoTitle() {
    if (_selectedImage != null) {
      return _selectedImage!.name;
    }
    return 'Select Photo';
  }

  Future<void> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
    }
  }



  void _onTapUpdateButton() {
    if(_formKey.currentState!.validate()){
      return ;
    }
    _profileUpdate();
  }
  void _profileUpdate() async {
    _UpdateProfileInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      'firstName': _firstNameTEController.text.trim(),
      'lastName': _lastNameTEController.text.trim(),
      'mobile': _mobileTEController.text.trim(),
      'photo': '',
    };
    if(_passwordTEController.text.isNotEmpty){
      requestBody['password'] = _passwordTEController.text;
    }
    if(_selectedImage != null){
      List<int> imageBytes =await _selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      requestBody['photo'] = convertedImage;
    }
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.profileUpdate,
      body: requestBody,
    );
    if (response.isSuccess) {
      showSnackBarMessage( context, 'Profile has been updated',isError: false);
    } else {
      showSnackBarMessage( context, response.errorMessage,isError: true);
    }
    _UpdateProfileInProgress = false;
    setState(() {});
    _formKey.currentState?.reset();
    _passwordTEController.clear();
  }
  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }

}
