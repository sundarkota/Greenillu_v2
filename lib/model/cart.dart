import 'package:greenillu/model/any_image.dart';
import 'package:greenillu/model/category.dart';
import 'package:greenillu/utils/format.dart';
import 'package:greenillu/utils/functions.dart';

class Cart {
  String key;
  int id;
  int quantity;
  String name;
  String sku;
  String permalink;
  String price;
  String line_price;
  List variation;
  List<AnyImage> image;

  static List getImages(product){
    //parse the product's images
    List<AnyImage> imagesOfProductList = [];

    if(product != "" && product != null && product["images"] != "" && product["images"] != null){
      product["images"].forEach(
            (newImage) {
          imagesOfProductList.add(
            new AnyImage(
              imageURL: newImage["src"],
              id: parseInt(newImage["id"].toString()),
              title: newImage["name"],
              alt: newImage["alt"],
            ),
          );
        },
      );
    } else {
      imagesOfProductList.add(dummyImage());
    }
    return imagesOfProductList;
  }

  Cart(
      {this.key,
        this.id,
        this.quantity,
        this.name,
        this.sku,
        this.permalink,
        this.line_price,
        this.variation,
        this.image
      });

  Cart.fromJson(Map<String, dynamic> Cart)
      : key = Cart['key'],
        id = Cart['id'],
        quantity = Cart['quantity'],
        name = Cart['name'],
        sku = Cart['sku'],
        permalink = Cart['permalink'],
        line_price = Cart['line_price'],
        variation = Cart['variation'],
        image = getImages(Cart);

   Map<String, dynamic> toJson() => {
     'key':key,
     'id':id,
     'quantity': quantity,
     'name': name,
     'sku': sku,
     'permalink': permalink,
     'line_price': line_price,
     'variation': variation,
     'image': image
       };
}
/*
class CartModel {
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
  int cartQuantity;
  String cartPrice;
  String cartLinePrice;
  List<String> cartVariation;

  CartModel(
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

  static List getImages(product){
    //parse the product's images
    List<AnyImage> imagesOfProductList = [];

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

    return imagesOfProductList;
  }

  static List categoriesOfProductList(product){
    //parse the product's images
    //parse the product's categories
    List<Category> categoriesOfProductList = [];

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

  static int getDiscount(product){
    //parse new product's details
    var regularprice = int.tryParse(product["regular_price"]) ?? 0;
    var saleprice = int.tryParse(product["sale_price"]) ?? 0;
    var disc = 0;
    if(regularprice > 0 && saleprice>0)
      disc = ((((regularprice - saleprice) / (regularprice)) * 100)).round();
    return disc;
  }

  CartModel.fromJson(Map<String, dynamic> product)
      : productId= product["productId"],
        productName= product["productName"],
        description= product["description"],
        regularPrice= product["regularPrice"],
        salePrice= product["salePrice"],
        stockQuantity= product["stockQuantity"],
        ifItemAvailable= product["ifItemAvailable"],
        discount= product["discount"],
        images = product["images"],
        categories= product["categories"],
        permalink= product["permalink"],
        cartKey = "",
        cartQuantity = product["cartQuantity"],
        cartPrice = product["cartPrice"],
        cartLinePrice = product["cartLinePrice"],
        cartVariation = product["cartVariation"];

  CartModel.fromJson(Map<String, dynamic> product)
      : productId= product["id"],
        productName= product["name"],
        description= product["description"],
        regularPrice= product["regular_price"],
        salePrice= product["sale_price"],
        stockQuantity= product["stock_quantity"] != null ? newProduct["stock_quantity"] : 0,
        ifItemAvailable= (newProduct["on_sale"] && newProduct["purchasable"] && (newProduct['stock_status'] == 'instock')), //newProduct["in_stock"]
        discount= getDiscount(newProduct),
        images = getImages(newProduct),
        categories= categoriesOfProductList(newProduct),
        permalink= product["permalink"],
        cartKey = "",
        cartQuantity = product["cartQuantity"],
        cartPrice = product["cartPrice"],
        cartLinePrice = product["cartLinePrice"],
        cartVariation = product["cartVariation"];


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
        'permalink': permalink,
        'cartKey': cartKey,
        'cartQuantity': cartQuantity,
        'cartPrice': cartPrice,
        'cartLinePrice': cartLinePrice,
        'cartVariation': cartVariation
      };

  @override
  toString() => "productId: $productId , productName: $productName";

}*/