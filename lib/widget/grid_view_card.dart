import 'package:flutter/material.dart';

//if there is no subTitle1,2,3,4 put their values in the call with ''
// ignore: non_constant_identifier_names
Widget GridViewCard(image, title, subTitle1, subTitle2, subTitle3, subTitle4,
    BuildContext context) {
  Size deviceSize = MediaQuery.of(context).size;
  int numSubtitles = 0;
  if (subTitle1 != '') {
    numSubtitles++;
  }
  if (subTitle2 != '') {
    numSubtitles++;
  }
  if (subTitle3 != '') {
    numSubtitles++;
  }
  if (subTitle4 != '') {
    numSubtitles++;
  }

  double height = numSubtitles == 1
      ? 100
      : numSubtitles == 2
          ? 140
          : numSubtitles == 3
              ? 180
              : numSubtitles == 4
                  ? 200
                  : 80;

  return Container(
    height: height,
    width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 6.0,
        ),
      ],
      color: Colors.white,
    ),
    child: Center(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: deviceSize.width < 450
                ? deviceSize.width < 900
                    ? height
                    : 110
                : deviceSize.width < 900
                    ? 110
                    : 175,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
            child: Column(
              children: [
            Text(title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
                // overflow: TextOverflow.ellipsis,
              )),
          subTitle1 != ''
              ? Text(subTitle1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                    // overflow: TextOverflow.ellipsis,
                  ))
              : Container(),
          subTitle2 != ''
              ? Text(subTitle2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                    // overflow: TextOverflow.ellipsis,
                  ))
              : Container(),
          subTitle3 != ''
              ? Text(subTitle3,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                    // overflow: TextOverflow.ellipsis,
                  ))
              : Container(),
          subTitle4 != ''
              ? Text(subTitle4,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                    // overflow: TextOverflow.ellipsis,
                  ))
              : Container(),
          ],
            ),
          )
        ],
      ),
    ),
  );
}
