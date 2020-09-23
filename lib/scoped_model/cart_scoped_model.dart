import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:greenillu/model/any_image.dart';
import 'package:greenillu/model/category.dart';

import 'package:greenillu/model/product.dart';
import 'package:greenillu/model/cart.dart';
import 'package:greenillu/appconfig/config.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:greenillu/utils/sharedpref.dart';
import 'package:greenillu/utils/format.dart';
import 'package:greenillu/utils/functions.dart';
/*
class CartScopedModel {
  String _keyCart = "APP_CART_SESSION";

  CartScopedModel._privateConstructor();
  static final CartScopedModel getInstance = CartScopedModel._privateConstructor();

  Future<List<Product>> getCart() async {
    List<Product> cartLineItems = [];
    SharedPref sharedPref = SharedPref();
    String currentCartArrJSON = (await sharedPref.read(_keyCart) as String);
    if (currentCartArrJSON == null) {
      cartLineItems = List<Product>();
    } else {
      cartLineItems = (jsonDecode(currentCartArrJSON) as List<dynamic>)
          .map((i) => Product.fromJson(i))
          .toList();
    }
    return cartLineItems;
  }

  void addToCart({Product cartLineItem}) async {
    List<Product> cartLineItems = await getCart();

    if (cartLineItem.variationId != null) {
      if (cartLineItems.firstWhere(
              (i) => (i.productId == cartLineItem.productId &&
              i.variationId == cartLineItem.variationId),
          orElse: () => null) !=
          null) {
        return;
      }
    } else {
      var firstCartItem = cartLineItems.firstWhere(
              (i) => i.productId == cartLineItem.productId,
          orElse: () => null);
      if (firstCartItem != null) {
        return;
      }
    }
    cartLineItems.add(cartLineItem);

    saveCartToPref(cartLineItems: cartLineItems);
  }

  Future<String> getTotal({bool withFormat}) async {
    List<Product> cartLineItems = await getCart();
    double total = 0;
    cartLineItems.forEach((cartItem) {
      total += (parseWcPrice(cartItem.total) * cartItem.quantity);
    });

    if (withFormat != null && withFormat == true) {
      return formatDoubleCurrency(total: total);
    }
    return total.toStringAsFixed(2);
  }

  Future<String> getSubtotal({bool withFormat}) async {
    List<Product> cartLineItems = await getCart();
    double subtotal = 0;
    cartLineItems.forEach((cartItem) {
      subtotal += (parseWcPrice(cartItem.subtotal) * cartItem.quantity);
    });
    if (withFormat != null && withFormat == true) {
      return formatDoubleCurrency(total: subtotal);
    }
    return subtotal.toStringAsFixed(2);
  }

  void updateQuantity(
      {Product cartLineItem, int incrementQuantity}) async {
    List<Product> cartLineItems = await getCart();
    List<Product> tmpCartItem = new List<Product>();
    cartLineItems.forEach((cartItem) {
      if (cartItem.variationId == cartLineItem.variationId &&
          cartItem.productId == cartLineItem.productId) {
        if ((cartItem.quantity + incrementQuantity) > 0) {
          cartItem.quantity += incrementQuantity;
        }
      }
      tmpCartItem.add(cartItem);
    });
    saveCartToPref(cartLineItems: tmpCartItem);
  }

  Future<String> cartShortDesc() async {
    List<Product> cartLineItems = await getCart();
    var tmpShortItemDesc = [];
    cartLineItems.forEach((cartItem) {
      tmpShortItemDesc
          .add(cartItem.quantity.toString() + " x | " + cartItem.name);
    });
    return tmpShortItemDesc.join(",");
  }

  void removeCartItemForIndex({int index}) async {
    List<Product> cartLineItems = await getCart();
    cartLineItems.removeAt(index);
    saveCartToPref(cartLineItems: cartLineItems);
  }

  void clear() {
    SharedPref sharedPref = SharedPref();
    List<Product> cartLineItems = new List<Product>();
    String jsonArrCartItems =
    jsonEncode(cartLineItems.map((i) => i.toJson()).toList());
    sharedPref.save(_keyCart, jsonArrCartItems);
  }

  void saveCartToPref({List<Product> cartLineItems}) {
    SharedPref sharedPref = SharedPref();
    String jsonArrCartItems =
    jsonEncode(cartLineItems.map((i) => i.toJson()).toList());
    sharedPref.save(_keyCart, jsonArrCartItems);
  }

  Future<String> taxAmount(TaxRate taxRate) async {
    double subtotal = 0;
    double shippingTotal = 0;

    List<Product> cartItems = await Cart.getInstance.getCart();

    if (cartItems.every((c) => c.taxStatus == 'none')) {
      return "0";
    }
    List<Product> taxableCartLines =
    cartItems.where((c) => c.taxStatus == 'taxable').toList();
    double cartSubtotal = 0;

    if (taxableCartLines.length > 0) {
      cartSubtotal = taxableCartLines
          .map<double>((m) => parseWcPrice(m.subtotal))
          .reduce((a, b) => a + b);
    }

    subtotal = cartSubtotal;

    ShippingType shippingType = CheckoutSession.getInstance.shippingType;

    if (shippingType != null) {
      switch (shippingType.methodId) {
        case "flat_rate":
          FlatRate flatRate = (shippingType.object as FlatRate);
          if (flatRate.taxable != null && flatRate.taxable) {
            shippingTotal += parseWcPrice(
                shippingType.cost == null || shippingType.cost == ""
                    ? "0"
                    : shippingType.cost);
          }
          break;
        case "local_pickup":
          LocalPickup localPickup = (shippingType.object as LocalPickup);
          if (localPickup.taxable != null && localPickup.taxable) {
            shippingTotal += parseWcPrice(
                (localPickup.cost == null || localPickup.cost == ""
                    ? "0"
                    : localPickup.cost));
          }
          break;
        default:
          break;
      }
    }

    double total = 0;
    if (subtotal != 0) {
      total += ((parseWcPrice(taxRate.rate) * subtotal) / 100);
    }
    if (shippingTotal != 0) {
      total += ((parseWcPrice(taxRate.rate) * shippingTotal) / 100);
    }
    return (total).toStringAsFixed(2);
  }
}
*/


