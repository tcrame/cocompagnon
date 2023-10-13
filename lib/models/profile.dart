import 'package:cocompagnon/models/treasure/cloth.dart';
import 'package:cocompagnon/models/treasure/consumeable.dart';

import '../utils/shared-preferences-utils.dart';

class Profile {
  String name;
  String healthDice;
  String? magicModificator;
  String weaponsAndArmors;
  List<String> startEquipment;

  List<ProfilePath> paths;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Profile({required this.name, required this.healthDice, required this.magicModificator, required this.weaponsAndArmors, required this.startEquipment, required this.paths});
}

class ProfilePath {
  String name;
  List<ProfilePathCapacity> capacities;

  factory ProfilePath.fromJson(Map<String, dynamic> json) => _$ProfilePathFromJson(json);

  ProfilePath({required this.name, required this.capacities});
}

class ProfilePathCapacity {
  String name;
  String description;
  bool isMagic;
  int rank;
  bool isLimited;

  factory ProfilePathCapacity.fromJson(Map<String, dynamic> json) => _$ProfilePathCapacityFromJson(json);

  ProfilePathCapacity({required this.name, required this.description, required this.isMagic, required this.rank, required this.isLimited});
}


Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      name: json['name'] as String,
      healthDice: json['healthDice'] as String,
      magicModificator: json['magicModificator'] as String?,
      weaponsAndArmors: json['weaponsAndArmors'] as String,
      startEquipment: List<String>.from((json['startEquipment'] as Iterable).map<String>((dynamic e) => e.toString())),
      paths: List<ProfilePath>.from((json['paths'] as Iterable).map<ProfilePath>((dynamic e) => ProfilePath.fromJson(e))),
    );

ProfilePath _$ProfilePathFromJson(Map<String, dynamic> json) =>
    ProfilePath(name: json['name'] as String, capacities: List<ProfilePathCapacity>.from((json['capacities'] as Iterable).map<ProfilePathCapacity>((dynamic e) => ProfilePathCapacity.fromJson(e))));

ProfilePathCapacity _$ProfilePathCapacityFromJson(Map<String, dynamic> json) => ProfilePathCapacity(
      name: json['name'] as String,
      rank: json['rank'] as int,
      isMagic: json['isMagic'] as bool,
      isLimited: json['isLimited'] as bool,
      description: json['description'] as String,
    );
