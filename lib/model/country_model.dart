import 'package:album_control/model/sticker_model.dart';

class Country {
  String name;
  String img;
  int from;
  int to;
  List<Sticker> stickerList = [];

  Country.fromMap(Map data)
      : name = data['name'],
        img = data['img'],
        from = data['from'],
        to = data['to'];
}
