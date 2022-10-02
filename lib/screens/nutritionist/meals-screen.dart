import 'package:flutter/material.dart';
import 'package:gym_project/models/nutritionist/meal.dart';
import 'package:gym_project/models/nutritionist/meals.dart';
import 'package:gym_project/screens/nutritionist/view-meals-details-screen.dart';
import 'package:gym_project/viewmodels/nutritionist/meal-view-model.dart';
import 'package:provider/provider.dart';
import '../../widget/global.dart';
import 'meal-edit-form.dart';

class MealsViewScreen extends StatefulWidget {
  static String choosingRouteName = '/meals/choose';
  static String viewingRouteName = '/meals/view';
  bool isSelectionTime = false;
  bool includeAppBar = false;

  MealsViewScreen(this.isSelectionTime, {this.includeAppBar = false});

  @override
  MealsViewScreenState createState() => MealsViewScreenState();
}

void deleteMeal(BuildContext context, int mealID, Function refresh) {
  new Future<bool>.sync(() => Provider.of<MealViewModel>(context, listen: false)
      .deleteMeal(context, mealID)).then((value) => refresh());
}

class MealsViewScreenState extends State<MealsViewScreen> {
  bool finishedLoading = false;
  Meals meals = Meals(data: []);
  TextEditingController controller = TextEditingController();
  int currentPage = 1;
  ScrollController scrollController = ScrollController();

  Map<int, Map<String, Object>> oldeSelectedMeals = {};
  bool _argumentsLoaded = false;

