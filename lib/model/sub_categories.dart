// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aplinkos_ministerija/data/network/constants/database_consts.dart';
import 'package:aplinkos_ministerija/model/items.dart';
import 'package:equatable/equatable.dart';

class SubCategories extends Equatable {
  final String? name;
  final String? codeId;
  final List<Items>? items;
  bool? isPressed;

  SubCategories({
    required this.codeId,
    required this.items,
    required this.name,
    this.isPressed,
  });

  factory SubCategories.fromMap(Map<String, dynamic> fromMap) {
    return SubCategories(
      codeId: fromMap[DatabaseConsts.SUB_CODE_ID],
      items: (fromMap[DatabaseConsts.SUB_ITEMS] as List<dynamic>)
          .map((fromAnotherMap) => Items.fromMap(fromAnotherMap))
          .toList(),
      name: fromMap[DatabaseConsts.SUB_NAME],
      isPressed: false,
    );
  }

  @override
  List<Object?> get props => [
        name,
        codeId,
        items,
        isPressed,
      ];
}
