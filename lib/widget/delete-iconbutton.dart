import 'package:flutter/material.dart';
import 'package:gym_project/widget/alert-dialog.dart';
import 'package:gym_project/widget/material-button.dart';

class DeleteIconButton extends StatefulWidget {
  final String text;
  final Function onDelete;
  final BuildContext context;

  DeleteIconButton({this.context, this.text, this.onDelete});

  @override
  _DeleteIconButtonState createState() => _DeleteIconButtonState();
}

class _DeleteIconButtonState extends State<DeleteIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //iconSize: MediaQuery.of(context).size.width * 0.045,
      //constraints: BoxConstraints(maxHeight: 0, maxWidth: 15),
      onTap: () {
        showDialog(
          context: widget.context,
          builder: (buildercontext) => CustomAlertDialog(
            text: widget.text,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomMaterialButton(
                    formButton: false,
                    text: 'YES',
                    onPressed: widget.onDelete,
                  ),
                  CustomMaterialButton(
                    formButton: false,
                    text: 'NO',
                    onPressed: () {
                      Navigator.of(buildercontext).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
      child: Icon(
        Icons.delete,
        size: MediaQuery.of(context).size.width * 0.045,
        color: Colors.grey,
      ),
    );
  }
}