  void loadArguments() {
    oldeSelectedMeals = ModalRoute.of(context).settings.arguments;
    if (oldeSelectedMeals != null && oldeSelectedMeals.isNotEmpty) {
      setState(() {
        oldeSelectedMeals.forEach((int mealId, Map<String, Object> mealData) {
          _numberOfSelectedInstances.add({mealId: mealData['quantity'] as int});
        });
        _selectionMode = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argumentsLoaded) {
      loadArguments();
      _argumentsLoaded = true;
    }
  }

  bool _selectionMode = false;
  List<Map<int, int>> _numberOfSelectedInstances = [];

  void setSelectionMode(bool value) {
    setState(() {
      _selectionMode = value;
    });
  }

  void incrementMeal(int mealId) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(mealId));
      if (i != -1) {
        _numberOfSelectedInstances[i][mealId] =
            _numberOfSelectedInstances[i][mealId] + 1;
      } else {
        _numberOfSelectedInstances.add({mealId: 1});
      }
    });
  }

  void decrementMeal(int mealId) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(mealId));
      if (i == -1) return;
      if (_numberOfSelectedInstances[i][mealId] == 1) {
        _numberOfSelectedInstances
            .removeWhere((map) => map.containsKey(mealId));
      } else {
        _numberOfSelectedInstances[i][mealId] =
            _numberOfSelectedInstances[i][mealId] - 1;
      }
    });
  }

  int selectedMealsNumber(mealId) {
    if (!_numberOfSelectedInstances.any((map) => map.containsKey(mealId))) {
      return 0;
    } else {
      return _numberOfSelectedInstances
          .firstWhere((map) => map.containsKey(mealId))[mealId];
    }
  }

  bool isSelected(int mealId) {
    return _numberOfSelectedInstances.any((map) => map.containsKey(mealId));
  }

  Map<int, Map<String, Object>> getFinalSelectedMeals() {
    Map<int, Map<String, Object>> finalSelectedMeals = {};
    for (Map<int, int> selectedMeal in _numberOfSelectedInstances) {
      selectedMeal.forEach((mealId, quantity) {
        finalSelectedMeals[mealId] = {
          'meal': meals.data.firstWhere((Meal meal) => meal.id == mealId),
          'quantity': quantity
        };
      });
    }
    return finalSelectedMeals;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isSelectionTime == true) {
      _selectionMode = true;
    }

    fetchMeals('', 1);
  }

  void fetchMeals(String searchText, int currentPage) {
    new Future<Meals>.sync(() =>
        Provider.of<MealViewModel>(context, listen: false).fetchMeals(context,
            searchText: searchText,
            currentPage: currentPage)).then((Meals value) {
      setState(() {
        if (!finishedLoading) {
          if (currentPage == 1)
            meals = value;
          else
            meals.data.addAll(value.data);
          finishedLoading = true;
        }
      });
    });
  }

  void refresh() {
    setState(() {
      finishedLoading = false;
      fetchMeals(controller.text, currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
        appBar:

            AppBar(
                        title: Text(
                          'Meals',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xff181818),
                        iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
                      ),
                //     : null)

        floatingActionButton: Global.role == "admin" || Global.role == "nutritionist"
                ? Container(
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/create-meal');
                      },
                      isExtended: false,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.075,
                    width: MediaQuery.of(context).size.width * 0.1,
                  )
                : Container(),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  color: Colors.black,
                ),
                width: double.infinity,
              ),
              Container(
                margin: EdgeInsets.only(left: 230, bottom: 20),
                width: 220,
                height: 190,
                decoration: BoxDecoration(
                    color: Color(0xFFFFCE2B),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(190),
                        bottomLeft: Radius.circular(290),
                        bottomRight: Radius.circular(160),
                        topRight: Radius.circular(0))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 30, bottom: 16),
                child: Text(
                  "Meals",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 40),
              finishedLoading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          if (_selectionMode)
                            SliverToBoxAdapter(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Selected ${_numberOfSelectedInstances.length} of ${meals.data.length}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectionMode = false;
                                        _numberOfSelectedInstances.clear();
                                      });
                                    },
                                    icon: CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.3),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          SliverPadding(
                            padding: const EdgeInsets.all(26.0),
                            sliver: SliverGrid.count(
                              crossAxisCount: isWideScreen ? 4 : 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio:
                                  widget.isSelectionTime ? 0.6 : 0.7,
                              children: meals.data
                                  .asMap()
                                  .entries
                                  .map((entry) => MyChoosingGridViewCard(
                                        selectedMeal: entry.value,
                                        image: 'assets/images/meal_image.jpg',
                                        title: entry.value.title,
                                        calories: entry.value.items != null
                                            ? entry.value.items.fold(0,
                                                (i, element) {
                                                return i + element.cal;
                                              })
                                            : 0,
                                        items: entry.value.items,
                                        level: "red",
                                        creator: "Not Yet",
                                        index: entry.key,
                                        selectionMode: _selectionMode,
                                        setSelectionMode: setSelectionMode,
                                        incrementMeal: incrementMeal,
                                        decrementMeal: decrementMeal,
                                        selectedMealsNumber:
                                            selectedMealsNumber,
                                        isSelected: isSelected,
                                        selectionTime: widget.isSelectionTime,
                                        refresh: refresh,
                                      ))
                                  .toList(),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: finishedLoading
                                ? ElevatedButton(
                                    onPressed: () {
                                      finishedLoading = false;
                                      fetchMeals(
                                          controller.text, ++currentPage);
                                    },
                                    child: Text('Load more'),
                                    style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                  )
                                : Center(child: CircularProgressIndicator()),
                          )
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
              if (_numberOfSelectedInstances.length > 0)
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFFFFCE2B)),
                      child: Text('Submit'),
                      onPressed: () {
                        // print(getFinalSelectedMeals());
                        Navigator.of(context).pop(getFinalSelectedMeals());
                        // Navigator.pop(context);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}

class MyChoosingGridViewCard extends StatefulWidget {
  MyChoosingGridViewCard(
      {Key key,
      @required this.image,
      @required this.title,
      @required this.calories,
      @required this.items,
      @required this.level,
      @required this.creator,
      @required this.index,
      @required this.selectionMode,
      @required this.setSelectionMode,
      @required this.incrementMeal,
      @required this.decrementMeal,
      @required this.selectedMealsNumber,
      @required this.isSelected,
      @required this.selectionTime,
      @required this.selectedMeal,
      @required this.refresh})
      : super(key: key);

  final image;
  final title;
  final calories;
  final items;
  final level;
  final creator;
  final refresh;

  final Meal selectedMeal;
  final int index;
  final bool selectionMode;
  final bool selectionTime;
  final Function setSelectionMode;
  final Function incrementMeal;
  final Function decrementMeal;
  final Function selectedMealsNumber;
  final Function isSelected;

  @override
  _MyChoosingGridViewCardState createState() => _MyChoosingGridViewCardState();
}

class _MyChoosingGridViewCardState extends State<MyChoosingGridViewCard> {
  Color mapLevelToColor(String level) {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final double imageBorderRadius = widget.selectionMode ? 0 : 30;
    return GestureDetector(
      onTap: () {
        if (!widget.selectionTime) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealsDetailsScreen(
                  widget.selectedMeal,
                  role: 'nutritionist',
                ),
              ));
        } else if (widget.selectionTime && !widget.selectionMode) {
          widget.setSelectionMode(true);
          widget.incrementMeal(widget.selectedMeal.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0,
            ),
          ],
          color: widget.isSelected(widget.selectedMeal.id)
              ? Colors.blue.withOpacity(0.5)
              : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (widget.selectionMode)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () =>
                          widget.incrementMeal(widget.selectedMeal.id),
                      icon: Icon(Icons.add)),
                  Text(
                    '${widget.selectedMealsNumber(widget.selectedMeal.id)}',
                    style: TextStyle(color: Colors.black),
                  ),
                  IconButton(
                      onPressed: !widget.isSelected(widget.selectedMeal.id)
                          ? null
                          : () => widget.decrementMeal(widget.selectedMeal.id),
                      icon: Icon(Icons.remove)),
                ],
              ),
            Expanded(
              child: Container(
                width: double.infinity,
                //height: widget.selectionMode ? 60 : 100,
                padding: EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(imageBorderRadius),
                    topLeft: Radius.circular(imageBorderRadius),
                  ),
                  child: Image.asset(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 23,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.title,
                              softWrap: false,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 23,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Calories: ${widget.calories}',
                              softWrap: false,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // for (int i = 0;
                        //     i < ((widget.items) as List<ItemMeal>).length;
                        //     i++)
                        //   Text(
                        //     '${(widget.items as List<ItemMeal>)[i].title}',
                        //     softWrap: false,
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 12,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // SizedBox(
                        //   height: 23,
                        //   child: FittedBox(
                        //     fit: BoxFit.scaleDown,
                        //     child: Text(
                        //       'Items: ${widget.items}',
                        //       softWrap: false,
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 12,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        //   child: FittedBox(
                        //     fit: BoxFit.scaleDown,
                        //     child: RichText(
                        //         softWrap: false,
                        //         text: TextSpan(
                        //           text: 'Level: ',
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 12,
                        //             color: Colors.black,
                        //           ),
                        //           children: [
                        //             TextSpan(
                        //               text: widget.level,
                        //               style: TextStyle(
                        //                 color: mapLevelToColor(widget.level),
                        //               ),
                        //             )
                        //           ],
                        //         )),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 23,
                        //   child: FittedBox(
                        //     fit: BoxFit.scaleDown,
                        //     child: Text(
                        //       'Created by:  ${widget.creator}',
                        //       softWrap: false,
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 12,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        !widget.selectionTime && !widget.selectionMode
                            ? (Global.role == "admin" || Global.role== "nutritionist"
                                ? SizedBox(
                                    height: 21,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(10.0),
                                                  ),
                                                  primary: Colors.amber,
                                                  onPrimary: Colors.black,
                                                ),
                                                child: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditMealForm(),
                                                      ));
                                                },
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(10.0),
                                                  ),
                                                  primary: Colors.amber,
                                                  onPrimary: Colors.black,
                                                ),
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  deleteMeal(
                                                      context,
                                                      widget.selectedMeal.id,
                                                      widget.refresh);
                                                },
                                              ),
                                            ]),
                                      ),
                                    ),
                                  )
                                : SizedBox())
                            : SizedBox(
                                height: 21,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(16.0),
                                          ),
                                          primary: Colors.amber,
                                          onPrimary: Colors.black,
                                        ),
                                        child: Text(
                                          'Details',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MealsDetailsScreen(null),
                                              ));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width - 50, size.height);
    path.lineTo(size.width - 30, size.height);

    var controlPoint = Offset(size.width - 1, size.height - 1);
    var point = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      point.dx,
      point.dy,
    );

    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width - 50, size.height);
    // path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Stack(
//   clipBehavior: Clip.antiAlias,
//   children: [
//     Positioned(
//       bottom: 0,
//       right: 0,
//       child: Transform.rotate(
//         angle: pi / 4,
//         child: Container(
//           width: 40,
//           height: 60,
//           decoration: BoxDecoration(
//             color: Colors.blue,
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//           ),
//         ),
//       ),
//     ),
//   ],
// ),