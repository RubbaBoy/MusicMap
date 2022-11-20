import 'package:flutter/material.dart';

void navTo(BuildContext context, Widget Function(BuildContext) builder) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: builder,
    ),
  );
}