import 'package:flutter/material.dart';
import 'package:new_task_manager/ui/widgets/center_circular_progress_indicator.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskListInProgress = false;
  List<TaskModel> _newTaskList = [];

  @override
  void initState() {
    super.initState();
    getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getCompletedTaskList();
      },
      child: Scaffold(
        body: Visibility(
          visible: !_getCompletedTaskListInProgress,
          replacement: CenterdCircularProgressIndicator(),
          child: ListView.separated(
            itemCount: _newTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(taskModel: _newTaskList[index], onRefreshList:getCompletedTaskList,);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
          ),
        ),
      ),
    );
  }

  void getCompletedTaskList() async {
    _getCompletedTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.completedTaskList,
    );
    if (response.isSuccess) {
      final TaskListModel taskListModel = TaskListModel.fromJson(
        response.responseData,
      );
      _newTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, isError: true);
    }
    _getCompletedTaskListInProgress = false;
    setState(() {});
  }
}
