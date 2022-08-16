class Country {
  String name;
  String img;
  int from;
  int to;

  Country(this.name, this.img, this.from, this.to);

  Country.fromMap(Map data)
      : name = data['name'],
        img = data['img'],
        from = data['from'],
        to = data['to'];
}
