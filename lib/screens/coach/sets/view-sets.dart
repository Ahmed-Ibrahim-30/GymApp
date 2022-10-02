import 'package:flutter/material.dart';
import 'package:gym_project/models/set.dart';
import 'package:gym_project/screens/coach/sets/edit-set.dart';
import 'package:gym_project/screens/common/view-set-details-screen.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/viewmodels/set-list-view-model.dart';
import 'package:gym_project/viewmodels/set-view-model.dart';
import 'package:gym_project/widget/back-button.dart';
import 'package:gym_project/widget/global.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class ViewSetsScreen extends StatefulWidget {
  static String viewingRouteName = 'sets/index';
  static String choosingRouteName = 'sets/choose';
  bool isSelectionTime = false;
  ViewSetsScreen(this.isSelectionTime);
  @override
  _ViewSetsScreenState createState() => _ViewSetsScreenState();
}

class _ViewSetsScreenState extends State<ViewSetsScreen> {
  List<SetViewModel> _sets = [];
  bool _selectionMode = false;
  Map<int, Map<String, Object>> oldSelectedSets = {};
  bool _argumentsLoaded = false;
  int lastPage;
  @override
  void initState() {
    super.initState();
    if (widget.isSelectionTime == true) {
      _selectionMode = true;
      getSetsList(0, '');
    } else {
      getSetsList(1, '');
    }
  }

  void loadArguments() {
    oldSelectedSets = ModalRoute.of(context).settings.arguments;
    if (oldSelectedSets != null && oldSelectedSets.isNotEmpty) {
      setState(() {
        oldSelectedSets.forEach((int setId, Map<String, Object> setData) {
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

  getSetsList(int page, String searchText) {
    Provider.of<SetListViewModel>(context, listen: false)
        .fetchListSets(page, searchText)
        .then((value) {
      setState(() {
        var setListViewModel =
            Provider.of<SetListViewModel>(context, listen: false);
        _sets = setListViewModel.sets;
        lastPage = setListViewModel.lastPage;
        done = true;
      });
    }).catchError((err) {
      setState(() {
        error = true;
      });
      print('$err');
    });
  }

  List<Map<int, int>> _numberOfSelectedInstances = [];

  TextEditingController searchText = TextEditingController();

  void setSelectionMode(bool value) {
    setState(() {
      _selectionMode = value;
    });
  }

  void incrementItem(int setId) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(setId));
      if (i != -1) {
        _numberOfSelectedInstances[i][setId] =
            _numberOfSelectedInstances[i][setId] + 1;
      } else {
        _numberOfSelectedInstances.add({setId: 1});
      }
    });
    print(_numberOfSelectedInstances);
  }

  void decrementItem(int setId) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(setId));
      if (i == -1) return;
      if (_numberOfSelectedInstances[i][setId] == 1) {
        _numberOfSelectedInstances.removeWhere((map) => map.containsKey(setId));
      } else {
        _numberOfSelectedInstances[i][setId] =
            _numberOfSelectedInstances[i][setId] - 1;
      }
    });
    print(_numberOfSelectedInstances);
  }

  int selectedItemsNumber(setId) {
    if (!_numberOfSelectedInstances.any((map) => map.containsKey(setId))) {
      return 0;
    } else {
      return _numberOfSelectedInstances
          .firstWhere((map) => map.containsKey(setId))[setId];
    }
  }

  bool isSelected(int setId) {
    return _numberOfSelectedInstances.any((map) => map.containsKey(setId));
  }

  Map<int, Map<String, Object>> getFinalSelectedItems() {
    Map<int, Map<String, Object>> finalSelectedItems = {};
    for (Map<int, int> selectedItem in _numberOfSelectedInstances) {
      selectedItem.forEach((setId, quantity) {
        finalSelectedItems[setId] = {
          'set': _sets.firstWhere((SetViewModel set) => set.id == setId),
          'quantity': quantity
        };
      });
    }
    return finalSelectedItems;
  }

  int number = 0;
  bool done = false;
  bool error = false;
  double _currentPosition = 0;
  @override
  Widget build(BuildContext context) {
    const decorator = DotsDecorator(
      activeColor: Colors.amber,
    );
    return SafeArea(
      child: Container(
        color: Colors.black,
        padding: EdgeInsetsDirectional.all(10),
        child: Stack(
          children: [
            Material(
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CustomBackButton(),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            'Sets',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextFormField(
                          controller: searchText,
                          cursorColor: Theme.of(context).primaryColor,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'Search..',
                            suffixIcon: Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    int page = widget.isSelectionTime ? 0 : 1;
                                    _sets = [];
                                    done = false;
                                    error = false;
                                    _currentPosition = 0;
                                    getSetsList(page, searchText.text);
                                  });
                                },
                                child: Icon(Icons.search),
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_selectionMode)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Selected ${_numberOfSelectedInstances.length} of ${_sets.length}',
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
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    if (widget.isSelectionTime)
                      error
                          ? CustomErrorWidget()
                          : (done && _sets.isEmpty)
                              ? EmptyListError('No sets found')
                              : _sets.isEmpty
                                  ? Progress()
                                  : loadSetsList(),
                    if (!widget.isSelectionTime)
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: MediaQuery.of(context).size.height),
                        child: PageView.builder(
                            controller: PageController(),
                            onPageChanged: (index) {
                              setState(() {
                                _sets = [];
                                done = false;
                                error = false;
                                _currentPosition = index.toDouble();
                              });
                              getSetsList(index + 1, '');
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: lastPage,
                            itemBuilder: (ctx, index) {
                              if (error) {
                                return CustomErrorWidget();
                              } else if (done && _sets.isEmpty) {
                                return EmptyListError('No sets found');
                              } else if (_sets.isEmpty) {
                                return Progress();
                              } else {
                                return loadSetsList();
                              }
                            }),
                      ),
                    if (done && !widget.isSelectionTime)
                      DotsIndicator(
                        dotsCount: lastPage,
                        position: _currentPosition,
                        axis: Axis.horizontal,
                        decorator: decorator,
                        onTap: (pos) {
                          setState(() => _currentPosition = pos);
                        },
                      ),
                  ],
                ),
              ),
            ),
            if (_selectionMode)
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    child: Text('Submit',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        )),
                    onPressed: () {
                      Navigator.pop(context, getFinalSelectedItems());
                    }),
              ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView loadSetsList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _sets.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return SetsListTile(
              _sets[index],
              index,
              _selectionMode,
              setSelectionMode,
              incrementItem,
              decrementItem,
              selectedItemsNumber,
              isSelected,
              'https://images.app.goo.gl/oSJrrxJh1LGFiope9',
              widget.isSelectionTime);
        });
  }
}

