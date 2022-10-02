import 'package:flutter/material.dart';
import 'package:gym_project/core/presentation/res/assets.dart';

class MyChoosingGridViewScreen extends StatefulWidget {
  const MyChoosingGridViewScreen({Key key}) : super(key: key);
  static final String path = "lib/src/pages/ecommerce/ecommerce5.dart";

  @override
  _MyChoosingGridViewScreenState createState() =>
      _MyChoosingGridViewScreenState();
}

class _MyChoosingGridViewScreenState extends State<MyChoosingGridViewScreen> {
  bool _selectionMode = false;
  List<Map<int, int>> _numberOfSelectedInstances = [];

  void setSelectionMode(bool value) {
    setState(() {
      _selectionMode = value;
    });
  }

  void incrementItem(int index) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(index));
      if (i != -1) {
        _numberOfSelectedInstances[i][index] =
            _numberOfSelectedInstances[i][index] + 1;
      } else {
        _numberOfSelectedInstances.add({index: 1});
      }
    });
  }

  void decrementItem(int index) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(index));
      if (i == -1) return;
      if (_numberOfSelectedInstances[i][index] == 1) {
        _numberOfSelectedInstances.removeWhere((map) => map.containsKey(index));
      } else {
        _numberOfSelectedInstances[i][index] =
            _numberOfSelectedInstances[i][index] - 1;
      }
    });
  }

  int selectedItemsNumber(index) {
    if (!_numberOfSelectedInstances.any((map) => map.containsKey(index))) {
      return 0;
    } else {
      return _numberOfSelectedInstances
          .firstWhere((map) => map.containsKey(index))[index];
    }
  }

  bool isSelected(int index) {
    return _numberOfSelectedInstances.any((map) => map.containsKey(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Equipment",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 40),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          controller: TextEditingController(),
                          cursorColor: Theme.of(context).primaryColor,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: 'Search',
                            suffixIcon: Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(Icons.search),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_selectionMode)
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Selected ${_numberOfSelectedInstances.length} of 6}',
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
                          backgroundColor: Colors.black.withOpacity(0.3),
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
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                  children: <Widget>[
                    MyChoosingGridViewCard(
                      dumbbell,
                      'Dumbbell',
                      'Sub Title 1',
                      'Sub Title 2',
                      'Sub Title 3',
                      'Sub Title 4',
                      index: 0,
                      selectionMode: _selectionMode,
                      setSelectionMode: setSelectionMode,
                      incrementItem: incrementItem,
                      decrementItem: decrementItem,
                      selectedItemsNumber: selectedItemsNumber,
                      isSelected: isSelected,
                    ),
                    MyChoosingGridViewCard(
                      treadmill,
                      'Treadmill',
                      'Sub Title 1',
                      'Sub Title 2',
                      'Sub Title 3',
                      'Sub Title 4',
                      index: 1,
                      selectionMode: _selectionMode,
                      setSelectionMode: setSelectionMode,
                      incrementItem: incrementItem,
                      decrementItem: decrementItem,
                      selectedItemsNumber: selectedItemsNumber,
                      isSelected: isSelected,
                    ),
                    MyChoosingGridViewCard(
                      dumbbell,
                      'Dumbbell',
                      'Sub Title 1',
                      'Sub Title 2',
                      'Sub Title 3',
                      'Sub Title 4',
                      index: 2,
                      selectionMode: _selectionMode,
                      setSelectionMode: setSelectionMode,
                      incrementItem: incrementItem,
                      decrementItem: decrementItem,
                      selectedItemsNumber: selectedItemsNumber,
                      isSelected: isSelected,
                    ),
                    MyChoosingGridViewCard(
                      treadmill,
                      'Treadmill',
                      'Sub Title 1',
                      'Sub Title 2',
                      'Sub Title 3',
                      'Sub Title 4',
                      index: 3,
                      selectionMode: _selectionMode,
                      setSelectionMode: setSelectionMode,
                      incrementItem: incrementItem,
                      decrementItem: decrementItem,
                      selectedItemsNumber: selectedItemsNumber,
                      isSelected: isSelected,
                    ),
                    MyChoosingGridViewCard(
                      dumbbell,
                      'Dumbbell',
                      'Sub Title 1',
                      'Sub Title 2',
                      'Sub Title 3',
                      'Sub Title 4',
                      index: 4,
                      selectionMode: _selectionMode,
                      setSelectionMode: setSelectionMode,
                      incrementItem: incrementItem,
                      decrementItem: decrementItem,
                      selectedItemsNumber: selectedItemsNumber,
                      isSelected: isSelected,
                    ),
                    MyChoosingGridViewCard(
                      treadmill,
                      'Treadmill',
                      'Sub Title 1',
                      'Sub Title 2',
                      'Sub Title 3',
                      'Sub Title 4',
                      index: 5,
                      selectionMode: _selectionMode,
                      setSelectionMode: setSelectionMode,
                      incrementItem: incrementItem,
                      decrementItem: decrementItem,
                      selectedItemsNumber: selectedItemsNumber,
                      isSelected: isSelected,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

class MyChoosingGridViewCard extends StatefulWidget {
  MyChoosingGridViewCard(
    this.image,
    this.title,
    this.subTitle1,
    this.subTitle2,
    this.subTitle3,
    this.subTitle4, {
    Key key,
    @required this.index,
    @required this.selectionMode,
    @required this.setSelectionMode,
    @required this.incrementItem,
    @required this.decrementItem,
    @required this.selectedItemsNumber,
    @required this.isSelected,
  }) : super(key: key);

  final image;
  final title;
  final subTitle1;
  final subTitle2;
  final subTitle3;
  final subTitle4;

  final int index;
  final bool selectionMode;
  final Function setSelectionMode;
  final Function incrementItem;
  final Function decrementItem;
  final Function selectedItemsNumber;
  final Function isSelected;

  @override
  _MyChoosingGridViewCardState createState() => _MyChoosingGridViewCardState();
}

class _MyChoosingGridViewCardState extends State<MyChoosingGridViewCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!widget.selectionMode) {
          widget.setSelectionMode(true);
          widget.incrementItem(widget.index);
        }
      },
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0,
            ),
          ],
          color: widget.isSelected(widget.index)
              ? Colors.blue.withOpacity(0.5)
              : Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.selectionMode)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => widget.incrementItem(widget.index),
                        icon: Icon(Icons.add)),
                    Text(
                      '${widget.selectedItemsNumber(widget.index)}',
                      style: TextStyle(color: Colors.black),
                    ),
                    IconButton(
                        onPressed: !widget.isSelected(widget.index)
                            ? null
                            : () => widget.decrementItem(widget.index),
                        icon: Icon(Icons.remove)),
                  ],
                ),
              Image(image: AssetImage(widget.image)),
              SizedBox(
                height: 5,
              ),
              Text(widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  )),
              Text(widget.subTitle1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  )),
              Text(widget.subTitle2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  )),
              Text(widget.subTitle3,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  )),
              Text(widget.subTitle4,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
