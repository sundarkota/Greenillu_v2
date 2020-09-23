import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}


const keyAuthCheck = "LOG_USER_AUTHCHECK";

Future<bool> authCheck() async {
  SharedPref sharedPref = SharedPref();
  String val = await sharedPref.read(keyAuthCheck);
  return val != null ? true : false;
}

addAuthToken(String v) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyAuthCheck, v);
}

Future<String> readAuthToken() async {
  SharedPref sharedPref = SharedPref();
  dynamic val = await sharedPref.read(keyAuthCheck);
  return val.toString();
}

authLogout(BuildContext context) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyAuthCheck, null);
  destroyUserId(context);
 // Cart.getInstance.clear();
  //navigatorPush(context, routeName: "/home", forgetAll: true);
}

const keyUserId = "LOG_USERID";

storeUserId(String v) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyUserId, v);
}

Future<String> readUserId() async {
  SharedPref sharedPref = SharedPref();
  String val = await sharedPref.read(keyUserId);
  return val;
}

destroyUserId(BuildContext context) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyUserId, null);
}
