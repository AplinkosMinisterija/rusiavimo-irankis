// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:aplinkos_ministerija/data/network/constants/database_consts.dart';
import 'package:aplinkos_ministerija/model/sub_categories.dart';

class Category extends Equatable {
  final String? categoryName;
  final String? categoryId;
  final List<SubCategories>? subCategories;
  bool? isPressed;

  Category({
    required this.categoryName,
    required this.categoryId,
    required this.subCategories,
    this.isPressed,
  });

  factory Category.fromMap(Map<String, dynamic> fromMap) {
    return Category(
      categoryName: fromMap[DatabaseConsts.CATEGORY_NAME],
      categoryId: fromMap[DatabaseConsts.CATEGORY_ID],
      subCategories:
          (fromMap[DatabaseConsts.CATEGORY_SUB_CATEGORY] as List<dynamic>)
              .map((toAnotherMap) => SubCategories.fromMap(toAnotherMap))
              .toList(),
      isPressed: false,
    );
  }

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        subCategories,
        isPressed,
      ];
}
