class Genre {
  late String name;
  late int id;

  Genre(this.name, this.id);

  Genre.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    name = parsedJson["name"];
  }
}
