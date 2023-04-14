import 'package:flutter/cupertino.dart';

class AppStateNotifier extends ChangeNotifier {
  bool isNormalMode = true;

  void setTheme({
    bool? isNormalMode,
  }) {
    if(isNormalMode != null) {
      this.isNormalMode = isNormalMode;
      notifyListeners();
    }
  }
}
