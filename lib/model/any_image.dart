class AnyImage {
  int id;
  String imageDescription;
  String imageURL;
  String title;
  String alt;

  AnyImage({
    this.id,
    this.imageDescription,
    this.imageURL,
    this.alt,
    this.title,
  });


  AnyImage.fromJson(Map<String, dynamic> Imag)
      : id = Imag['id'],
        imageDescription = Imag['imageDescription'],
        title = Imag['title'],
        imageURL = Imag['imageURL'],
        alt = Imag['alt'];


  Map<String, dynamic> toJson() => {
    'id':id,
    'imageDescription': imageDescription,
    'title': title,
    'imageURL': imageURL,
    'alt': alt
  };
}