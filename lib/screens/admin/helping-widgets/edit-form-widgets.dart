// import 'package:flutter/material.dart';
//
// Widget field(String title, String body, TextEditingController textController) {
//   print('in the body');
//   print(textController.text);
//   return Column(
//     children: [
//       Padding(
//         padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
//         child: new Row(
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             new Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 new Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
//         child: new Row(
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             new Flexible(
//               child: new TextFormField(
//                 controller: textController..text = body,
//                 decoration: InputDecoration(
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: const BorderSide(
//                       color: Color(0xFFFFCE2B),
//                       width: 2.0,
//                     ),
//                   ),
//                 ),
//                 //initialValue: body,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }
//
// // this class is dedicated to branch form
// class CustomEquipmentListTile extends StatefulWidget {
//   final Map equipment;
//   final Function() notifyParent;
//
//   CustomEquipmentListTile(this.equipment, this.notifyParent);
//   @override
//   _CustomEquipmentListTileState createState() =>
//       _CustomEquipmentListTileState();
// }
//
// // this class is dedicated to branch form
// class _CustomEquipmentListTileState extends State<CustomEquipmentListTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsetsDirectional.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Color(0xff181818),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ListTile(
//         minVerticalPadding: 10,
//         leading: CircleAvatar(
//           radius: 20,
//           child: FlutterLogo(),
//         ),
//         title: Text(
//           widget.equipment['name'],
//           style: TextStyle(color: Colors.white),
//         ),
//         trailing: Column(
//           children: [
//             Text(widget.equipment['value'].toString()),
//             SizedBox(height: 4),
//             GestureDetector(
//               child: Icon(
//                 Icons.close,
//                 color: Colors.white,
//               ),
//               onTap: () {
//                 _selectedEquipment.remove(widget.equipment);
//                 print(_selectedEquipment);
//                 widget.notifyParent();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // this variable is dedicated to branch form
// List<Map> _selectedEquipment = [];
