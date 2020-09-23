import 'package:greenillu/model/any_image.dart';
import 'package:greenillu/model/category.dart';
import 'package:greenillu/model/cart.dart';

class Product {
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
  Cart cartItems;
  String cartKey;
  int cartQuantity;
  String cartPrice;
  String cartLinePrice;
  List<String> cartVariation;

  Product(
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
        this.cartVariation,
        this.cartItems});

    static List getImages(product){
      //parse the product's images
      List<AnyImage> imagesOfProductList = [];
      if(product["images"] != null ) {
        product["images"].forEach(
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
      return imagesOfProductList;
    }

  static List categoriesOfProductList(product){
    //parse the product's images
    //parse the product's categories
    List<Category> categoriesOfProductList = [];

    if(product["categories"] != null ){
      product["categories"].forEach(
            (newCategory) {
          categoriesOfProductList.add(
            new Category(
              id: newCategory["id"],
              name: newCategory["name"],
            ),
          );
        },
      );
    }
    return categoriesOfProductList;
  }

  static cartOfProductList(product){
    Cart cartList;

    if(product["cartItems"] != null ){
      var data = product["cartItems"];
              cartList = new Cart(
                key: data["key"],
                id: data["id"],
                name: data["name"],
                //price: cartdata["price"],
                line_price: data["line_price"],
                permalink: data["permalink"],
                quantity: data["quantity"],
                image: getImages(data)
            );

    }
    return cartList;
  }

  static int getDiscount(product){
    //parse new product's details
    var regularprice = int.tryParse(product["regular_price"]) ?? 0;
    var saleprice = int.tryParse(product["sale_price"]) ?? 0;
    var disc = 0;
    if(regularprice > 0 && saleprice>0)
      disc = ((((regularprice - saleprice) / (regularprice)) * 100)).round();
    return disc;
  }

  Product.fromWpJson(Map<String, dynamic> newProduct)
      : productId= newProduct["id"],
        productName= newProduct["name"],
        description= newProduct["description"],
        regularPrice= newProduct["regular_price"],
        salePrice= newProduct["sale_price"],
        stockQuantity= newProduct["stock_quantity"] != null ? newProduct["stock_quantity"] : 0,
        ifItemAvailable= newProduct["ifItemAvailable"],//(newProduct["on_sale"] && newProduct["purchasable"] && (newProduct['stock_status'] == 'instock')), //newProduct["in_stock"]
        discount= getDiscount(newProduct),
        images = getImages(newProduct),
        categories= categoriesOfProductList(newProduct),
        cartItems = newProduct["cartItems"];

  Product.fromJson(Map<String, dynamic> newProduct)
      : productId= newProduct["productId"],
        productName= newProduct["productName"],
        description= newProduct["description"],
        regularPrice= newProduct["regularPrice"],
        salePrice= newProduct["salePrice"],
        stockQuantity= newProduct["stockQuantity"] != null ? newProduct["stockQuantity"] : 0,
        ifItemAvailable= newProduct["ifItemAvailable"],
        discount= newProduct["discount"],
        images = getImages(newProduct),
        categories= categoriesOfProductList(newProduct),
        cartItems = cartOfProductList(newProduct);

    Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'description': description,
    'regularPrice': regularPrice,
    'salePrice': salePrice,
    'stockQuantity': stockQuantity,
    'ifItemAvailable': ifItemAvailable,
    'discount': discount,
    'images': images,
    'categories': categories,
    'cartItems': cartItems
  };

  @override
  toString() => "productId: $productId , productName: $productName";

}