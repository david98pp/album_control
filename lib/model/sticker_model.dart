import 'package:flutter/material.dart';

class Sticker with ChangeNotifier {
  int number = 0;
  String team = '';
  String group = '';
  int repeated = 0;

  Sticker.params(this.number, this.team, this.group, this.repeated);

  Sticker();

  void updateQuantity(Sticker sticker) {
    sticker.repeated += 1;
    notifyListeners();
  }
}
