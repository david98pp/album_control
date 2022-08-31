import 'package:album_control/model/sticker_model.dart';

class Country {
  String name;
  String img;
  int from;
  int to;
  List<Sticker> stickerList = [];

  Country(this.name, this.img, this.from, this.to, this.stickerList);

  Country.fromMap(Map data)
      : name = data['name'],
        img = data['img'],
        from = data['from'],
        to = data['to'];

  factory Country.copyWith(Country m) {
    return Country(m.name, m.img, m.from, m.to, m.stickerList);
  }
}
