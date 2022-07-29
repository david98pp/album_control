import 'package:album_control/model/country.dart';
import 'package:album_control/model/data.dart';
import 'package:album_control/model/group_model.dart';
import 'package:album_control/model/sticker_model.dart';
import 'package:flutter/material.dart';
import '../storage/db_repository.dart';
import 'package:quiver/iterables.dart';

class AlbumData extends ChangeNotifier {
  final DBRepository _base = DBRepository();
  List<GroupModel> groupList = [];
  List<StickerModel> stickerList = [];
  bool loading = true;

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
      generateStickerList();
    } catch (e) {
      print("Error al preparar app config. $e");
    }
  }

  Future<void> loadInitialData(Map data) async {
    await _base.set('groups', data['groups']);
    await _base.set('version', data['version']);
    await initData();
  }

  Future<void> initData() async {
    Map data = await _base.get("groups");
    data.forEach((key, value) {
      if (key == 'Grupo 0') {
      } else {
        Map countriesMap = value['countries'];
        List<Country> countryList = [];
        for (var v in countriesMap.values) {
          countryList.add(Country.fromMap(v));
        }
        groupList.add(GroupModel(value['name'], countryList));
      }
    });
  }

  Future<void> generateStickerList() async {
    Map stickers = await _base.get('stickers');
    groupList.map((g) => g.countries.map((c) {
          for (num i in range(c.from, c.to)) {
            ///TODO grabar la lista de stickers en la base del telefono
            stickerList.add(StickerModel.params(i.toInt(), c.name, g.groupName, stickers.isNotEmpty ? stickers[i.toInt()] : 0));
          }
        }));
  }
}
