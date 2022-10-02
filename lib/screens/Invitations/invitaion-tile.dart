import 'package:flutter/material.dart';
import 'package:gym_project/viewmodels/invitation-view-model.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:provider/provider.dart';

import '../../widget/global.dart';

class InvitationTile extends StatefulWidget {
  final String path;
  final String memberName;
  final String guestName;
  final String guestPhoneNumber;
  final int id;

  InvitationTile(this.path, this.memberName, this.guestName,
      this.guestPhoneNumber, this.id);

  @override
  _InvitationTileState createState() => _InvitationTileState();
}

class _InvitationTileState extends State<InvitationTile> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        margin: EdgeInsetsDirectional.only(bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xff181818),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          minVerticalPadding: 10,
          leading: CircleAvatar(
            radius: 20,
            child: Image.asset(widget.path),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Member : ",
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                  Text(
                    widget.memberName,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Guest : ",
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                  Text(
                    widget.guestName,
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Provider.of<InvitationViewModel>(context, listen: false)
                          .deleteInvitation(
                              widget.id,
                              Provider.of<LoginViewModel>(context,
                                      listen: false)
                                  .token);
                      setState(() {
                        isVisible = false;
                      });
                    },
                    child: Global.role == 'admin'
                            ? new Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 22.0,
                              )
                            : Container(),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Guest Number : ",
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                  Text(
                    widget.guestPhoneNumber,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