class SetsListTile extends StatefulWidget {
  final SetViewModel setVM;
  final int index;
  final bool selectionMode;
  final Function setSelectionMode;
  final Function incrementItem;
  final Function decrementItem;
  final Function selectedItemsNumber;
  final Function isSelected;
  final String iconData;
  final bool selectionTime;

  SetsListTile(
      this.setVM,
      this.index,
      this.selectionMode,
      this.setSelectionMode,
      this.incrementItem,
      this.decrementItem,
      this.selectedItemsNumber,
      this.isSelected,
      this.iconData,
      this.selectionTime);
  @override
  _SetsListTileState createState() => _SetsListTileState();
}

class _SetsListTileState extends State<SetsListTile> {
  int number = 0;
  String username = Global.username;
  Future<void> deleteSet(Set set) async {
    try {
      await Provider.of<SetListViewModel>(context, listen: false)
          .deleteSet(set);
    } catch (error) {
      showErrorMessage(context, 'Could not delete set');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.isSelected(widget.setVM.id)
              ? Colors.white24
              : Colors.transparent,
        ),
        child: ListTile(
          onTap: () {
            if (!widget.selectionTime) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (_) => SetListViewModel(),
                              ),
                            ],
                            child: SetDetailsScreen(widget.setVM.id),
                          )));
            } else if (widget.selectionTime && !widget.selectionMode) {
              widget.setSelectionMode(true);
            }
          },
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 20,
            child:
                Icon(Icons.grid_view_outlined, color: Colors.black, size: 30),
          ),
          title: Text(
            widget.setVM.title,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Description',
                style: TextStyle(
                  color: Colors.amber,
                ),
              ),
              Text(
                widget.setVM.description,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              if (widget.selectionTime && widget.selectionMode)
                TextButton(
                  child: Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                      create: (_) => SetListViewModel(),
                                    ),
                                  ],
                                  child: SetDetailsScreen(widget.setVM.id),
                                )));
                  },
                ),
            ],
          ),
          trailing: !widget.selectionTime && username == widget.setVM.coachName
          ?Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditSetForm(widget.setVM),
                            ),
                          );
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      deleteSet(widget.setVM.set);
                    },
                    child: Text('Delete',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )),
                  ),
                ],
              )
              : !widget.selectionMode
                  ? null
                  : Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Icon(
                              Icons.add,
                              size: 15,
                              color: Colors.white,
                            ),
                            onTap: () => widget.incrementItem(widget.setVM.id),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${widget.selectedItemsNumber(widget.setVM.id)}",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Icon(
                              Icons.remove,
                              size: 15,
                              color: Colors.white,
                            ),
                            onTap: () => widget.isSelected(widget.setVM.id)
                                ? widget.decrementItem(widget.setVM.id)
                                : null,
                          ),
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
        ),
      ),
    );
  }
}
