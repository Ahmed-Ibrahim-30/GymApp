import 'package:flutter/material.dart';
import 'package:gym_project/models/set.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/services/set-webservice.dart';
import 'package:gym_project/viewmodels/set-view-model.dart';

enum LoadingStatus {
  Completed,
  Searching,
  Empty,
}

class SetListViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.Empty;

  // ignore: deprecated_member_use
  List<SetViewModel> sets = List<SetViewModel>();
  SetViewModel set;
  int lastPage;

  Future<void> fetchListSets(int page, String searchText) async {
    print('currently here!');
    Tuple<int, List<Set>> result =
        await SetWebService().getSets(page, searchText);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();
    this.sets = result.item2.map((set) => SetViewModel(set: set)).toList();
    lastPage = result.item1;
    if (this.sets.isEmpty) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }

  Future<void> fetchSetDetails(int setId) async {
    print('id');
    print(setId);
    print('currently here!');
    Set _set = await SetWebService().getSetDetails(setId);
    loadingStatus = LoadingStatus.Searching;
    // not notifying listeners as it causes an error
    // since fetchSetDetails is called in initState, so the value of loadingStatus is set before widgets depending on that value are built
    // notifyListeners();
    Set setModel = await SetWebService().getSetDetails(setId);
    this.set = SetViewModel(set: setModel);

    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  Future<void> postSet(Set set) async {
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();
    Set setModel = await SetWebService().postSet(set);

    // adding the set to the sets list in the provider
    sets.add(SetViewModel(set: setModel));
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  Future<void> putSet(Set set) async {
    // loadingStatus = LoadingStatus.Searching;
    // notifyListeners();
    // Set setModel =
    await SetWebService().putSet(set);

    editSetInProvider(set);
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  void editSetInProvider(Set set) {
    int updatedSetIndex = sets.indexWhere((s) => s.id == set.id);
    sets.removeAt(updatedSetIndex);
    sets.insert(updatedSetIndex, SetViewModel(set: set));
  }

  Future<void> deleteSet(Set set) async {
    await SetWebService().deleteSet(set);
    _removeSetFromProvider(set);
    notifyListeners();
  }

  void _removeSetFromProvider(Set set) {
    sets.removeWhere((s) => s.id == set.id);
  }
}
