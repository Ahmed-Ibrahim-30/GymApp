import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/helper/constants.dart';
import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/models/nutritionist/item-meal.dart';
import 'package:gym_project/models/nutritionist/item.dart';
import 'package:gym_project/models/nutritionist/meal.dart';
import 'package:gym_project/screens/common/widget-builders.dart';
import 'package:gym_project/screens/nutritionist/items_screen.dart';
import 'package:gym_project/viewmodels/nutritionist/meal-view-model.dart';
import 'package:provider/provider.dart';

Map<int, Map<String, Object>> selectedItems = {};

class CreateMealForm extends StatefulWidget {
  bool isEditing;

  static String editingRouteName = '/meals/edit';

  CreateMealForm({this.isEditing = false});

  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
class MapScreenState extends State<CreateMealForm>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  bool _argumentsLoaded = false;
  Meal meal;
  final FocusNode myFocusNode = FocusNode();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setTextFormFieldsInitialValues([
      titleController,
      descriptionController,
    ], [
      'Flutter Form Meal 1',
      'description of flutter form meal',
    ]);

    // Provider.of<MealViewModel>(context, listen: false).putMeal(
    //   Meal(
    //     id: 11,
    //     title: 'flutter edited meal 3',
    //     description: 'description of flutter meal',
    //     items: [ItemMeal(id: 1, quantity: 2)],
    //   ),
    //   getToken(context),
    // );
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isEditing && !_argumentsLoaded) {
      int mealId = ModalRoute.of(context).settings.arguments;
      Provider.of<MealViewModel>(context, listen: false)
          .fetchMeal(mealId, context)
          .then((meal) {
        setState(() {
          this.meal = meal;
          selectedItems = getSelectedItemsFromItemMealList(meal.items);
        });
        setTextFormFieldsInitialValues(
          [titleController, descriptionController],
          [meal.title, meal.description],
        );
      });
      _argumentsLoaded = true;
    }
  }

  refresh() {
    setState(() {});
  }

  List<ItemMeal> getItemMealListFromSelectedItems(
      Map<int, Map<String, Object>> selectedItems) {
    List<ItemMeal> itemMealList = [];
    selectedItems.values.forEach((itemData) {
      Item item = itemData['item'];
      int quantity = itemData['quantity'];
      itemMealList.add(item.toItemMeal(quantity: quantity));
    });
    return itemMealList;
  }

  Map<int, Map<String, Object>> getSelectedItemsFromItemMealList(
    List<ItemMeal> itemMealList,
  ) {
    Map<int, Map<String, Object>> selectedItems = {};
    selectedItems.clear();
    itemMealList.forEach((itemMeal) {
      selectedItems[itemMeal.id] = {
        'item': itemMeal.toItem(),
        'quantity': itemMeal.quantity,
      };
    });
    return selectedItems;
  }

  Meal getInputMeal() {
    Meal inputMeal = Meal(
      title: titleController.text,
      description: descriptionController.text,
      items: getItemMealListFromSelectedItems(selectedItems),
    );
    if (widget.isEditing) inputMeal.id = this.meal.id;
    return inputMeal;
  }

  Future<void> chooseItems() async {
    var returnedSelectedItems = await Navigator.pushNamed(
      context,
      ItemsScreen.choosingRouteName,
      arguments: selectedItems,
    ) as Map<int, Map<String, Object>>;
    if (returnedSelectedItems != null && returnedSelectedItems.isNotEmpty) {
      setState(() {
        selectedItems = returnedSelectedItems;
      });
    }
  }

  void submitMeal(bool isEditing) {
    String token = getToken(context);
    Meal meal = getInputMeal();
    MealViewModel mealsVM = Provider.of<MealViewModel>(context, listen: false);
    if (!isEditing)
      mealsVM.postMeal(meal, token);
    else
      mealsVM.putMeal(meal, token);
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    MealViewModel mealVM;
    if (widget.isEditing) mealVM = Provider.of<MealViewModel>(context);
    bool isLoading =
        widget.isEditing && mealVM.loadingStatus == LoadingStatus.Searching ??
            false;
    return new Scaffold(
      body: SafeArea(
        child: new Container(
          color: Color(0xFF181818), //background color
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 100.0,
                    color: Color(0xFF181818), //background color
                    child: new Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  child: new Icon(
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
                                  //-->header
                                  child: new Text(
                                    !widget.isEditing
                                        ? 'Create Meal'
                                        : 'Edit Meal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      fontFamily: 'sans-serif-light',
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                  new Container(
                    //height: 1000.0,
                    constraints: new BoxConstraints(minHeight: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),

                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: isLoading
                          ? loadingContainer(context)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              //---> topic
                                              'Meal Information',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[],
                                        )
                                      ],
                                    )),
                                buildTextFormFieldLabel('Title'),
                                buildTextFormField(
                                  controller: titleController,
                                  hintText: 'Enter Title',
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Title is required';
                                    return null;
                                  },
                                ),
                                buildTextFormFieldLabel('Description'),
                                buildTextFormField(
                                  controller: descriptionController,
                                  hintText: 'Enter Description',
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Description is required';
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Items',
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
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisAlignment: isWideScreen
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: ElevatedButton(
                                          child: Text('Choose Items'),
                                          style: ElevatedButton.styleFrom(
                                              textStyle: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                              onPrimary: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              )),
                                          onPressed: chooseItems,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:
                                      selectedItems.values.map((itemData) {
                                    int quantity = itemData['quantity'];
                                    Item item = itemData['item'];
                                    return CustomListTile(
                                      item: item,
                                      quantity: quantity,
                                      notifyParent: refresh,
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 95.0,
                                      bottom: 0,
                                      right: 95.0,
                                      top: 50.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 0),
                                          child: Container(
                                              width: isWideScreen ? 200 : null,
                                              child: Center(
                                                child: new ElevatedButton(
                                                  child: new Text(
                                                    !widget.isEditing
                                                        ? 'Create'
                                                        : 'Edit',
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(10.0),
                                                    ),
                                                    primary: Color(0xFFFFCE2B),
                                                    onPrimary: Colors.black,
                                                    // padding: EdgeInsets.symmetric(
                                                    //     horizontal: 10, vertical: 5),
                                                    textStyle: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onPressed: () => submitMeal(
                                                      widget.isEditing),
                                                ),
                                              )),
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}

class CustomListTile extends StatefulWidget {
  final Item item;
  final int quantity;
  final Key key;
  final Function() notifyParent;

  CustomListTile({
    this.key,
    @required this.item,
    @required this.quantity,
    @required this.notifyParent,
  }) : super(key: key);
  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      key: widget.key,
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        key: widget.key,
        minVerticalPadding: 10,
        leading: CircleAvatar(
          radius: 20,
          child: FlutterLogo(),
        ),
        title: Text(
          widget.item.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text(
            //   widget.exercise['duration'],
            //   style: TextStyle(
            //     color: Colors.white,
            //   ),
            // ),
            Text(
              'quantity: ${widget.quantity}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              'id: ${widget.item.id}',
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
