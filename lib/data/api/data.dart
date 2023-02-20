import 'dart:convert';

import 'package:aplinkos_ministerija/data/network/constants/database_consts.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/model/final_stage_models/final_list.dart';
import 'package:aplinkos_ministerija/model/second_stage_models/second_category.dart';
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

  Future<List<SecondCategory>> getSecondStageData() async {
    final String response =
        await rootBundle.loadString('assets/db/second_stage_questions.json');
    final data = await jsonDecode(response);
    final List<dynamic> listOfData = data[DatabaseConsts.DB_COLLECTION_SECOND];
    final List<SecondCategory> returnable =
        listOfData.map((fromMap) => SecondCategory.fromMap(fromMap)).toList();
    return returnable;
  }

  Future<List<FinalList>> getFinalListData() async {
    final String response =
        await rootBundle.loadString('assets/db/third_stage.json');
    final data = await jsonDecode(response);
    final List<dynamic> listOfData = data[DatabaseConsts.DB_COLLECTION_FINAL];
    final List<FinalList> returnable =
        listOfData.map((fromMap) => FinalList.fromMap(fromMap)).toList();
    return returnable;
  }
}
