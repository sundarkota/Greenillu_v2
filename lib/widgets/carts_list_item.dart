import 'package:flutter/material.dart';
import 'package:greenillu/model/product.dart';
import 'package:greenillu/model/cart.dart';
import 'package:greenillu/products/details_page.dart';
import 'package:greenillu/appconfig/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenillu/scoped_model/cart_scoped_model.dart';

class CartsListItem extends StatelessWidget {
  final Product product1;
  //final Product product2;

  CartsListItem({
    @required this.product1,
    //@required this.product2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildProductItemCard(context, product1),
        //_buildProductItemCard(context, product2),
      ],
    );
  }

  _buildProductItemCard(BuildContext context, Product product) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              //return ProductDetailPage(product: product);
            },
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: 4.0,
              ),
              height: 120.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _imageBox(product,MediaQuery.of(context).size.width / 4.4),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _titleBox(product),
                          SizedBox(
                            height: 6.0,
                          ),
                          _center_centerRight(product),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 3 / 4.4
                  ),
                ],

              ),
            ),

            _buildButtonBar(context,product), //bottom button
          ],
        ),
      ),
    );
  }

  _buildButtonBar(BuildContext context, Product product) {
    return Container(
      width: MediaQuery.of(context).size.width - 8,
      padding: EdgeInsets.all(2),
      height: 35.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            //fit: FlexFit.loose,
            //flex: 1,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.white,
              child: Text(
                "SAVE",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Flexible(
            //fit: FlexFit.loose,
            //flex: 2,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.white,
              child: Text(
                "Type",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Flexible(
            //flex: 3,
            //fit: FlexFit.loose,
            child: RaisedButton(
              onPressed: () => { addToCart(product,'1')},
              color: Colors.green,
              child:  Text(
                "${product.cartQuantity}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _imageBox(product,wd){
    return Container(
      padding: const EdgeInsets.only(
        left: 4.0,
        top: 8.0,
      ),
      child: Image.network(
        product.images[0].imageURL == null ? AppConfig.getImgUrl("dummp.jpg") : product.images[0].imageURL,
      ),
      height: 112.0,
      width: wd,
      alignment: Alignment.centerLeft,
    );
  }

  _titleBox(product){
    return Text(
      product.productName,
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }
  _center_centerRight(product){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //_discountBox(product),//discuountbox
        _priceBox(product)//pricebox
      ],
    );
  }

  _discountBox(product){
    var disc = " ";
    if(product.discount > 0) {
      disc = "${product.discount}% off";
    }
    return Text(
      disc,
      style: TextStyle(
          fontSize: 14.0, color: Colors.red, fontWeight: FontWeight.bold),
    );
  }

  _priceBox(product){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "\$${product.cartPrice}",
          style: TextStyle(fontSize: 16.0, color: Colors.green),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "\$${product.cartLinePrice}",
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Future addToCart(product,qty) async{
    CartScopedModel cartModel = CartScopedModel();
    cartModel.addToCart(product, qty);
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);


    var urlc = AppConfig.Appurls['wpapi'] + AppConfig.Namespaces["cart"] + "?id=${product.productId}&quantity=1";
    print(urlc);
    var responsec = await http.post(urlc
      //headers: {
      //  "Authorization": 'Bearer ${token}',
      //},
    ).catchError(
          (error) {
        return false;
      },
    );
    //if(responsec.statusCode == 200){
        print(responsec.body);
    //}
*/
  }

}