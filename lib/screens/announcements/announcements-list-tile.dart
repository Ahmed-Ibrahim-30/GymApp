import 'package:flutter/material.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/announcements/add-announcement-screen.dart';
import 'package:gym_project/services/admin-services/announcements_services.dart';
import 'package:gym_project/widget/delete-iconbutton.dart';
import 'package:gym_project/widget/edit-iconbutton.dart';
import '../../bloc/Admin_cubit/admin_cubit.dart';
class AnnouncementsListTile extends StatelessWidget {
  final String title;
  final String body;
  final String date;
  final String role; // member or admin
  final int id;
  final AdminCubit myCubit;

  AnnouncementsListTile({this.title, this.body, this.date, this.id, this.role,this.myCubit});
  bool is_visible=true;


  editAnnouncement(int id, String title, String body,BuildContext context) {
    goToAnotherScreenPush(context,AddAnnouncementScreen(
        body: body,
        title: title,
        post_type: 'Edit',
        id: id,
        myCubit:myCubit
    ),);
  }

  deleteAnnouncement(int id,BuildContext context,AdminCubit myCubit) {//TODO
    AnnouncementsServices.deleteAnnouncement(id,adminCubit: myCubit);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: is_visible,
      child: Container(
        margin: EdgeInsetsDirectional.only(bottom: 10),
        decoration: BoxDecoration(
          color: myGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          isThreeLine: true,
          minVerticalPadding: 10,
          title: Padding(
            padding: const EdgeInsets.only(
                right: 0.0, top: 8.0, bottom: 8.0, left: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.58,
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        date,
                        style: TextStyle(
                          color: Color(0xFFFFCE2B),
                          fontSize: 12,
                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                        ),
                      ),
                    ),
                  ],
                ),
                role == "admin"
                    ? Container(
                        padding: const EdgeInsets.only(right: 4),
                        width: MediaQuery.of(context).size.width * 0.18,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DeleteIconButton(
                              context: context,
                              text:
                                  'Would you like to delete this announcement ?',
                              onDelete: () => deleteAnnouncement(id,context,myCubit),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            EditIconButton(
                              onPressed: () => editAnnouncement(
                                  id, title, body,context),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
