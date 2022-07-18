import 'package:album_control/model/group_model.dart';
import 'package:album_control/model/sticker_model.dart';
import 'package:flutter/material.dart';
import '../storage/db_repository.dart';

class AlbumData extends ChangeNotifier {
  final DBRepository _base = DBRepository();
  late List<GroupModel> _lista;

  void initData() async {
    var config = await _base.get("configApp");
    Map data = config['data'];
    if (config.isNotEmpty) {
      data.forEach((key, value) {
        if (key == 'Grupo 0 ') {
        } else {
          _lista.add(GroupModel(value['name'], value['countries']));
        }
      });
    }
  }
}
