import 'package:flutter/material.dart';

class MyChoosingScreen extends StatefulWidget {
  const MyChoosingScreen({Key key}) : super(key: key);

  @override
  _MyChoosingScreenState createState() => _MyChoosingScreenState();
}

class _MyChoosingScreenState extends State<MyChoosingScreen> {
  final List<dynamic> users = [
    {
      'name': 'Osama',
      'branch': 'Branch 1',
      "photo":
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
    },
    {
      'name': 'Abdo',
      'branch': 'Branch 2',
      "photo":
          'https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
    }
  ];

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

  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          if (_selectionMode)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Selected ${_numberOfSelectedInstances.length} of ${users.length}',
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
          ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (ctx, index) {
                return MyChoosingListTile(
                  'Main Title',
                  ['Subtitle 1', 'Subtitle 2'],
                  index,
                  _selectionMode,
                  setSelectionMode,
                  incrementItem,
                  decrementItem,
                  selectedItemsNumber,
                  isSelected,
                  'https://images.app.goo.gl/oSJrrxJh1LGFiope9',
                );
              }),
        ],
      ),
    );
  }
}

class MyChoosingListTile extends StatefulWidget {
  final String title;
  final List<String> subtitles;
  final int index;
  final bool selectionMode;
  final Function setSelectionMode;
  final Function incrementItem;
  final Function decrementItem;
  final Function selectedItemsNumber;
  final Function isSelected;
  final String iconData;

  MyChoosingListTile(
    this.title,
    this.subtitles,
    this.index,
    this.selectionMode,
    this.setSelectionMode,
    this.incrementItem,
    this.decrementItem,
    this.selectedItemsNumber,
    this.isSelected,
    this.iconData,
  );
  @override
  _MyChoosingListTileState createState() => _MyChoosingListTileState();
}

class _MyChoosingListTileState extends State<MyChoosingListTile> {
  int number = 0;
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
          color: widget.isSelected(widget.index)
              ? Colors.blue.withOpacity(0.5)
              : Colors.transparent,
        ),
        child: ListTile(
          onLongPress: () {
            widget.setSelectionMode(true);
          },
          onTap: () {},
          leading: CircleAvatar(
            radius: 20,
            // child: Image.network(widget.iconData),
            child: FlutterLogo(),
          ),
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (String subtitle in widget.subtitles)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
            ],
          ),
          trailing: !widget.selectionMode
              ? null
              : Column(
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.add,
                        size: 15,
                        color: Colors.white,
                      ),
                      onTap: () => widget.incrementItem(widget.index),
                    ),
                    Text(
                      "${widget.selectedItemsNumber(widget.index)}",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.remove,
                        size: 15,
                        color: Colors.white,
                      ),
                      onTap: () => widget.isSelected(widget.index)
                          ? widget.decrementItem(widget.index)
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
