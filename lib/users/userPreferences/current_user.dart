
import 'package:etradinggradproj/users/userPreferences/user_preferences.dart';
import 'package:get/get.dart';

import '../model/user.dart';

class CurrentUser extends GetxController
{
  Rx<User> _currentUser = User(0,'','','').obs;

  User get user => _currentUser.value;

  getUserInfo() async
  {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}