import 'package:flutter/material.dart';
import 'package:greenillu/scoped_model/cart_scoped_model.dart';
import 'package:greenillu/cart/cart_list.dart';
import 'package:greenillu/utils/functions.dart';
import 'package:greenillu/utils/format.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.green;
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;

  Future<int> _getCartCount() async{
    var cnt = await getCartCount();
  }

  /// you can add more fields that meet your needs

  const BaseAppBar({Key key, this.title, this.appBar, this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    CartScopedModel cartModel = CartScopedModel();
    cartModel.parseCartsFromResponse(1);
    int cartcount = parseInt(_getCartCount().toString());
    print("appbui ${cartcount}");
    return AppBar(
      title: title,
      /*leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          size: 40.0,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),*/
      backgroundColor: backgroundColor,
      actions: <Widget>[
         /* // action button
            IconButton(
            icon: Icon(choices[0].icon),
            onPressed: () {
            //_select(choices[0]);
            }
          ),*/
        Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 1.0),
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[

                Icon(
                  Icons.shopping_cart,
                  size: 25.0,
                ),
                if ( cartcount > 0)
                Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(top: 1.0),
                    child: CircleAvatar(
                      radius: 8.0,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      child: Text(
                        cartcount.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 9.0,
                        ),
                      ),
                    ),
                  ),
                if (cartcount > 0)
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    cartcount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                        fontSize: 12.0,
                      ),
                    ),
                 ),
              ],
            ),
            onTap: () {
              if (cartcount > 0)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CartListPage(),
                  ),
                );
            },
          ),
        ),
        IconButton(
            icon: Icon(Icons.remove_shopping_cart),
            onPressed: () {
              clearShoppingCart();
            }
        )
        ]
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}


class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Cart', icon: Icons.shopping_cart),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

/*class FlexibleAppBar extends SliverAppBar {
  static const double height = 256.0;

  FlexibleAppBar(String title, String imageUrl) : super(
      pinned: true,
      expandedHeight: height,
      flexibleSpace: FlexibleSpaceBar(
          title: Text(title),
          background: _buildBackground(imageUrl),
          centerTitle: true,
      )
  );

  static Widget _buildBackground(String imageUrl) {
    return Stack (
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: height
          ),

          DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset(0.5, 0.6),
                      end: FractionalOffset(0.5, 1.0),
                      colors: <Color>[Color(0x00000000), Color(0x70000000)]
                  )
              )
          )
        ]
    );
  }

}*/