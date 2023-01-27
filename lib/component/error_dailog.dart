import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message!),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
