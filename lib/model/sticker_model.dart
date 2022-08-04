import 'package:album_control/model/album_data.dart';
import 'package:album_control/model/country.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

class StickerModel with ChangeNotifier {
  int number = 0;
  String team = '';
  String group = '';
  int repeated = 0;

  StickerModel.params(this.number, this.team, this.group, this.repeated);

  StickerModel();

  Future<void> updateQuantity(StickerModel sticker) async {
    sticker.repeated += 1;
    await AlbumData().saveStickerUpdate(sticker);
    notifyListeners();
  }

  Future<void> updateQuantityTeams(Country country, List<StickerModel> list, int pos) async {
    StickerModel sticker = getSticker(country, list, pos);
    sticker.repeated += 1;
    await AlbumData().saveStickerUpdate(sticker);
    notifyListeners();
  }

  StickerModel getSticker(Country country, List<StickerModel> list, int pos) {
    int j = 0;
    int positionSticker = 0;
    for (num i in range(country.from, country.to + 1)) {
      if (pos == j) {
        positionSticker = i.toInt();
        break;
      } else {
        j++;
      }
    }
    return list[positionSticker];
  }
}