class CartScopedModel extends Model {
  String _keyCart = "APP_CART_SESSION";
  CartScopedModel();
  CartScopedModel._privateConstructor();
  static final CartScopedModel getInstance = CartScopedModel._privateConstructor();

  List<Product> _cartsList = [];
  bool _isLoading = true;
  bool _hasModeCarts = true;
  int currentCartCount;

  List<Product> get cartsList => _cartsList; //_productsList

  bool get isLoading => _isLoading;

  bool get hasMoreCarts => _hasModeCarts;

  int get cartcount => _cartsList.length; //_productsList
  void addToCartsList(Product product) {
    _cartsList.add(product);
  }

  Future<String> getCartsCount() async{
    List<Product> cartItems = await CartScopedModel.getInstance.getCart();
      _cartsList = cartItems;
      var cnt = _cartsList.length.toString();
     // print(cnt);
      return cnt;
  }

  double getCartTotalAmount() {
    var total = 0.0;
    int cnt = 10;//this.getCartsCount();
    for(var i = 0; i<cnt; i++) {
      Product prd = this.cartsList[i];
      total += (int.tryParse(prd.cartItems.line_price) ?? 0 );
      print(prd.cartLinePrice);
    }
    return total;
  }
  void clearCart() async {
    SharedPref sharedPref = SharedPref();

    String jsonArrCartItems ="";
    sharedPref.save(_keyCart, jsonArrCartItems);
  }
  void addToCart(Product cartItem, qty) async {
    Cart cartData = await addCartInSer(cartItem, qty);
    cartItem.cartItems = cartData;
    List<Product> cartLineItems = await getCart();

    if (false) { //cartItem.cartItems != null && cartItem.cartItems.variation != ""
      printApp("add to cart loop 1");
      if (cartLineItems.firstWhere(
              (i) => (i.productId == cartItem.productId &&
              i.cartItems.variation == cartItem.cartItems.variation),
          orElse: () => null) !=
          null) {
        return;
      }
    } else {
      printApp("add to cart loop 2");
      var firstCartItem = cartLineItems.firstWhere(
              (i) => i.productId == cartItem.productId,
          orElse: () => null);
      if (firstCartItem != null) {
        return;
      }

    }
    cartLineItems.add(cartItem);
    saveCartToPref(cartItems: cartLineItems);
  }

  void saveCartToPref({List<Product> cartItems}) {
    SharedPref sharedPref = SharedPref();

    String jsonArrCartItems =jsonEncode(cartItems.map((i) => i.toJson()).toList());
    sharedPref.save(_keyCart, jsonArrCartItems);
  }

  Future addCartInSer(product,qty) async {
    var url = AppConfig.getApiUrl("cart") + "?id=${product.productId}&quantity=${qty}";
    http.Response response = await postApi(url, "");
    //notifyListeners();

    //List<Cart> cartItems = [];
    Cart cartItems;
    var bodyResp = json.decode(response.body);
    printApp(bodyResp);
    cartItems = Cart.fromJson(bodyResp);

    //currentCartCount = 0;
    //cartItems = prepareCartList(bodyResp);
    //notifyListeners();
    return cartItems;
  }


