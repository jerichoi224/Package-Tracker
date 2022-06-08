import 'package:flutter/material.dart';

Widget PaddedText(String text, {EdgeInsets? padding, TextStyle? style})
{
  return Container(
      padding: padding ?? EdgeInsets.all(5),
      child: Text(text,
        style: style ?? const TextStyle(
            color: Colors.black
        ),
      )
  );
}