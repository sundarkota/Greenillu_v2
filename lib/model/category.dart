import 'package:greenillu/model/any_image.dart';

class Category {
  int id;
  String name;
  int parent;
  String description;
  AnyImage image;
  int count;

  Category(
      {this.id,
        this.name,
        this.parent,
        this.description,
        this.image,
        this.count});

  Category.fromJson(Map<String, dynamic> Categ)
      : id = Categ['id'],
        name = Categ['name'],
        parent = Categ['parent'],
        description = Categ['description'],
        image = Categ['image'],
        count = Categ['count'];


  Map<String, dynamic> toJson() => {
    'id':id,
    'name': name,
    'parent': parent,
    'description': description,
    'image': image,
    'count': count
  };
}