  Future<List<Product>> getCart() async {
    List<Product> cartItems = [];
    SharedPref sharedPref = SharedPref();
    String currentCartArrJSON = (await sharedPref.read(_keyCart) as String);
    printApp('print -  cart');
    printApp(currentCartArrJSON);
    if (currentCartArrJSON == null || currentCartArrJSON == "") {
      cartItems = List<Product>();
    } else {

      cartItems = (jsonDecode(currentCartArrJSON) as List<dynamic>).map((i) => Product.fromJson(i)).toList();
    }
    _cartsList = cartItems;
    return cartItems;
  }

  Cart getCartData(id){

    Cart cartData;
    _cartsList.forEach((Product) {
              if(Product.productId == id){
                //isfind=true;
                cartData = Product.cartItems;
              }
            });
    //_cartsList = cartItems;
    //print("print cart list");
    //print(_cartsList);
    //addToCartsList(cartItems);
    if(cartData != null)
    printApp(cartData.toJson());
    else
      printApp("============No cart");
    return cartData;
  }

  /*
  Future<dynamic> _getCarts(pageIndex) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await readAuthToken();//prefs.getString('token');

    var response = await http.get(
      AppConfig.getApiUrl("cart"), // + "?&per_page=${AppConfig.perpage['all']}&page=$pageIndex",  //category=$categoryId&
      headers: {
        "Authorization": 'Bearer ${token}',
      },
    ).catchError(
          (error) {
        return false;
      },
    );

    return json.decode(response.body);
  }*/

  Future<List<Product>> getCartProductDataFromApi(ids) async {
    var url = AppConfig.getApiUrl("products") + "?include=${ids}";
    http.Response respprd = await getApi(url);

    List<Product> prdd = [];
    if (respprd.body == null || respprd.body == "") {
      prdd = List<Product>();
    } else {
      prdd = (jsonDecode(respprd.body) as List<dynamic>).map((i) =>
          Product.fromWpJson(i)).toList();
    }
    return prdd;
  }

  Future<List<Cart>> getCartDataFromApi() async {
    return List<Cart>();
    var url = AppConfig.getApiUrl("cart");
    http.Response resp = await getApi(url);
    List<Cart> cartItems = [];
    printApp("Cart Resp=======================\n ${resp.body}");
    //return List<Cart>();
    if (resp.body == null || resp.body == "") {
      cartItems = List<Cart>();
    } else {
      cartItems = (jsonDecode(resp.body) as List<dynamic>)
          .map((i) => Cart.fromJson(i))
          .toList();
    }
    return cartItems;
  }
  Future<List<Product>> getPrdCartDataFromApi() async {
    List<Cart> cartItems = [];
    cartItems = List<Cart>();
    var cartIds = (cartItems.map((i) => i.id)).toList().join(",");
    List<Product> prddata = await this.getCartProductDataFromApi(cartIds);
//    var pcartIds = (prddata.map((i) => i.productId)).toList().join(",");
//printApp("prd Prep=======================\n ${pcartIds}");
    printApp("Cart Prep=======================\n ${cartIds}");

    List<Product> prdCartItems = [];
    Cart CartData;
    prddata.forEach((prd) {
      CartData = cartItems.firstWhere(
              (i) => i.id == prd.productId,
          orElse: () => null);
      prd.cartItems = CartData;
      prdCartItems.add(prd);
    });
    saveCartToPref(cartItems: prdCartItems);

    _cartsList = prdCartItems;
    //print("print cart list");
    //print(_cartsList);
    //addToCartsList(cartItems);
    return prdCartItems;
  }


  Future parseCartsFromResponse(int pageIndex) async {
    if (pageIndex == 1) {
      _isLoading = true;
    }

    notifyListeners();

    currentCartCount = 0;

    List<Product> cartItems = await CartScopedModel.getInstance.getCart();
    _cartsList = cartItems;
    currentCartCount = _cartsList.length;

    //prepareCartList(dataFromResponse);

    if (pageIndex == 1) _isLoading = false;

    //if (currentCartCount < 6) {
      _hasModeCarts = false;
    //}

    notifyListeners();
  }


  prepareCartList(data){
    //List<Cart> cartItems = [];
    Cart cartItems;
    //data.forEach((cartdata) {

        //parse the product's images
        List<AnyImage> imagesOfProductList = [];
        if(data["images"] != null) {
          data["images"].forEach(
                (newImage) {
              imagesOfProductList.add(
                new AnyImage(
                  imageURL: newImage["src"],
                  id: newImage["id"],
                  title: newImage["name"],
                  alt: newImage["alt"],
                ),
              );
            },
          );
        }

        Cart cartpr = new Cart(
          key: data["key"],
          id: data["id"],
          name: data["name"],
          //price: cartdata["price"],
          line_price: data["line_price"],
          permalink: data["permalink"],
          quantity: data["quantity"],
          image: imagesOfProductList,
        );
        //cartItems.add(cartpr);
        cartItems = cartpr;
      //},
   // );
    return cartItems;
  }
}


