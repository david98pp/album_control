import 'package:flutter/material.dart';

void showDialogAbout(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Información'),
      content: const Text(
          'Programa desarrollado por David Pineda, si te gustó no olvides calificarnos en las tiendas.\nSi tienes alguna duda o quieres un desarrollo personalizado, contáctame en: \n- luisdavidpineda@gmail.com\n- LinkedIn: @david98pp'),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
      ],
    ),
  );
}
