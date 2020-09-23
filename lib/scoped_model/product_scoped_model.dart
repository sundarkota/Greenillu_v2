import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:greenillu/model/any_image.dart';
import 'package:greenillu/model/category.dart';
import 'package:greenillu/model/cart.dart';
import 'package:greenillu/model/product.dart';
import 'package:greenillu/appconfig/config.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:greenillu/scoped_model/cart_scoped_model.dart';
import 'package:greenillu/utils/sharedpref.dart';
import 'package:greenillu/utils/functions.dart';

class ProductScopedModel extends Model {
  List<Product> _productsList = [];
  bool _isLoading = true;
  bool _hasModeProducts = true;
  int currentProductCount;

  List<Product> get productsList => _productsList;

  bool get isLoading => _isLoading;

  bool get hasMoreProducts => _hasModeProducts;

  void addToProductsList(Product product) {
    _productsList.add(product);
  }

  int getProductsCount() {
    return _productsList.length;
  }

  Future<dynamic> _getProductsByCategory(categoryId, pageIndex) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //var token = await readAuthToken();//prefs.getString('token');

   // print('tooooooooken in product----------------------------------------');
   // print(token);
    var url = AppConfig.getApiUrl("products") + "?&per_page=6&page=$pageIndex";  //category=$categoryId&
   /* print(url);
    var response = await http.get(url,
      headers: {
        "Authorization": 'Bearer ${token}',
      },
    ).catchError(
          (error) {
        return false;
      },
    );*/
    http.Response response = await getApi(url);
    return json.decode(response.body);
  }

  Future parseProductsFromResponse(int categoryId, int pageIndex) async {
    if (pageIndex == 1) {
      _isLoading = true;
    }

    notifyListeners();

    currentProductCount = 0;

    var dataFromResponse = await _getProductsByCategory(categoryId, pageIndex);
    CartScopedModel cartModel = CartScopedModel();
    await cartModel.getCart();

     dataFromResponse.forEach(
          (newProduct) {
        currentProductCount++;

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

        //parse new product's details
        var regularprice = int.tryParse(newProduct["regular_price"]) ?? 0;
        var saleprice = int.tryParse(newProduct["sale_price"]) ?? 0;
        var disc = 0;
        if(regularprice > 0 && saleprice>0)
          disc = ((((regularprice - saleprice) / (regularprice)) * 100)).round();

        Cart prdCartdata = cartModel.getCartData(newProduct["id"]);

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
            categories: categoriesOfProductList,
            cartItems: prdCartdata
        );
        addToProductsList(product);
      },
    );

    if (pageIndex == 1) _isLoading = false;

    if (currentProductCount < 6) {
      _hasModeProducts = false;
    }

    notifyListeners();
  }
}