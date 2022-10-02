import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/helper/constants.dart';
import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/models/nutritionist/item-plan.dart';
import 'package:gym_project/models/nutritionist/item.dart';
import 'package:gym_project/models/nutritionist/meal-plan.dart';
import 'package:gym_project/models/nutritionist/meal.dart';
import 'package:gym_project/models/nutritionist/plan.dart';
import 'package:gym_project/screens/common/widget-builders.dart';
import 'package:gym_project/screens/nutritionist/items_screen.dart';
import 'package:gym_project/screens/nutritionist/meals-screen.dart';
import 'package:gym_project/services/nutritionist/plan-webservice.dart';
import 'package:gym_project/viewmodels/groups-view-model.dart';
import 'package:gym_project/viewmodels/nutritionist/plan-view-model.dart';
import 'package:provider/provider.dart';

Map<int, Map<String, Object>> selectedItems = {};
List<ItemPlan> itemsList = [];
Map<int, Map<String, Object>> selectedMeals = {};
List<MealPlan> mealsList = [];

List<MealPlan> getMealsList({
  @required Map<int, Map<String, Object>> selectedMeals,
}) {
  List<MealPlan> mealsList = [];
  selectedMeals.values.forEach((mealData) {
    int quantity = mealData['quantity'];
    Meal meal = mealData['meal'];
    MealPlan mealPlan = meal.toMealPlan(day: null, type: null);
    for (int i = 0; i < quantity; i++) mealsList.add(mealPlan);
  });
  return mealsList;
}

List<ItemPlan> getItemsList({
  @required Map<int, Map<String, Object>> selectedItems,
}) {
  List<ItemPlan> itemsList = [];
  selectedItems.values.forEach((itemData) {
    int quantity = itemData['quantity'];
    Item item = itemData['item'];
    ItemPlan itemPlan = item.toItemPlan(day: null, type: null);
    for (int i = 0; i < quantity; i++) itemsList.add(itemPlan);
  });
  return itemsList;
}

class CreatePlanForm extends StatefulWidget {
  final bool isEditing;

  static String creatingRouteName = '/plans/create';
  static String editingRouteName = '/plans/edit';

