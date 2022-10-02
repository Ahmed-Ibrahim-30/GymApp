import 'package:flutter/material.dart';

class CustomListTileNoTrailing extends StatefulWidget {
  final String title;
  final List<String> subtitles;

  CustomListTileNoTrailing(this.title, this.subtitles);
  @override
  _CustomListTileNoTrailingState createState() =>
      _CustomListTileNoTrailingState();
}

class _CustomListTileNoTrailingState extends State<CustomListTileNoTrailing> {
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
          child: FlutterLogo(),
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (String subtitle in widget.subtitles)
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}
