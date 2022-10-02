import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/screens/common/view-group-details-screen.dart';
import 'package:gym_project/viewmodels/group-list-view-model.dart';
import 'package:gym_project/viewmodels/groups-view-model.dart';
import 'package:gym_project/widget/back-button.dart';
import 'package:gym_project/widget/global.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';

import 'edit-group.dart';

class ViewGroupsScreen extends StatefulWidget {
  bool isSelectionTime = false;
  static String viewingRouteName = '/groups/view';
  static String choosingRouteName = '/groups/select';

  ViewGroupsScreen(this.isSelectionTime);
  @override
  _ViewGroupsScreenState createState() => _ViewGroupsScreenState();
}

class _ViewGroupsScreenState extends State<ViewGroupsScreen> {
  List<GroupViewModel> groups = [];

  bool _selectionMode = false;
  @override
  void initState() {
    super.initState();
    if (widget.isSelectionTime == true) {
      _selectionMode = true;
      getGroupsList(0, '');
    } else {
      getGroupsList(1, '');
    }
  }

  var groupListViewModel;
  bool error = false;
  bool done = false;
  int lastPage = 1;
  double currentPosition = 0;

  getGroupsList(int page, String searchText) {
    Provider.of<GroupListViewModel>(context, listen: false)
        .fetchGroups(page, searchText)
        .then((value) {
      setState(() {
        groupListViewModel =
            Provider.of<GroupListViewModel>(context, listen: false);
        groups = groupListViewModel.groups;
        lastPage = groupListViewModel.lastPage;
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
  // Map<int, Object> finalSelectedItems = {};
  // Map<int, Map<String, Object>> finalSelectedItems = {};
  List<GroupViewModel> finalSelectedItems = [];
  TextEditingController searchText = TextEditingController();

  void setSelectionMode(bool value) {
    setState(() {
      _selectionMode = value;
    });
  }

  void incrementItem(int groupId) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(groupId));
      if (i != -1) {
        _numberOfSelectedInstances[i][groupId] =
            _numberOfSelectedInstances[i][groupId] + 1;
      } else {
        _numberOfSelectedInstances.add({groupId: 1});
      }
    });
    print(_numberOfSelectedInstances);
  }

  void decrementItem(int groupId) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(groupId));
      if (i == -1) return;
      if (_numberOfSelectedInstances[i][groupId] == 1) {
        _numberOfSelectedInstances
            .removeWhere((map) => map.containsKey(groupId));
      } else {
        _numberOfSelectedInstances[i][groupId] =
            _numberOfSelectedInstances[i][groupId] - 1;
      }
    });
    print(_numberOfSelectedInstances);
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

  void getFinalSelectedItems() {
    int index = 0;
    GroupViewModel selectedGroup;
    for (Map<int, int> selectedItem in _numberOfSelectedInstances) {
      selectedItem.forEach((groupId, quantity) {
        print(selectedItem);
        // for (int i = 0; i < quantity; i++) {
        //   finalSelectedItems[index] = {
        //     'group': groups
        //         .firstWhere((GroupViewModel group) => group.id == groupId),
        //     'date': '',
        //   };
        //   index++;
        // }
        selectedItem.forEach((key, value) {
          selectedGroup =
              groups.firstWhere((GroupViewModel group) => group.id == groupId);
          selectedGroup.date = DateTime.now();
          for (int i = 0; i < value; i++) {
            finalSelectedItems.add(selectedGroup);
          }
        });
      });
    }
    // print('items are $finalSelectedItems');
  }

  int number = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                            'Groups',
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
                                    groups = [];
                                    done = false;
                                    error = false;
                                    currentPosition = 0;
                                    getGroupsList(page, searchText.text);
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
                                'Selected ${_numberOfSelectedInstances.length} of ${groups.length}',
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
                          : done && groups.isEmpty
                              ? EmptyListError('No groups found')
                              : groups.isEmpty
                                  ? Progress()
                                  : loadGroupsList(),
                    if (!widget.isSelectionTime)
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: MediaQuery.of(context).size.height),
                        child: PageView.builder(
                            controller: PageController(),
                            onPageChanged: (index) {
                              setState(() {
                                groups = [];
                                done = false;
                                error = false;
                                currentPosition = index.toDouble();
                              });
                              getGroupsList(index + 1, '');
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: lastPage,
                            itemBuilder: (ctx, index) {
                              if (error) {
                                return CustomErrorWidget();
                              } else if (done && groups.isEmpty) {
                                return EmptyListError('No sets found');
                              } else if (groups.isEmpty) {
                                return Progress();
                              } else {
                                return loadGroupsList();
                              }
                            }),
                      ),
                    if (done && !widget.isSelectionTime)
                      DotsIndicator(
                        dotsCount: lastPage,
                        position: currentPosition,
                        axis: Axis.horizontal,
                        decorator: decorator,
                        onTap: (pos) {
                          setState(() => currentPosition = pos);
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
                    child: Text(
                      'Submit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        )),
                    onPressed: () {
                      getFinalSelectedItems();
                      Navigator.pop(context, finalSelectedItems);
                    }),
              ),
          ],
        ),
      ),
    );
  }

  ListView loadGroupsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: groups.length,
      itemBuilder: (ctx, index) {
        return GroupsListTile(
          groups[index],
          index,
          _selectionMode,
          setSelectionMode,
          incrementItem,
          decrementItem,
          selectedItemsNumber,
          isSelected,
          'https://images.app.goo.gl/oSJrrxJh1LGFiope9',
          widget.isSelectionTime,
        );
      },
    );
  }
}

