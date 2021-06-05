import 'package:localstorage/localstorage.dart';

class LocalStorageHelper {
  static final LocalStorageHelper _singleton = LocalStorageHelper._internal();
  factory LocalStorageHelper() {
    return _singleton;
  }

  LocalStorageHelper._internal();
  static LocalStorage _myLocalStorageInstance;

  LocalStorage getInstance(){
    if (_myLocalStorageInstance == null) {
      _myLocalStorageInstance = new LocalStorage('RemembrallStorage');
    }
    return _myLocalStorageInstance;
  }
}