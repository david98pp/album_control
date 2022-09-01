import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../data/album_data.dart';
import '../model/country_model.dart';
import '../model/sticker_model.dart';

class StickerProvider with ChangeNotifier {
  Future<void> updateQuantityModal(Country country, Sticker sticker, int quantity, AlbumData album) async {
    sticker.repeated = quantity;
    await album.saveStickerUpdate(country, sticker);
    notifyListeners();
  }

  Future<void> updateQuantity(Country country, Sticker sticker, AlbumData album) async {
    sticker.repeated += 1;
    await album.saveStickerUpdate(country, sticker);
    notifyListeners();
  }

  Sticker getSticker(Country country, List<Sticker> list, int pos) {
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
