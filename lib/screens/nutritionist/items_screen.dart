import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gym_project/models/nutritionist/item.dart';
import 'package:gym_project/models/nutritionist/items.dart';
import 'package:gym_project/screens/nutritionist/item-edit-form.dart';
import 'package:gym_project/screens/nutritionist/view-items-details-screen.dart';
import 'package:gym_project/viewmodels/nutritionist/item-view-model.dart';
import 'package:provider/provider.dart';

import '../../widget/global.dart';

class ItemsScreen extends StatefulWidget {
  ItemsScreen(this.isSelectionTime, {Key key, this.includeAppBar = false})
      : super(key: key);
  static String viewingRouteName = 'items/index';
  static String choosingRouteName = 'items/choose';

  final bool isSelectionTime;
  bool includeAppBar = false;

  @override
  ItemsScreenState createState() => ItemsScreenState();
}

void deleteItem(BuildContext context, int itemID, Function refresh) {
  new Future<bool>.sync(() => Provider.of<ItemViewModel>(context, listen: false)
      .deleteItem(context, itemID)).then((value) => refresh());
}

class ItemsScreenState extends State<ItemsScreen> {
  Items items = Items(data: []);
  bool finishedLoading = false;
  TextEditingController controller = TextEditingController();
  int currentPage = 1;
  ScrollController scrollController = ScrollController();

  bool _selectionMode;
  Map<int, Object> finalSelectedItems = {};
  bool _argumentsLoaded = false;
  Map<int, Map<String, Object>> oldSelectedItems = {};

  @override
  void initState() {
    super.initState();
    if (widget.isSelectionTime == true) {
      _selectionMode = true;
    } else {
      _selectionMode = false;
    }

    fetchItems('', 1);
  }

  void fetchItems(String searchText, int currentPage) {
    new Future<Items>.sync(() =>
        Provider.of<ItemViewModel>(context, listen: false).fetchItems(context,
            searchText: searchText,
            currentPage: currentPage)).then((Items value) {
      setState(() {
        if (!finishedLoading) {
          if (currentPage == 1)
            items = value;
          else
            items.data.addAll(value.data);
          finishedLoading = true;
        }
      });
    });
  }

  void refresh() {
    setState(() {
      finishedLoading = false;
      fetchItems(controller.text, currentPage);
    });
  }

