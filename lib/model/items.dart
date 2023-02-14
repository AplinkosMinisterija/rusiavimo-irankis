// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aplinkos_ministerija/data/network/constants/database_consts.dart';
import 'package:equatable/equatable.dart';

class Items extends Equatable {
  final String? code;
  final String? itemName;
  final String? type;
  bool? isPressed;

  Items({
    required this.code,
    required this.itemName,
    required this.type,
    this.isPressed,
  });

  factory Items.fromMap(Map<String, dynamic> fromMap) {
    return Items(
      code: fromMap[DatabaseConsts.ITEMS_CODE],
      itemName: fromMap[DatabaseConsts.ITEMS_NAME],
      type: fromMap[DatabaseConsts.ITEMS_TYPE],
      isPressed: false,
    );
  }

  @override
  List<Object?> get props => [
        code,
        itemName,
        type,
        isPressed,
      ];
}
