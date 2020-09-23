//import 'dart:async';
//import 'dart:convert';
//import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
//import 'package:flutter_html/flutter_html.dart';
//import 'package:greenillu/appconfig/config.dart';
import 'package:greenillu/widgets/app_bar.dart';
import 'package:greenillu/widgets/appdrawer.dart';
//import 'package:greenillu/model/any_image.dart';
//import 'package:greenillu/model/category.dart';
import 'package:greenillu/model/product.dart';
import 'package:greenillu/widgets/products_list_item.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenillu/scoped_model/product_scoped_model.dart';
import 'package:greenillu/scoped_model/cart_scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsListPage extends StatelessWidget {
  static const String routeName = '/products';



  @override
  Widget build(BuildContext context) {
    ProductScopedModel productModel = ProductScopedModel();
    productModel.parseProductsFromResponse(95, 1);

    return new ScopedModel<ProductScopedModel>(
      model: productModel,
      child: Scaffold(
        appBar: BaseAppBar(
          title: Text('PRODUCT LIST'),
          appBar: AppBar(),
          widgets: <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: AppDrawer(), //menu
        body: ProductsListPageBody(),
      ),
    );
  }
}

class ProductsListPageBody extends StatelessWidget {
  BuildContext context;

  ProductScopedModel model;
  CartScopedModel cartModel = CartScopedModel();

  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return ScopedModelDescendant<ProductScopedModel>(
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: model.getProductsCount() == 0
          ? Center(child: Text("No products available."))
          : ListView.builder(
        itemCount: model.getProductsCount() + 2,
        itemBuilder: (context, index) {
          if (index == model.getProductsCount()) {
            if (model.hasMoreProducts) {
              pageIndex++;
              model.parseProductsFromResponse(95, pageIndex);
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return Container();
          } else if (index == 0) {
            //0th index would contain filter icons
            return _buildFilterWidgets(screenSize);
          } /*else if (index % 2 == 0) {
            //2nd, 4th, 6th.. index would contain nothing since this would
            //be handled by the odd indexes where the row contains 2 items
            return Container();
          }*/ else {
            //1st, 3rd, 5th.. index would contain a row containing 2 products

            if (index > model.getProductsCount() - 1) {
              return Container();
            }

            return ProductsListItem(
              product1: model.productsList[index],
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
}