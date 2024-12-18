import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

import '../widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildSummarySection(),
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const TaskCard();
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 8,
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: __onTapFAB, child: const Icon(Icons.add)),
    );
  }

  Padding buildSummarySection() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TaskSummaryCard(
              count: 9,
              tittle: 'New',
            ),
            TaskSummaryCard(
              count: 9,
              tittle: 'Completed',
            ),
            TaskSummaryCard(
              count: 9,
              tittle: 'Cancelled',
            ),
            TaskSummaryCard(
              count: 9,
              tittle: 'Progress',
            ),
          ],
        ),
      ),
    );
  }

  void __onTapFAB() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }
}
