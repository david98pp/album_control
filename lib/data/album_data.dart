import 'package:album_control/data/data.dart';
import 'package:album_control/model/country_model.dart';
import 'package:album_control/model/group_model.dart';
import 'package:album_control/model/sticker_model.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../storage/db_repository.dart';

class AlbumData extends ChangeNotifier {
  final DBRepository _base = DBRepository();
  List<Group> groupList = [];
  List<Sticker> stickerList = [];
  bool loading = true;

  AlbumData() {
    verifyData();
  }

  Future<void> verifyData() async {
    try {
      var dataBase = await _base.get("groups");
      var version = await _base.get("version");
      var data = Data().toJson();
      if (dataBase.isEmpty || version.isEmpty) {
        await loadInitialData(data);
      } else if (data['version']['number'] != version['number']) {
        await loadInitialData(data);
      }
      await initData();
      await generateStickerList();
      loading = false;
      notifyListeners();
    } catch (e) {
      print("Error al preparar app config. $e");
    }
  }

  Future<void> loadInitialData(Map data) async {
    await _base.set('groups', data['groups']);
    await _base.set('version', data['version']);
  }

  Future<void> initData() async {
    Map data = await _base.get("groups");
    data.forEach((key, value) {
      List<Country> countryList = [];
      if (key == 'Grupo 0') {
        countryList.add(Country.fromMap(value));
      } else {
        Map countriesMap = value['countries'];
        for (var v in countriesMap.values) {
          countryList.add(Country.fromMap(v));
        }
      }
      groupList.add(Group(value['name'], countryList));
    });
  }

  Future<void> generateStickerList() async {
    Map stickers = await _base.get('stickers');
    Map duplicated = {};
    groupList
        .map((g) => g.countries.map((c) {
              for (num i in range(c.from, c.to + 1)) {
                stickerList.add(Sticker.params(i.toInt(), c.name, g.groupName, stickers.isNotEmpty ? stickers[i.toString()] ?? 0 : 0));
                if (stickers.isEmpty) {
                  duplicated[i.toString()] = 0;
                }
              }
            }).toList())
        .toList();
    if (stickers.isEmpty) {
      await _base.set('stickers', duplicated);
    }
  }

  Future<void> saveStickerUpdate(Sticker sticker) async {
    Map stickers = await _base.get('stickers');
    Map duplicated = {};
    duplicated.addAll(stickers);
    duplicated[sticker.number.toString()] = sticker.repeated;
    await _base.set('stickers', duplicated);
  }
}
