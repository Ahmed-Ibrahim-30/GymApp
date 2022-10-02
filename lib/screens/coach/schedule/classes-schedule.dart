import 'package:gym_project/common/my_list_tile.dart';
import 'package:gym_project/models/classes.dart';
import 'package:gym_project/screens/admin/classes/class_details.dart';
import 'package:gym_project/style/datetime.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/viewmodels/coach-view-model.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ClassesSchedule extends StatefulWidget {
  @override
  _ClassesScheduleState createState() => _ClassesScheduleState();
}

class _ClassesScheduleState extends State<ClassesSchedule> {
  List<Classes> classes;
  void initState() {
    super.initState();
    fetchSchedule();
  }

  bool done = false;
  bool error = false;

  fetchSchedule() {
    Provider.of<CoachViewModel>(context, listen: false)
        .fetchSchedule()
        .then((value) {
      setState(() {
        done = true;
        classes =
            Provider.of<CoachViewModel>(context, listen: false).schedule.item2;
      });
    }).catchError((err) {
      setState(() {
        error = true;
        showErrorMessage(context, 'Failed to load schedule!');
      });
      print('error occured $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ListView(
        children: [
          SizedBox(height: 20),
          error
              ? CustomErrorWidget()
              : !done
                  ? Progress()
                  : done && classes.isEmpty
                      ? EmptyListError('Nothing scheduled.')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: classes.length,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClassDetails(),
                                  ),
                                );
                              },
                              child: CustomListTile(
                                classes[index].title,
                                [
                                  formatDate(classes[index].date.toString()),
                                ],
                                trailing: '',
                                iconData: Icons.event,
                              ),
                            );
                          }),
        ],
      ),
    );
  }
}
