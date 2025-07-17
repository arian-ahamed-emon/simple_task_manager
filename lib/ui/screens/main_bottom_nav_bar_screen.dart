import 'package:flutter/material.dart';
import 'package:new_task_manager/ui/screens/progress_task_screen.dart';
import '../widgets/tm_app_bar.dart';
import 'cancelled_task_screen.dart';
import 'compeleted_task_screen.dart';
import 'new_task_screen.dart';

class MainBottomNavBarScreen extends StatefulWidget {
  const MainBottomNavBarScreen({super.key});

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    ProgressTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.note_add_rounded), label: 'New'),
          NavigationDestination(
            icon: Icon(Icons.done_all_rounded),
            label: 'Completed',
          ),
          NavigationDestination(icon: Icon(Icons.cancel_presentation_rounded), label: 'Cancelled'),
          NavigationDestination(
            icon: Icon(Icons.hourglass_bottom_rounded),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}
