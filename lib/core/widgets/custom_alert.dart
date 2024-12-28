import 'package:flutter/material.dart';

class CustomAlert {
  final String title;
  final String content;
  final VoidCallback onDisable;
  final VoidCallback onEnable;

  const CustomAlert({
    required this.title,
    required this.content,
    required this.onDisable,
    required this.onEnable,
  });

  Future<void> show(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Disable'),
                onPressed: () {
                  onDisable();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Enable'),
                onPressed: () {
                  onEnable();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
