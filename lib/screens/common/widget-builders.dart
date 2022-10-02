import 'package:flutter/material.dart';
import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/models/nutritionist/item-plan.dart';
import 'package:gym_project/models/nutritionist/meal-plan.dart';

Widget buildTextFormFieldLabel(String label) {
  return Padding(
    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
    child: new Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildTextFormField({
  String hintText,
  TextEditingController controller,
  String Function(String) validator,
}) {
  return Padding(
    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
    child: new Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Flexible(
          child: new TextFormField(
              decoration: InputDecoration(
                hintText: hintText,
              ),
              controller: controller,
              validator: validator),
        ),
      ],
    ),
  );
}

Widget buildHeader(BuildContext context) {
  Text editSetTextWidget = Text(
    'Create Group',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      fontFamily: 'sans-serif-light',
      color: Colors.white,
    ),
  );

  return Container(
    height: 100.0,
    color: Color(0xFF181818), //background color
    child: Padding(
      padding: EdgeInsets.only(left: 20.0, top: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFFFCE2B),
              size: 22.0,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: editSetTextWidget,
          )
        ],
      ),
    ),
  );
}

Future viewErrorDialogBox(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          child: Text(
            'Ok',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}

Widget loadingContainer(BuildContext context, {bool withHeight = true}) {
  return Container(
    width: double.infinity,
    height: withHeight ? 500 : 50,
    child: Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ),
    ),
  );
}

Widget buildDropdownButton(
  BuildContext context, {
  @required List<String> displayedItems,
  @required String itemsType,
  @required dynamic object,
  @required Function setParentState,
  String hint,
}) {
  assert(
    itemsType == 'day' || itemsType == 'type',
    'allowed values for "itemsType" are "day" and "type"',
  );
  assert(
    object.runtimeType == ItemPlan || object.runtimeType == MealPlan,
    'drop down button should be passed an ItemPlan or a MealPlan object',
  );

  List<DropdownMenuItem> items = displayedItems
      .map((displayedItem) => DropdownMenuItem(
            child: Text(
              capitalize(displayedItem),
              style: TextStyle(color: Colors.white),
            ),
            value: displayedItem,
          ))
      .toList();

  String value = itemsType == 'day' ? object.day : object.type;
  return DropdownButton(
    items: items,
    value: value,
    onChanged: (value) => setParentState(() {
      if (itemsType == 'day')
        object.day = value;
      else if (itemsType == 'type') object.type = value;
    }),
    dropdownColor: Colors.black,
    isDense: true,
    hint: Text(
      hint ?? 'Choose a $itemsType',
      style: TextStyle(color: Colors.white),
    ),
    style: TextStyle(color: Colors.white),
    iconEnabledColor: Theme.of(context).primaryColor,
    underline: Container(height: 1, color: Theme.of(context).primaryColor),
  );
}

Future<bool> confirmPop(
  BuildContext context, {
  @required String content,
  bool doNotConfirmIf = false,
}) async {
  if (doNotConfirmIf) return true;
  bool popConfirmed = false;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Warning'),
      titleTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      content: Text(content, style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          child: Text(
            'Yes',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red,
            ),
          ),
          onPressed: () {
            popConfirmed = true;
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'No',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            popConfirmed = false;
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
  return popConfirmed;
}
