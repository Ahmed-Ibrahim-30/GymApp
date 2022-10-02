import '../models/admin-models/equipments/equipment-model.dart';

class EquipmentViewModel {
  Equipment equipment;

  EquipmentViewModel({Equipment e}) : equipment = e;

  int get id {
    return equipment.id;
  }

  String get name {
    return equipment.name;
  }

  String get description {
    return equipment.description;
  }

  String get picture {
    return equipment.picture;
  }
}
