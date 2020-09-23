import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:greenillu/model/any_image.dart';
import 'package:greenillu/model/category.dart';
import 'package:greenillu/model/cart.dart';
import 'package:greenillu/model/product.dart';
import 'package:greenillu/model/store.dart';
import 'package:greenillu/appconfig/config.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:greenillu/scoped_model/cart_scoped_model.dart';
import 'package:greenillu/utils/sharedpref.dart';
import 'package:greenillu/utils/functions.dart';

class StoreScopedModel extends Model {
  List<Store> _storesList = [];
  bool _isLoading = true;
  bool _hasModeStores = true;
  int currentStoreCount;

  List<Store> get storesList => _storesList;

  bool get isLoading => _isLoading;

  bool get hasMoreStores => _hasModeStores;

  void addToStoresList(Store store) {
    _storesList.add(store);
  }

  int getStoresCount() {
    return _storesList.length;
  }

  Future<dynamic> _getStoresByCategory(categoryId, pageIndex) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await readAuthToken();//prefs.getString('token');

    print('tooooooooken in store----------------------------------------');
    print(token);
    var url = AppConfig.getApiUrl("stores") + "?&per_page=6&page=$pageIndex";  //category=$categoryId&
    print(url);
    var response = await http.get(url,
      headers: {
        "Authorization": 'Bearer ${token}',
      },
    ).catchError(
          (error) {
        return false;
      },
    );

    return json.decode(response.body);
  }

  Future parseStoresFromResponse(int categoryId, int pageIndex) async {
    if (pageIndex == 1) {
      _isLoading = true;
    }

    notifyListeners();

    currentStoreCount = 0;

    var dataFromResponse = await _getStoresByCategory(categoryId, pageIndex);
    CartScopedModel cartModel = CartScopedModel();
    await cartModel.getCart();

    dataFromResponse.forEach(
          (newStore) {
        currentStoreCount++;

        //parse the store's images
        List<AnyImage> imagesOfStoreList = [];

        newStore["images"].forEach(
              (newImage) {
            imagesOfStoreList.add(
              new AnyImage(
                imageURL: newImage["src"],
                id: newImage["id"],
                title: newImage["name"],
                alt: newImage["alt"],
              ),
            );
          },
        );

        //parse the store's categories
        List<Category> categoriesOfStoreList = [];

        newStore["categories"].forEach(
              (newCategory) {
            categoriesOfStoreList.add(
              new Category(
                id: newCategory["id"],
                name: newCategory["name"],
              ),
            );
          },
        );

        //parse new store's details
        var regularprice = int.tryParse(newStore["regular_price"]) ?? 0;
        var saleprice = int.tryParse(newStore["sale_price"]) ?? 0;
        var disc = 0;
        if(regularprice > 0 && saleprice>0)
          disc = ((((regularprice - saleprice) / (regularprice)) * 100)).round();

        Cart prdCartdata = cartModel.getCartData(newStore["id"]);

        Store store = new Store(
            productId: newStore["id"],
            productName: newStore["name"],
            description: newStore["description"],
            regularPrice: newStore["regular_price"],
            salePrice: newStore["sale_price"],
            stockQuantity: newStore["stock_quantity"] != null ? newStore["stock_quantity"] : 0,
            ifItemAvailable: (newStore["on_sale"] && newStore["purchasable"] && (newStore['stock_status'] == 'instock')), //newStore["in_stock"]
            discount: disc,
            images: imagesOfStoreList,
            categories: categoriesOfStoreList,
        );
        addToStoresList(store);
      },
    );

    if (pageIndex == 1) _isLoading = false;

    if (currentStoreCount < 6) {
      _hasModeStores = false;
    }

    notifyListeners();
  }
}