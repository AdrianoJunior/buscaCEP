import 'package:flutter/material.dart';

alertCancel(BuildContext context, String msg, {Function()? callback, String text = 'OK'}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text("Busca CEP"),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: Text(text),
              onPressed: () async {
                if(callback != null) {
                  await callback();
                  Navigator.pop(context);
                }

              },
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
