//import 'dart:async';
//import 'dart:convert';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
//import 'package:flutter_html/flutter_html.dart';
import 'package:greenillu/appconfig/config.dart';
import 'package:greenillu/widgets/app_bar.dart';
import 'package:greenillu/widgets/appdrawer.dart';
//import 'package:greenillu/model/any_image.dart';
//import 'package:greenillu/model/category.dart';
import 'package:greenillu/model/cart.dart';
import 'package:greenillu/model/product.dart';
import 'package:greenillu/widgets/products_list_item.dart';
import 'package:greenillu/widgets/carts_list_item.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenillu/scoped_model/cart_scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:greenillu/utils/functions.dart';
import 'package:greenillu/utils/format.dart';
//import 'package:greenillu/cart/cart_footer.dart';


class CartListPage extends StatelessWidget {
  static const String routeName = '/cart';
  //CartListPage();
 /* List<Product> _cartLines;

  @override
  void initState() {
    //super.initState();
    _cartLines = [];
    //_isLoading = true;
    _cartCheck();
  }

  _cartCheck() async {
    List<Product> _cartLines = await CartScopedModel.getInstance.getCart();
  }*/


    @override
  Widget build(BuildContext context) {
    CartScopedModel productModel = CartScopedModel();
    productModel.parseCartsFromResponse(1);


    return new ScopedModel<CartScopedModel>(
      model: productModel,
      child: Scaffold(
        appBar: BaseAppBar(
          title: Text('CART LIST'),
          appBar: AppBar(),
          widgets: <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: AppDrawer(), //menu
        body: CartsListPageBody(),
       // bottomNavigationBar: BottomBarButton(),//placeOrder(), Cartfooter(), //
            //child: BottomBarButton(),
        //placeOrder(),//<Widget>[ ],
      ),
    );
  }
}

class CartsListPageBody extends StatelessWidget {
  BuildContext context;

  CartScopedModel model;

  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<CartScopedModel>(
      builder: (context, child, model) {
        this.model = model;
        return model.isLoading
            ? _buildCircularProgressIndicator()
            : _buildListView();
      },
    );
  }

  _buildCircularProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildListView() {
    Size screenSize = MediaQuery.of(context).size;
    var cnt = getCartCount();//await model.getCartsCount();
    //print(await model.cartsList);
    int cartcount = model.cartcount;//parseInt(cnt.toString());
   print("cartlist ${cartcount}");
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: cartcount == 0
          ? Center(child: Text("No products available."))
          : ListView.builder(
        itemCount: cartcount + 3,
        itemBuilder: (context, index) {
          print("inex ${index}");
          if (index == cartcount) {

            if (model.hasMoreCarts) {
              pageIndex++;
              model.parseCartsFromResponse(pageIndex);
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return Container();
          } else if (index == (cartcount + 1)) {
            return _paymentDetails(screenSize);
          } else if (index == (cartcount + 2)) {
            //return _placeOrder(screenSize);
          }
          else {
            //1st, 3rd, 5th.. index would contain a row containing 2 products

            if (index > cartcount - 1) {
              return Container();
            }



            Product prd = model.cartsList[index];
            prd.cartItems = model.getCartData(model.cartsList[index].productId);
            return ProductsListItem(
              product1: model.cartsList[index],
              //product2: model.productsList[index],
            );
          }
        },
      ),
    );
  }

  _buildFilterWidgets(Size screenSize) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      width: screenSize.width,
      child: Card(
        elevation: 4.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildFilterButton("SORT"),
              Container(
                color: Colors.black,
                width: 2.0,
                height: 24.0,
              ),
              _buildFilterButton("REFINE"),
            ],
          ),
        ),
      ),
    );
  }

  _buildFilterButton(String title) {
    return InkWell(
      onTap: () {
        print(title);
      },
      child: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          SizedBox(
            width: 2.0,
          ),
          Text(title),
        ],
      ),
    );
  }

  _paymentDetails(Size screenSize) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      width: screenSize.width,
      child: Card(
        elevation: 4.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Payment details"),
              Text("MRP total"),
              Text("Discount"),
              Text("Total Amount")
            ],
          ),
        ),
      ),
    );
  }

}