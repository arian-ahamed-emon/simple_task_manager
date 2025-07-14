import 'package:flutter/material.dart';
import 'package:new_task_manager/ui/controller/auth_controller.dart';
import '../screens/profile_screen.dart';
import '../screens/sign_in_screen.dart';
import '../utils/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.isProfileScreenOpen = false,
  });

  final bool isProfileScreenOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileScreenOpen){
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: AppBar(
        backgroundColor: AppColors.themecolor,
        title: Row(
          children: [
             CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(AuthController.userData?.photo?? ''),
            ),
            const SizedBox(
              width: 19,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userData?.fullName ?? '',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                   Text(
                    AuthController.userData?.email ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async{
                await AuthController.clearUserData();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                    (_) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
