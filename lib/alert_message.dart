import 'package:flutter/material.dart';

// del
void showDeleteSuccessAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete'),
        content: Text('Delete is successful!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ปิด dialog
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (Route<dynamic> route) => false);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void showDeleteErrorAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete'),
        content: Text('Delete is not success!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ปิด dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
