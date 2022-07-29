import 'package:flutter/material.dart';

class StickerModel with ChangeNotifier {
  int number = 0;
  String team = '';
  String group = '';
  int repeated = 0;

  StickerModel.params(this.number, this.team, this.group, this.repeated);

  StickerModel();

  void updateQuantity(StickerModel sticker) {
    sticker.repeated += 1;
    notifyListeners();
  }
}
