import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../main.dart';
import '../../model/sticker_model.dart';

void showDialogStatistics(BuildContext context, List<Sticker> listSticker) {
  List<Sticker> listMissing = [...listSticker];
  listMissing.removeWhere((element) => element.repeated != 0);

  List<Sticker> listRepeated = [...listSticker];
  listRepeated.removeWhere((element) => element.repeated < 2);

  List<Sticker> listHave = [...listSticker];
  listHave.removeWhere((element) => element.repeated == 0);

  Map<String, double> dataMap = {
    "Falta": listMissing.length / listSticker.length * 100,
    "Completo": listHave.length / listSticker.length * 100,
  };

  showDialog(
    context: context,
    builder: (_) => LayoutBuilder(
      builder: (context, constraints) => AlertDialog(
        title: const Text('Estadísticas'),
        content: SizedBox(
          height: constraints.maxHeight * 0.30,
          width: constraints.maxWidth,
          child: Column(
            children: [
              Expanded(
                child: PieChart(
                  dataMap: dataMap,
                  colorList: [
                    getMaterialColorFromColor(const Color.fromARGB(255, 110, 18, 52)),
                    getMaterialColorFromColor(const Color.fromARGB(255, 110, 18, 52)).shade300,
                  ],
                ),
              ),
              Text('Faltan: ${listMissing.length}'),
              Text('Repetidos: ${listRepeated.length}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    ),
  );
}
