import 'package:album_control/provider/sticker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/sticker_model.dart';

void showDialogUpdate(BuildContext context, Sticker sticker, StickerProvider providerSticker) {
  TextEditingController controller = TextEditingController(text: sticker.repeated.toString());

  String? numberValidator(String? value) {
    if (value == null) {
      return null;
    }
    final n = int.tryParse(value);
    if (n == null || n < 0) {
      return '"$value" no es número válido';
    }
    return null;
  }

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Modificar Sticker ${sticker.number.toString()}'),
      content: Form(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => controller.text = ((int.tryParse(controller.text) ?? 0) > 0 ? (int.tryParse(controller.text) ?? 1) - 1 : 0).toString(),
              icon: const Icon(Icons.minimize_sharp),
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                validator: (s) => numberValidator(s),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            IconButton(
              onPressed: () => controller.text = ((int.tryParse(controller.text) ?? 0) + 1).toString(),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await providerSticker.updateQuantityModal(sticker, int.tryParse(controller.text) ?? sticker.repeated);
              navigator.pop();
            },
            child: const Text('Grabar')),
      ],
    ),
  );
}
