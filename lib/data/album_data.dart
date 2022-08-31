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
                stickerList.add(Sticker(i.toInt(), j.toString(), c.name, g.groupName, stickers.isNotEmpty ? stickers[i.toString()] ?? 0 : 0));
                _stickerListCopy.add(Sticker(i.toInt(), j.toString(), c.name, g.groupName, stickers.isNotEmpty ? stickers[i.toString()] ?? 0 : 0));
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
    fillAllStickers();
  }

  void fillAllStickers() {
    groupMissingList = getNewGroupsInstance();
    for (var element in groupMissingList) {
      element.countries = List.from(getNewCountriesInstance(element.countries));
      for (var element in element.countries) {
        element.stickerList = List.from(getNewStickerInstance(element.stickerList));
      }
    }
    groupMissingList.removeWhere((element) {
      bool res = false;
      int i = 0;
      element.countries.removeWhere((e) {
        res = e.stickerList.every((e1) => e1.repeated != 0);
        if (!res) {
          i++;
        }
        return res;
      });
      return i == 0;
    });

    groupRepeatedList = getNewGroupsInstance();
    for (var element in groupRepeatedList) {
      element.countries = List.from(getNewCountriesInstance(element.countries));
      for (var element in element.countries) {
        element.stickerList = List.from(getNewStickerInstance(element.stickerList));
      }
    }
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

    for (var e in groupRepeatedList) {
      for (var element in e.countries) {
        element.stickerList.removeWhere((element) => element.repeated < 2);
      }
    }
    for (var e in groupMissingList) {
      for (var element in e.countries) {
        element.stickerList.removeWhere((element) => element.repeated != 0);
      }
    }
  }

  Future<void> saveStickerUpdate(Country country, Sticker sticker) async {
    Map stickers = await _base.get('stickers');
    Map duplicated = {};
    duplicated.addAll(stickers);
    duplicated[sticker.number.toString()] = sticker.repeated;
    for (var e in groupMissingList) {
      for (var element in e.countries) {
        element.stickerList.firstWhere((element) => element == sticker);
      }
    }
    await _base.set('stickers', duplicated);
  }

  List<Group> getNewGroupsInstance() {
    return groupList.map((e) => Group(e.groupName, e.countries)).toList();
  }

  List<Country> getNewCountriesInstance(List<Country> lst) {
    // This function allows to perform a deep copy for the list:
    return lst.map((e) => Country(e.name, e.img, e.from, e.to, e.stickerList)).toList();
  }

  List<Sticker> getNewStickerInstance(List<Sticker> lst) {
    // This function allows to perform a deep copy for the list:
    return lst.map((e) => Sticker(e.number, e.text, e.team, e.group, e.repeated)).toList();
  }
}
