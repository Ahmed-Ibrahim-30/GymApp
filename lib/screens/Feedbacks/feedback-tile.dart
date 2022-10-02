import 'package:flutter/material.dart';

class FeedbackTile extends StatefulWidget {
  final String path;
  final String memberName;
  final String title;
  final String description;

  FeedbackTile(this.path, this.memberName, this.title, this.description);

  @override
  _FeedbackTileState createState() => _FeedbackTileState();
}

class _FeedbackTileState extends State<FeedbackTile> {
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title.length > 35 ? '${widget.title.substring(0, 35)}...' : widget.title,
                  style: TextStyle(color: Colors.amberAccent),

                ),
                // InkWell(
                //   onTap: () {

                //   },
                //   child: role =='admin' ? new Icon(
                //     Icons.delete,
                //     color: Colors.red,
                //     size: 22.0,
                //   ):Container(),
                // ),   
              ],
            ),
            Row(
              children: [
                // Text("Guest : ",style: TextStyle(color: Colors.amberAccent),),
                Text(
                  widget.memberName.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                // Text("Guest Number : ",style: TextStyle(color: Colors.amberAccent),),
                Flexible(
                  child: Text(
                    widget.description,
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.clip,
                  ),)
              ],
            ),
          ],
        ),
        
      ),
    );
  }
}