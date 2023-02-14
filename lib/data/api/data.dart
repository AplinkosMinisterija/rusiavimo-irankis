import 'dart:convert';

import 'package:aplinkos_ministerija/data/network/constants/database_consts.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:flutter/services.dart';

class DataApi {
  DataApi();

  Future<List<Category>> readJsonData() async {
    final String response = await rootBundle.loadString('assets/db/data.json');
    final data = await jsonDecode(response);
    final List<dynamic> listOfData = data[DatabaseConsts.DB_COLLECTION];
    final List<Category> returnableData =
        listOfData.map((fromMap) => Category.fromMap(fromMap)).toList();
    return returnableData;
  }
}
