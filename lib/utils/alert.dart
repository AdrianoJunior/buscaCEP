import 'package:flutter/material.dart';

alert(BuildContext context, String msg, {Function()? callback, String text = 'OK'}) {
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
              onPressed: () {
                if(callback != null) {
                  callback();
                }
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    },
  );
}