class GroupsListTile extends StatefulWidget {
  final GroupViewModel groupVM;
  final int index;
  final bool selectionMode;
  final Function setSelectionMode;
  final Function incrementItem;
  final Function decrementItem;
  final Function selectedItemsNumber;
  final Function isSelected;
  final String iconData;
  final bool selectionTime;
  GroupsListTile(
    this.groupVM,
    this.index,
    this.selectionMode,
    this.setSelectionMode,
    this.incrementItem,
    this.decrementItem,
    this.selectedItemsNumber,
    this.isSelected,
    this.iconData,
    this.selectionTime,
  );
  @override
  _GroupsListTileState createState() => _GroupsListTileState();
}

class _GroupsListTileState extends State<GroupsListTile> {
  int number = 0;
  String username = Global.username;
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
          color: widget.isSelected(widget.groupVM.id)
              ? Colors.white24
              : Colors.transparent,
        ),
        child: ListTile(
          onTap: () {
            if (!widget.selectionTime) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetailsScreen(widget.groupVM.id),
                ),
              );
            } else if (widget.selectionTime && !widget.selectionMode) {
              widget.setSelectionMode(true);
            }
          },
          leading: CircleAvatar(
            radius: 20,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assets/images/branch.png',
                  fit: BoxFit.cover,
                )),
            // child: Image.network(widget.iconData),
          ),
          title: Text(
            widget.groupVM.title,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.groupVM.description,
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
                          builder: (context) =>
                              GroupDetailsScreen(widget.groupVM.id),
                        ));
                  },
                ),
            ],
          ),
          trailing: !widget.selectionTime &&
                  username == widget.groupVM.coachName
                  ?Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditGroupForm(widget.groupVM)));
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
                      Provider.of<GroupListViewModel>(context,
                                  listen: false)
                              .deleteGroup(widget.groupVM.group);
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
                        GestureDetector(
                          child: Icon(
                            Icons.add,
                            size: 15,
                            color: Colors.white,
                          ),
                          onTap: () => widget.incrementItem(widget.groupVM.id),
                        ),
                        Text(
                          "${widget.selectedItemsNumber(widget.groupVM.id)}",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.remove,
                            size: 15,
                            color: Colors.white,
                          ),
                          onTap: () => widget.isSelected(widget.groupVM.id)
                              ? widget.decrementItem(widget.groupVM.id)
                              : null,
                        )
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
        ),
      ),
    );
  }
}
