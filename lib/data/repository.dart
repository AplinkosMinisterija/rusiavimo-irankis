import 'package:aplinkos_ministerija/data/api/data.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/model/final_stage_models/final_list.dart';
import 'package:aplinkos_ministerija/model/second_stage_models/second_category.dart';

class Repository {
  final DataApi _dataApi;

  const Repository(this._dataApi);

  Future<List<Category>> getAllData() => _dataApi.readJsonData();
  Future<List<SecondCategory>> getSecondStageData() =>
      _dataApi.getSecondStageData();
  Future<List<FinalList>> getFinalListData() => _dataApi.getFinalListData();
}
