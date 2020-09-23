import 'package:greenillu/model/any_image.dart';
import 'package:greenillu/model/category.dart';

class Store {
  String lineItemId;
  int productId;
  String productName;
  String sku;
  List<Category> categories;
  List<AnyImage> images;
  List<String> size;
  String shortDescription;
  String regularPrice;
  String salePrice;
  int discount;
  bool ifItemAvailable;
  bool ifAddedToCart;
  String description;
  int stockQuantity;
  int quantity;
  String permalink;
  String cartKey;
  String cartQuantity;
  String cartPrice;
  String cartLinePrice;
  List<String> cartVariation;

  Store(
      {this.lineItemId,
        this.productId,
        this.sku,
        this.productName,
        this.categories,
        this.images,
        this.size,
        this.shortDescription,
        this.regularPrice,
        this.salePrice,
        this.discount,
        this.ifItemAvailable,
        this.ifAddedToCart,
        this.description,
        this.stockQuantity,
        this.quantity,
        this.permalink,
        this.cartKey,
        this.cartQuantity,
        this.cartPrice,
        this.cartLinePrice,
        this.cartVariation});

  @override
  toString() => "productId: $productId , productName: $productName";

}