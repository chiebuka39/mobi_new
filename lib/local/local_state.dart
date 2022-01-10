import 'package:hive/hive.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/models/secondary_state.dart';
import 'package:mobi/models/user.dart';

abstract class ABSAppStateLocalStorage {

  void initBox();

  void saveSecondaryState(SecondaryState secondaryState);

  void saveUserState(User user);

  SecondaryState getSecondaryState();

  User getUser();
}

class AppStateBoxStorage extends ABSAppStateLocalStorage{
  Box box;
  @override
  void initBox() {
    box = Hive.box(MyStrings.state);
  }

  AppStateBoxStorage(){
    initBox();
  }

  @override
  void saveUserState(User user) {
    box.put('user', user);
  }

  @override
  void saveSecondaryState(SecondaryState secondaryState) {
    box.put('state', secondaryState);
  }

  @override
  User getUser() {

    return box.get('user', defaultValue: null);
  }

  @override
  SecondaryState getSecondaryState() {

    return box.get('state', defaultValue: SecondaryState(false));
  }

}