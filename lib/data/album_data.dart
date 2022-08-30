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
  List<Group> groupRepeatedList = [];
  List<Group> groupMissingList = [];
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
        await loadInitialData(data, true);
      } else if (data['version']['number'] != version['number']) {
        await loadInitialData(data, false);
      }
      await initData();
      await generateStickerList();
      loading = false;
      notifyListeners();
    } catch (e) {
      print("Error al preparar app config. $e");
    }
  }

  Future<void> loadInitialData(Map data, bool isFirstTime) async {
    await _base.set('groups', data['groups']);
    await _base.set('version', data['version']);
    await _base.set('init', {'firstTime': isFirstTime});
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
              List<Sticker> _stickerListCopy = [];
              int j = g.groupName == 'Especiales' ? 0 : 1;
              for (num i in range(c.from, c.to + 1)) {
                stickerList.add(Sticker.params(i.toInt(), j.toString(), c.name, g.groupName, stickers.isNotEmpty ? stickers[i.toString()] ?? 0 : 0));
                _stickerListCopy.add(Sticker.params(i.toInt(), j.toString(), c.name, g.groupName, stickers.isNotEmpty ? stickers[i.toString()] ?? 0 : 0));
                j++;
                if (stickers.isEmpty) {
                  duplicated[i.toString()] = 0;
                }
              }
              c.stickerList = _stickerListCopy;
            }).toList())
        .toList();

    if (stickers.isEmpty) {
      await _base.set('stickers', duplicated);
    }

    final List<Group> _copyGroupList = [...groupList];
    groupMissingList = _copyGroupList;
    _copyGroupList.removeWhere((element) {
      var res = false;
      element.countries.removeWhere((e) {
        e.stickerList.removeWhere((el) {
          res = e.stickerList.every((elem) => elem.repeated != 0);
          return res;
        });
        return res;
      });
      return res;
    });

    final List<Group> _copyGroupListR = [...groupList];
    groupRepeatedList = _copyGroupListR;
    groupRepeatedList.removeWhere((element) {
      bool res = false;
      int i = 0;
      element.countries.removeWhere((e) {
        res = e.stickerList.every((e1) => e1.repeated < 2);
        if (!res) {
          i++;
        }
        return res;
      });
      return i == 0;
    });
    //  groupList;
    groupRepeatedList.map((e) => e.countries.map((el) => el.stickerList.removeWhere((element) => element.repeated < 2)).toList()).toList();
    // groupList;
    //   groupRepeatedList;
  }

  Future<void> saveStickerUpdate(Sticker sticker) async {
    Map stickers = await _base.get('stickers');
    Map duplicated = {};
    duplicated.addAll(stickers);
    duplicated[sticker.number.toString()] = sticker.repeated;
    await _base.set('stickers', duplicated);
  }
}