  void loadArguments() {
    oldSelectedItems = ModalRoute.of(context).settings.arguments;
    if (oldSelectedItems != null && oldSelectedItems.isNotEmpty) {
      setState(() {
        oldSelectedItems.forEach((int setId, Map<String, Object> setData) {
          _numberOfSelectedInstances.add({setId: setData['quantity'] as int});
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

  List<Map<int, int>> _numberOfSelectedInstances = [];

  void setSelectionMode(bool value) {
    setState(() {
      _selectionMode = value;
    });
  }

  void incrementItem(int itemId) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(itemId));
      if (i != -1) {
        _numberOfSelectedInstances[i][itemId] =
            _numberOfSelectedInstances[i][itemId] + 1;
      } else {
        _numberOfSelectedInstances.add({itemId: 1});
      }
    });
    print(_numberOfSelectedInstances);
  }

  void decrementItem(int itemId) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(itemId));
      if (i == -1) return;
      if (_numberOfSelectedInstances[i][itemId] == 1) {
        _numberOfSelectedInstances
            .removeWhere((map) => map.containsKey(itemId));
      } else {
        _numberOfSelectedInstances[i][itemId] =
            _numberOfSelectedInstances[i][itemId] - 1;
      }
    });
    print(_numberOfSelectedInstances);
  }

  int selectedItemsNumber(itemId) {
    if (!_numberOfSelectedInstances.any((map) => map.containsKey(itemId))) {
      return 0;
    } else {
      return _numberOfSelectedInstances
          .firstWhere((map) => map.containsKey(itemId))[itemId];
    }
  }

  bool isSelected(int itemId) {
    return _numberOfSelectedInstances.any((map) => map.containsKey(itemId));
  }

  Map<int, Map<String, Object>> getFinalSelectedItems() {
    Map<int, Map<String, Object>> finalSelectedItems = {};
    for (Map<int, int> selectedItem in _numberOfSelectedInstances) {
      selectedItem.forEach((itemId, quantity) {
        finalSelectedItems[itemId] = {
          'item': items.data.firstWhere((Item item) => item.id == itemId),
          'quantity': quantity
        };
      });
    }
    return finalSelectedItems;
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
        appBar:
            // Provider.of<UserProvider>(context, listen: false).role == "admin" ||
            //         Provider.of<UserProvider>(context, listen: false).role ==
            //             "nutritionist"
            //     ? (widget.includeAppBar
            //         ?
            AppBar(
          title: Text(
            'Items',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff181818),
          iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
        ),
        //     : null)
        // : (widget.includeAppBar
        //     ? AppBar(
        //         backgroundColor: Colors.black,
        //         automaticallyImplyLeading: false,
        //         bottom: PreferredSize(
        //           preferredSize: new Size(0, 0),
        //           child: Container(),
        //         ),
        //       )
        //     : null),
        floatingActionButton: Global.role == "admin" || Global.role == "nutritionist"
                ? Container(
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/create-item');
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
                  "Items",
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
                        controller: scrollController,
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
                                        'Selected ${_numberOfSelectedInstances.length} of ${items.data.length}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectionMode = false;
                                        _numberOfSelectedInstances.clear();
                                        finalSelectedItems.clear();
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
                                childAspectRatio: 0.8,
                                children: items.data
                                    .asMap()
                                    .entries
                                    .map((entry) => MyChoosingGridViewCard(
                                          image: entry.value.image,
                                          title: entry.value.title,
                                          calories: entry.value.cal,
                                          level: entry.value.level,
                                          creator: '',
                                          index: entry.key,
                                          selectionMode: _selectionMode,
                                          setSelectionMode: setSelectionMode,
                                          incrementItem: incrementItem,
                                          decrementItem: decrementItem,
                                          selectedItemsNumber:
                                              selectedItemsNumber,
                                          isSelected: isSelected,
                                          selectionTime: widget.isSelectionTime,
                                          item: entry.value,
                                          refresh: refresh,
                                        ))
                                    .toList()),
                          ),
                          SliverToBoxAdapter(
                            child: finishedLoading
                                ? ElevatedButton(
                                    onPressed: () {
                                      finishedLoading = false;
                                      fetchItems(
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
                        Navigator.pop(context, getFinalSelectedItems());
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
  MyChoosingGridViewCard({
    Key key,
    @required this.image,
    @required this.title,
    @required this.calories,
    @required this.level,
    @required this.creator,
    @required this.index,
    @required this.selectionMode,
    @required this.setSelectionMode,
    @required this.incrementItem,
    @required this.decrementItem,
    @required this.selectedItemsNumber,
    @required this.isSelected,
    @required this.selectionTime,
    @required this.item,
    @required this.refresh,
  }) : super(key: key);

  final image;
  final title;
  final calories;
  final level;
  final creator;
  final refresh;

  final Item item;
  final int index;
  final bool selectionMode;
  final Function setSelectionMode;
  final Function incrementItem;
  final Function decrementItem;
  final Function selectedItemsNumber;
  final Function isSelected;
  final bool selectionTime;

  @override
  _MyChoosingGridViewCardState createState() => _MyChoosingGridViewCardState();
}

class _MyChoosingGridViewCardState extends State<MyChoosingGridViewCard> {
  Color mapLevelToColor(String level) {
    if (level == 'red') {
      return Colors.red.shade800;
    } else if (level == 'yellow') {
      return Colors.yellow.shade700;
    } else if (level == 'green') {
      return Colors.green.shade800;
    }
    return Colors.transparent;
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
                  builder: (context) => ItemsDetailsScreen(item: widget.item)));
        } else if (widget.selectionTime && !widget.selectionMode) {
          widget.setSelectionMode(true);
          widget.incrementItem(widget.item.id);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) => ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6.0,
                    ),
                  ],
                  color: widget.isSelected(widget.item.id)
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (widget.selectionMode)
                      SizedBox(
                        height: constraints.maxHeight * 0.2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () =>
                                    widget.incrementItem(widget.item.id),
                                icon: Icon(Icons.add)),
                            Text(
                              '${widget.selectedItemsNumber(widget.item.id)}',
                              style: TextStyle(color: Colors.black),
                            ),
                            IconButton(
                                onPressed: !widget.isSelected(widget.item.id)
                                    ? null
                                    : () =>
                                        widget.decrementItem(widget.item.id),
                                icon: Icon(Icons.remove)),
                          ],
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      height: constraints.maxHeight *
                          (widget.selectionMode ? 0.3 : 0.5),
                      padding: EdgeInsets.all(0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(imageBorderRadius),
                          topLeft: Radius.circular(imageBorderRadius),
                        ),
                        child: Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
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
                              height: constraints.maxHeight * 0.5 / 5,
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
                              height: constraints.maxHeight * 0.5 / 5,
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
                            SizedBox(
                              height: constraints.maxHeight * 0.5 / 5,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Created by:  ${widget.creator}',
                                  softWrap: false,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.5 / 10),
                            //add condition for edit button
                            !widget.selectionTime && !widget.selectionMode
                                ? SizedBox(
                                    height: constraints.maxHeight * 0.5 / 5,
                                    child: Center(
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
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditItemForm(
                                                                widget.item),
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
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  deleteItem(
                                                      context,
                                                      widget.item.id,
                                                      widget.refresh);
                                                },
                                              ),
                                            ]),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: constraints.maxHeight * 0.5 / 5,
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ItemsDetailsScreen(
                                                      item: null),
                                            ));
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ClipPath(
                clipper: ClipPathClass(),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: mapLevelToColor(widget.level).withOpacity(0.8),
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.04,
                right: constraints.maxHeight * 0.04,
                child: Transform.rotate(
                  angle: pi / 4,
                  child: Container(
                    width: constraints.maxWidth * 0.15,
                    height: constraints.maxWidth * 0.15,
                    alignment: Alignment.topCenter,
                    color: Colors.transparent,
                    child: SizedBox(
                      height: constraints.maxWidth * 0.08,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          widget.level[0].toUpperCase() +
                              widget.level.substring(1),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width - size.width * 0.25, 0);
    path.lineTo(size.width - size.width * 0.15, 0);

    // var controlPoint = Offset(size.width - 1, size.height - 1);
    // var point = Offset(size.width, size.height - 30);
    // path.quadraticBezierTo(
    //   controlPoint.dx,
    //   controlPoint.dy,
    //   point.dx,
    //   point.dy,
    // );

    path.lineTo(size.width, size.width * 0.15);
    path.lineTo(size.width, size.width * 0.25);
    path.lineTo(size.width - size.width * 0.25, 0);
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
