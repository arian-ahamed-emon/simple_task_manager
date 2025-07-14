import 'package:flutter/material.dart';
import 'package:new_task_manager/data/models/network_response.dart';
import 'package:new_task_manager/data/models/task_model.dart';
import 'package:new_task_manager/data/service/network_caller.dart';
import 'package:new_task_manager/data/utils/urls.dart';
import 'package:new_task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:new_task_manager/ui/widgets/snack_bar_message.dart';
import '../utils/app_colors.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.onRefreshList,
  });

  final TaskModel taskModel;
  final VoidCallback onRefreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.taskModel.status!;
  }

  bool _changeStatusInProgress = false;
  bool _deleteTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(widget.taskModel.description ?? ''),
            Text('Date: ${widget.taskModel.createdDate}'),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildTaskStatus(),
                Wrap(
                  children: [
                    Visibility(
                      visible: !_changeStatusInProgress,
                      replacement: CenterdCircularProgressIndicator(),
                      child: IconButton(
                        onPressed: _onTapEditButton,
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    Visibility(
                      visible: !_deleteTaskInProgress,
                      replacement: CenterdCircularProgressIndicator(),
                      child: IconButton(
                        onPressed: _onTapDeleteButton,
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTapEditButton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['New', 'Completed', 'Cancelled', 'Progress'].map((e) {
              return ListTile(
                onTap: () {
                  _changeStatus(e);
                  Navigator.pop(context);
                },
                title: Text(e),
                selected: _selectedStatus == e,
                trailing: _selectedStatus == e ? Icon(Icons.check) : null,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onTapDeleteButton() async {
    _deleteTaskInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.deleteTask(widget.taskModel.sId!));
    if (response.isSuccess) {
      widget.onRefreshList();
    } else {
      _deleteTaskInProgress = false;
      setState(() {});
      showSnackBarMessage(BuildContext,context, response.errorMessage);
    }
  }


  Chip buildTaskStatus() {
    String labelText = '';
    Color chipColor = Colors.grey;

    switch (_selectedStatus) {
      case 'New':
        labelText = 'New';
        chipColor = Colors.blue;
        break;
      case 'Completed':
        labelText = 'Completed';
        chipColor = Colors.green;
        break;
      case 'Cancelled':
        labelText = 'Cancelled';
        chipColor = Colors.red;
        break;
      case 'Progress':
        labelText = 'Progress';
        chipColor = Colors.orange;
        break;
      default:
        labelText = 'Unknown';
        chipColor = Colors.grey;
    }
    return Chip(

      label:  Text(
        labelText ,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: const BorderSide(color: AppColors.themecolor),
    );
  }

  Future<void> _changeStatus(String newStatus) async {
    _changeStatusInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.changeStatus(widget.taskModel.sId!, newStatus));
    if (response.isSuccess) {
      widget.onRefreshList();
    } else {
      _changeStatusInProgress = false;
      setState(() {});
      showSnackBarMessage(BuildContext, context, response.errorMessage);
    }
  }
}