  CreatePlanForm({this.isEditing = false});

  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
class MapScreenState extends State<CreatePlanForm>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  bool _argumentsLoaded = false;
  final FocusNode myFocusNode = FocusNode();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setTextFormFieldsInitialValues(
      [titleController, descriptionController],
      ['flutter plan 1', 'description of flutter plan'],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isEditing && !_argumentsLoaded) {
      int planId = ModalRoute.of(context).settings.arguments;
      Provider.of<PlanViewModel>(context, listen: false)
          .fetchPlan(planId, context)
          .then((plan) {
        setState(() {
          itemsList = plan.items;
          mealsList = plan.meals;
          selectedItems = getSelectedItems(itemPlanList: itemsList);
          selectedMeals = getSelectedMeals(mealPlanList: mealsList);
        });
        setTextFormFieldsInitialValues(
          [titleController, descriptionController],
          [plan.title, plan.description],
        );
      });
      _argumentsLoaded = true;
    }
  }

  Map<int, Map<String, Object>> getSelectedItems({
    List<ItemPlan> itemPlanList,
  }) {
    Map<int, Map<String, Object>> selectedItems = {};
    List<int> uniqueIds =
        itemPlanList.map((itemPlan) => itemPlan.id).toSet().toList();
    uniqueIds.forEach((id) {
      ItemPlan itemPlan =
          itemPlanList.firstWhere((itemPlan) => itemPlan.id == id);
      Map<String, Object> itemData = {
        'item': itemPlan.toItem(),
        'quantity': getItemPlanQuantity(itemPlanList, itemPlan),
      };
      MapEntry<int, Map<String, Object>> selectedItem =
          MapEntry(itemPlan.id, itemData);
      selectedItems.addEntries([selectedItem]);
    });
    return selectedItems;
  }

  int getItemPlanQuantity(
    List<ItemPlan> itemPlanList,
    ItemPlan itemPlan,
  ) {
    List<ItemPlan> sameItemPlanList =
        itemPlanList.where((iP) => iP.id == itemPlan.id).toList();
    return sameItemPlanList.length;
  }

  Map<int, Map<String, Object>> getSelectedMeals({
    List<MealPlan> mealPlanList,
  }) {
    Map<int, Map<String, Object>> selectedMeals = {};
    List<int> uniqueIds =
        mealPlanList.map((mealPlan) => mealPlan.id).toSet().toList();
    uniqueIds.forEach((id) {
      MealPlan mealPlan =
          mealPlanList.firstWhere((mealPlan) => mealPlan.id == id);
      Map<String, Object> mealData = {
        'meal': mealPlan.toMeal(),
        'quantity': getMealPlanQuantity(mealPlanList, mealPlan),
      };
      MapEntry<int, Map<String, Object>> selectedMeal =
          MapEntry(mealPlan.id, mealData);
      selectedMeals.addEntries([selectedMeal]);
    });
    return selectedMeals;
  }

  int getMealPlanQuantity(
    List<MealPlan> mealPlanList,
    MealPlan mealPlan,
  ) {
    List<MealPlan> sameMealPlanList =
        mealPlanList.where((mP) => mP.id == mealPlan.id).toList();
    return sameMealPlanList.length;
  }

  refresh() {
    setState(() {});
  }

  Future<void> chooseItems() async {
    var returnedSelectedItems = await Navigator.pushNamed(
      context,
      ItemsScreen.choosingRouteName,
      arguments: selectedItems,
    ) as Map<int, Map<String, Object>>;
    if (returnedSelectedItems != null && returnedSelectedItems.isNotEmpty) {
      // returnedSelectedItems = returnedSelectedItems.map((itemId, itemData) {
      //   Item item = itemData['item'];
      //   ItemPlan itemPlan = item.toItemPlan();
      //   int quantity = itemData['quantity'];
      //   Map<String, Object> newItemData = {
      //     'item': itemPlan,
      //     'quantity': quantity,
      //   };
      //   return MapEntry(itemId, newItemData);
      // });
      setState(() {
        selectedItems = returnedSelectedItems;
        itemsList = getItemsList(selectedItems: selectedItems);
      });
    }
  }

  Future<void> chooseMeals() async {
    var returnedSelectedMeals = await Navigator.pushNamed(
      context,
      MealsViewScreen.choosingRouteName,
      arguments: selectedMeals,
    ) as Map<int, Map<String, Object>>;
    if (returnedSelectedMeals != null && returnedSelectedMeals.isNotEmpty) {
      setState(() {
        selectedMeals = returnedSelectedMeals;
        mealsList = getMealsList(selectedMeals: selectedMeals);
      });
    }
  }

  Plan get inputPlan {
    int planId = Provider.of<PlanViewModel>(context, listen: false).plan.id;
    return Plan(
      id: widget.isEditing ? planId : null,
      title: titleController.text,
      description: descriptionController.text,
      items: itemsList,
      meals: mealsList,
    );
  }

  void createPlan() {
    Provider.of<PlanViewModel>(context, listen: false)
        .postPlan(inputPlan, getToken(context));
    // Navigator.of(context).pop();
  }

  void editPlan() {
    Provider.of<PlanViewModel>(context, listen: false)
        .putPlan(inputPlan, getToken(context));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    PlanViewModel planVM = Provider.of<PlanViewModel>(context);
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
                                  child: Text(
                                    !widget.isEditing
                                        ? 'Create Plan'
                                        : 'Edit Plan',
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

                    //color: Colors.white,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          if (planVM.loadingStatus == LoadingStatus.Searching)
                            loadingContainer(context),
                          if (planVM.loadingStatus == LoadingStatus.Completed)
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
                                          'Plan Information',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                              if (value.isEmpty) return 'Title is required';
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Items & Meals',
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: ElevatedButton(
                                    child: Text(
                                      'Choose Items',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        primary: Theme.of(context).primaryColor,
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
                            children: itemsList.map((itemPlan) {
                              return CustomListTile(
                                object: itemPlan,
                                notifyParent: refresh,
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: ElevatedButton(
                                      child: Text(
                                        'Choose Meals',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          textStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          primary:
                                              Theme.of(context).primaryColor,
                                          onPrimary: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          )),
                                      onPressed: chooseMeals),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: mealsList.map((mealPlan) {
                              return CustomListTile(
                                object: mealPlan,
                                notifyParent: refresh,
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 95.0, bottom: 0, right: 95.0, top: 50.0),
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
                                            child: Text(
                                              !widget.isEditing
                                                  ? "Create"
                                                  : "Edit",
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                              ),
                                              primary: Color(0xFFFFCE2B),
                                              onPrimary: Colors.black,
                                              // padding: EdgeInsets.symmetric(
                                              //     horizontal: 10, vertical: 5),
                                              textStyle: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: !widget.isEditing
                                                ? createPlan
                                                : editPlan,
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
    disposeOfControllers([titleController, descriptionController]);
    myFocusNode.dispose();
    super.dispose();
  }
}

class CustomListTile extends StatefulWidget {
  final dynamic object;
  final Key key;
  final Function() notifyParent;

  CustomListTile({
    this.key,
    this.object,
    @required this.notifyParent,
  }) : super(key: key) {
    assert(
      object.runtimeType == ItemPlan || object.runtimeType == MealPlan,
      'object must be of type ItemPlan or MealPlan',
    );
  }
  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  void initState() {
    super.initState();
  }

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
          widget.object.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'id: ${widget.object.id}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            buildDropdownButton(
              context,
              displayedItems: daysOfTheWeek,
              itemsType: 'day',
              object: widget.object,
              setParentState: setState,
            ),
            buildDropdownButton(
              context,
              displayedItems: mealsTypes,
              itemsType: 'type',
              object: widget.object,
              setParentState: setState,
            )
          ],
        ),
      ),
    );
  }
}
