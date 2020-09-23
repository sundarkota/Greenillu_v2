import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:greenillu/routes/Routes.dart';
import 'package:greenillu/products/product_list.dart';
import 'package:greenillu/cart/cart_list.dart';
import 'package:greenillu/utils/sharedpref.dart';
import 'package:greenillu/utils/functions.dart';
import 'login.dart';

Future<void> main()  async {

  WidgetsFlutterBinding.ensureInitialized();
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  bool login = (await authCheck());//prefs.getString("email");

  if(login) {
    (await loadCartTotemp());
  }

  runApp(
      new MaterialApp(
        title: 'Green illu',
        theme: new ThemeData(
            primarySwatch: Colors.indigo
        ),
        home: login ? ProductsListPage() : LoginPage(),
        routes:  {
          Routes.products: (context) => ProductsListPage(),
          Routes.login: (context) => LoginPage(),
          Routes.cart: (context) => CartListPage()
        },
      )
  );
}
