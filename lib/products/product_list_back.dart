import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
//import 'package:flutter_html/flutter_html.dart';
import 'package:greenillu/appconfig/config.dart';
import 'package:greenillu/widgets/app_bar.dart';
import 'package:greenillu/widgets/appdrawer.dart';
import 'package:greenillu/model/any_image.dart';
import 'package:greenillu/model/category.dart';
import 'package:greenillu/model/product.dart';
import 'package:greenillu/widgets/products_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsListPage extends StatelessWidget {
  static const String routeName = '/products';
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text('PRODUCT LIST'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),/*AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40.0,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "PRODUCT LIST",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),*/
      drawer: AppDrawer(), //menu
      body: _buildProductsListPage(),
    );
  }


  _buildProductsListPage() {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey[100],
      child: FutureBuilder<List<Product>>(
        future: _parseProductsFromResponse(95),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:

            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());

            case ConnectionState.none:
              return Center(child: Text("Unable to connect right now"));

            case ConnectionState.done:

              return ListView.builder(
                itemCount: ( snapshot.hasData )?snapshot.data.length:0,
                itemBuilder: (context, index) {
                  if( snapshot.hasData){
                    //  return _buildNoDataWidgets(screenSize);
                    if (index == 0) {
                      //0th index would contain filter icons
                      return _buildFilterWidgets(screenSize);
                    } else if (index == 7) {
                      return SizedBox(height: 12.0);
                    } /*else if (index % 2 == 0) {
                    //2nd, 4th, 6th.. index would contain nothing since this would
                    //be handled by the odd indexes where the row contains 2 items
                    return Container();
                  } else */{
                      //1st, 3rd, 5th.. index would contain a row containing 2 products

                      return ProductsListItem(

                        product1: snapshot.data[index-1],
                        // product2: snapshot.data[index],
                      );
                    }
                  } //no data condition
                },
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

  _buildNoDataWidgets(Size screenSize) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      width: screenSize.width,
      child: Card(
        elevation: 4.0,
        child:
        //padding: const EdgeInsets.symmetric(vertical: 12.0),
        Text(
          "Products are not available",
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
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

  Future<dynamic> _getProductsByCategory(categoryId, pageIndex) async {
    var url = AppConfig.Appurls['wpapi'] + AppConfig.Namespaces["products"]+ "?per_page=100&page=$pageIndex";
    //print(url);
    // + "?&category=$categoryId&per_page=6&page=$pageIndex";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    //print(token);
    var response = await http.get(url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token}',
      },
    ).catchError(
          (error) {
        return false;
      },
    );
    //var tot = response.headers['X-WP-Total'];
    //var totpages = response.headers['X-WP-TotalPages'];
    //print('response headers ${totpages} ${tot}');
    return json.decode(response.body);
  }

  _getProductsCount() async {
    var url = AppConfig.Appurls['wpapi'] + AppConfig.Namespaces["products"];
    print(url);
    // + "?&category=$categoryId&per_page=6&page=$pageIndex";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var responseCnt = await http.get(url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token}',
      },
    ).catchError(
          (error) {

        return false;
      },
    );
    print(responseCnt.body.length);
    int count = 50;//responseCnt.body.length ;
    return count;
  }



  Future<List<Product>> _parseProductsFromResponse(int categoryId) async {
    List<Product> productsList = <Product>[];

    var dataFromResponse = await _getProductsByCategory(categoryId, 1);
    var intN = 0;
    dataFromResponse.forEach(
          (newProduct) {

        //parse the product's images
        List<AnyImage> imagesOfProductList = [];

        newProduct["images"].forEach(
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

        //parse the product's categories
        List<Category> categoriesOfProductList = [];

        newProduct["categories"].forEach(
              (newCategory) {
            categoriesOfProductList.add(
              new Category(
                id: newCategory["id"],
                name: newCategory["name"],
              ),
            );
          },
        );
        var regularprice = int.tryParse(newProduct["regular_price"]) ?? 0;
        var saleprice = int.tryParse(newProduct["sale_price"]) ?? 0;
        var disc = 0;
        if(regularprice > 0 && saleprice>0)
          disc = ((((regularprice - saleprice) / (regularprice)) * 100)).round();

        Product product = new Product(
            productId: newProduct["id"],
            productName: newProduct["name"],
            description: newProduct["description"],
            regularPrice: newProduct["regular_price"],
            salePrice: newProduct["sale_price"],
            stockQuantity: newProduct["stock_quantity"] != null ? newProduct["stock_quantity"] : 0,
            ifItemAvailable: (newProduct["on_sale"] && newProduct["purchasable"] && (newProduct['stock_status'] == 'instock')), //newProduct["in_stock"]
            discount: disc,
            images: imagesOfProductList,
            categories: categoriesOfProductList
        );
        productsList.add(product);
      },
    );

    return productsList;
  }

}


/*_launchUrl(String link) async {
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Cannot launch $link';
  }
}*/
