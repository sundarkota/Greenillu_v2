import 'package:flutter/material.dart';
import 'package:greenillu/model/product.dart';
import 'package:greenillu/products/details_page.dart';
import 'package:greenillu/appconfig/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greenillu/scoped_model/cart_scoped_model.dart';

class ProductsListItem extends StatelessWidget {
  final Product product1;
  //final Product product2;

  ProductsListItem({
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
              return ProductDetailPage(product: product);
            },
          ),
        );
      },
      child: Container(
       // elevation: 4.0,
        padding:  EdgeInsets.all(4),
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
              color: Colors.green,
              width: 1,
              )
            )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
         Container(
            //padding: const EdgeInsets.only(
           // left: 4.0,
          //  ),
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
             // padding: const EdgeInsets.only(
               // top: 8.0,
              //),
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
    var row1 = (MediaQuery.of(context).size.width - 24 )  / 4;
    var row2 = ( ( (MediaQuery.of(context).size.width - 24 ) - row1 ) / 2 );

    return Container(
      width: MediaQuery.of(context).size.width -8,
      height: 34.0,
       child: Row(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              //fit: FlexFit.loose,
              //flex: 1,
              width: row1,
              child: FlatButton(
                onPressed: () {},
                color: Colors.white,
                child: Text(
                      "SAVE",
                      style: TextStyle(color: Colors.black),
                    ),
              ),
            ),
            Container(
              width: row2,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0,
                      color: Colors.green
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //         <--- border radius here
                  )),
              child: FlatButton(
                onPressed: () {},
                color: Colors.white,
                 child: Text(
                        "Type",
                        style: TextStyle(color: Colors.black),
                      ),
              ),
            ),
            addToCartWidget(row2, product),
          ],
        ),
    );
  }

  addtoCartIncrDecr(wd, product){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 2.0,
              color: Colors.green
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          )),
      width: wd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              width: 40,
              color: Colors.green,
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.remove),
                tooltip: 'remove  to cart(1)',
                onPressed: () => { addToCart(product, '-1')},
                color: Colors.white,
              )
          ),
          Flexible(
              child: Text(product.cartItems.quantity.toString()) //Text("Qantity")
          ),
          Container(
              width: 40,
              color: Colors.green,
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.add, size:20 ),
                tooltip: 'add  to cart(1)',
                onPressed: () => { addToCart(product, '1')},
                color: Colors.white,
              )
          ),
        ],
      ),
    );
  }

  addToCartButton(wd, product){
    return Flexible(
      //flex: 3,
      //fit: FlexFit.loose,
      child: FlatButton(
        onPressed: () => { addToCart(product, 1)},
        color: Colors.green,
        child: Text(
          "ADD TO CART",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
  addToCartWidget(wd, product){
    if(product.cartItems != null){
      return addtoCartIncrDecr(wd, product);
    }
    else {
      return addToCartButton(wd, product);
    }
  }

      _imageBox(product,wd){

        return Container(
          padding: const EdgeInsets.only(
            left: 4.0,
           // top: 8.0,
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
          _discountBox(product),//discuountbox
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
          "\$${product.salePrice}",
          style: TextStyle(fontSize: 16.0, color: Colors.green),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "\$${product.regularPrice}",
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.blueGrey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }

  void addToCart(product,qty) async{
    //CartScopedModel cartModel = CartScopedModel();

    await CartScopedModel.getInstance.addToCart(product,qty);
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