import 'package:aplinkos_ministerija/data/api/data.dart';
import 'package:aplinkos_ministerija/model/category.dart';

class Repository {
  final DataApi _dataApi;

  const Repository(this._dataApi);

  Future<List<Category>> getAllData() => _dataApi.readJsonData();
}
