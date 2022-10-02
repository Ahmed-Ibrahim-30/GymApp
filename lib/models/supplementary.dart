class Supplementary {
  final int id;
  final String title;
  final String description;
  final int price;
  final String picture;
  Supplementary(
      {this.id, this.title, this.description, this.price, this.picture});

  factory Supplementary.fromJson(Map<String, dynamic> jsonData) {
    return Supplementary(
      id: jsonData['id'],
      title: jsonData['title'],
      description: jsonData['description'],
      price: jsonData['price'],
      picture: jsonData['picture'],
    );
  }
}
