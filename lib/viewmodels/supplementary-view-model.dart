import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/supplementary.dart';
import 'package:gym_project/services/supplementary-webservice.dart';

import '../all_data.dart';
import '../widget/global.dart';

class SupplementaryViewModel extends ChangeNotifier {
  Supplementary singleSupplementary = Supplementary();

  List<Supplementary> branchSupplementariesList = [];

  int get id => supplementary.id;
  String get title => supplementary.title;
  String get description => supplementary.description;
  int get price => supplementary.price;
  String get picture => supplementary.picture;


  Future<void> getSupplementaryById(int id, String token) async {
    this.singleSupplementary =
        await SupplementaryWebService(token).getSupplementaryById(id);
    notifyListeners();
  }

  Future<void> getBranchSupplementaries(int branch_id, String token) async {
    branchSupplementariesList = await SupplementaryWebService(token)
        .getBranchSupplementaries(branch_id);
    notifyListeners();
  }

  Future<void> addSupplementary(String title, String description, int price,
      String picture, String token) async {
    await SupplementaryWebService(token)
        .addSupplementary(title, description, price, picture);
    notifyListeners();
  }

  Future<void> addSupplementaryToBranch(
      int branch_id, int id, int quantity, String token) async {
    await SupplementaryWebService(token)
        .addSupplementaryToBranch(branch_id, id, quantity);
    notifyListeners();
  }

  Future<void> editSupplementary(int id, String title, String description,
      int price, String picture, String token) async {
    await SupplementaryWebService(token)
        .editSupplementary(id, title, description, price, picture);
    notifyListeners();
  }

  Future<void> removeSupplementaryFromBranch(
      int branch_id, int id, String token) async {
    await SupplementaryWebService(token)
        .removeSupplementaryFromBranch(branch_id, id);
    notifyListeners();
  }

  Future<void> deleteSupplementary(int id, String token) async {
    await SupplementaryWebService(token).deleteSupplementary(id);
    notifyListeners();
  }

  List<Supplementary> get supplemetaries => supplementariesList;
  List<Supplementary> get branchSupplementaries => branchSupplementariesList;
  Supplementary get supplementary => singleSupplementary;
}
