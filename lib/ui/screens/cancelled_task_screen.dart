import 'package:flutter/material.dart';
import 'package:new_task_manager/ui/widgets/center_circular_progress_indicator.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskListInProgress = false;
  List<TaskModel> _cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getCancelledTaskList();
      },
      child: Scaffold(
        body: Visibility(
          visible: !_getCancelledTaskListInProgress,
          replacement: CenterdCircularProgressIndicator(),
          child: ListView.separated(
            itemCount: _cancelledTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(taskModel: _cancelledTaskList[index], onRefreshList: getCancelledTaskList,);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
          ),
        ),
      ),
    );
  }

  void getCancelledTaskList() async {
    _getCancelledTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.cancelledTaskList,
    );
    if (response.isSuccess) {
      final TaskListModel taskListModel = TaskListModel.fromJson(
        response.responseData,
      );
      _cancelledTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMessage(BuildContext, context, response.errorMessage, true);
    }
    _getCancelledTaskListInProgress = false;
    setState(() {});
  }
}
