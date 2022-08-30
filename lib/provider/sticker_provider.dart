import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../data/album_data.dart';
import '../model/country_model.dart';
import '../model/sticker_model.dart';

class StickerProvider with ChangeNotifier {
  Future<void> updateQuantity(Sticker sticker) async {
    sticker.repeated += 1;
    await AlbumData().saveStickerUpdate(sticker);
    notifyListeners();
  }

  Future<void> updateQuantityModal(Sticker sticker, int quantity) async {
    sticker.repeated = quantity;
    await AlbumData().saveStickerUpdate(sticker);
    notifyListeners();
  }

  Future<void> updateQuantityTeams(Sticker sticker) async {
    sticker.repeated += 1;
    await AlbumData().saveStickerUpdate(sticker);
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
