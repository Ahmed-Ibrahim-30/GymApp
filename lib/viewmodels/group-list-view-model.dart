import 'package:flutter/cupertino.dart';
import 'package:gym_project/helper/constants.dart';
import 'package:gym_project/models/group.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/services/group-webservices.dart';
import 'package:gym_project/viewmodels/groups-view-model.dart';

class GroupListViewModel with ChangeNotifier {
  List<GroupViewModel> groups = [];
  GroupViewModel group;
  LoadingStatus loadingStatus = LoadingStatus.Completed;
  int lastPage;
  List<GroupViewModel> weekGroups = [];

  Future<void> fetchGroups(int page, String searchText) async {
    loadingStatus = LoadingStatus.Searching;
    Tuple<int, List<Group>> result =
        await GroupWebService().getGroups(page, searchText);
    List<GroupViewModel> groupVMs =
        result.item2.map((group) => GroupViewModel(group: group)).toList();
    groups = groupVMs;
    lastPage = result.item1;
    if (groups.isEmpty) {
      loadingStatus = LoadingStatus.Empty;
    }
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  Future<void> fetchWeekGroups() async {
    loadingStatus = LoadingStatus.Searching;
    List<Group> result = await GroupWebService().fetchWeekGroups();
    weekGroups = result.map((group) => GroupViewModel(group: group)).toList();
    if (weekGroups.isEmpty) {
      loadingStatus = LoadingStatus.Empty;
    }
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  Future<void> fetchGroupDetails(int groupId) async {
    loadingStatus = LoadingStatus.Searching;
    Group groupModel = await GroupWebService().getGroupDetails(groupId);
    group = GroupViewModel(group: groupModel);
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  Future<void> postGroup(Group group, List<dynamic> orderedObjects) async {
    loadingStatus = LoadingStatus.Searching;
    Group groupModel = await GroupWebService().postGroup(group, orderedObjects);
    groups.add(GroupViewModel(group: groupModel));
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  Future<void> putGroup(Group group, List<dynamic> orderedObjects) async {
    loadingStatus = LoadingStatus.Searching;
    Group groupModel = await GroupWebService().putGroup(group, orderedObjects);
    int updatedGroupIndex = groups.indexWhere((g) => g.id == group.id);
    groups.removeAt(updatedGroupIndex);
    groups.insert(updatedGroupIndex, GroupViewModel(group: group));
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  Future<void> assignGroups(
      List<Map<String, dynamic>> groups, int memberId) async {
    loadingStatus = LoadingStatus.Searching;
    bool status = await GroupWebService().assignGroups(groups, memberId);
    if (status == false) {
      loadingStatus = LoadingStatus.Empty;
    }
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  Future<void> deleteGroup(Group group) async {
    await GroupWebService().deleteGroup(group);
    _removeGroupFromProvider(group);
    notifyListeners();
  }

  void _removeGroupFromProvider(Group group) {
    groups.removeWhere((g) => g.id == group.id);
  }
}
