import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:greenillu/utils/sharedpref.dart';
import 'package:greenillu/appconfig/config.dart';
import 'package:greenillu/model/cart.dart';
import 'package:greenillu/model/any_image.dart';
import 'package:greenillu/model/product.dart';
import 'package:greenillu/scoped_model/cart_scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:greenillu/utils/format.dart';

/*Future<int> getCartCount() async{

  CartScopedModel cartModel = CartScopedModel();
  cartModel.parseCartsFromResponse(1);
  var cnt = await cartModel.getCartsCount();
print("count ${cnt}");
  return parseInt(cnt.toString());
}*/

int getCartCount() {
  CartScopedModel cartModel = CartScopedModel();
  cartModel.parseCartsFromResponse(1);
  var cnt = cartModel.cartcount;
  print("count ${cnt}");
  return parseInt(cnt.toString());
}

void clearShoppingCart() {
  CartScopedModel cartModel = CartScopedModel();
  cartModel.clearCart();
}

void printApp(arg){
  print(arg);
}

Future<http.Response> getApi(url) async{
  printApp("===== Get Api url ${url}");
  var token = await readAuthToken();//prefs.getString('token');
  var response = await http.get(url,
    headers: {
      "Authorization": 'Bearer ${token}',
    },
  ).catchError(
        (error) {
      return false;
    },
  );
  printApp("===== Get Api resp ${response.body.toString()}");
  if(response.statusCode == 200){
    return response;
  } else {
    return response;
  }

}

Future<http.Response> postApi(url, body) async{
  printApp("===== Get Api url ${url}");
  var token = await readAuthToken();//prefs.getString('token');
  var response = await http.post(url,
    headers: {
      "Authorization": 'Bearer ${token}',
    },
  ).catchError(
        (error) {
      return false;
    },
  );
  printApp("===== Post Api resp ${response.body.toString()}");
  if(response.statusCode == 200){
    return response;
  } else {
    return response;
  }

}

void loadCartTotemp() async {
  CartScopedModel cartModel = CartScopedModel();
  List<Product> cartApidata = await cartModel.getPrdCartDataFromApi();
  List<Product> cartdata = await cartModel.getCart();

  printApp("Cart items load from global function");

}


AnyImage dummyImage(){
     return  new AnyImage(
      imageURL: "",
      id: 1234556,
      title: "dummy",
      alt: "dummy",
    );
}

Widget placeOrder() {
  return  Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("Payble amount"),
        Container(
          width: 2.0,
          height: 46.0,
        ),
        Text("Place Order")
      ],
    );

  /*
  return BottomNavigationBar(
    //currentIndex: 0,
    //onTap: "", //_selectTab,
    items: [
      BottomNavigationBarItem(
         title: Text("Payble amount"), icon: Icon(Icons.shop),
      ),
      //BottomNavigationBarItem(
      //  icon: Icon(Icons.message), title: Text("Message"),
      //),
      BottomNavigationBarItem(
        title: Text("Place order"), icon: Icon(Icons.payment),
      ),
    ],
      type: BottomNavigationBarType.fixed
  );
  */

}