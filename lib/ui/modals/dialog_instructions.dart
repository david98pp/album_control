import 'package:flutter/material.dart';

import '../../storage/db_repository.dart';

Future<void> showDialogInstructions(BuildContext context) async {
  final DBRepository _base = DBRepository();
  Map init = await _base.get("init");
  if (init['firstTime']) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Instrucciones'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/gifs/demo.gif", fit: BoxFit.contain),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Cada vez que presiones en un sticker incrementará su cantidad, si quieres editarlo solamente mantén presionado el sticker que quieras modificar',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                await _base.set('init', {'firstTime': false});
                Navigator.of(context).pop();
              },
              child: const Text('OK')),
        ],
      ),
    );
  }
}
